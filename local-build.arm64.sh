set -ex

# example
# To build locally:
# ./local-build.sh
# ./local-build.sh version=unstable skipCommitChecks=1
# ./local-build.sh version=unstable skipCommitChecks=1 image=full
# To build from CI:
# ./local-build.sh version=stable platform=linux/amd64 type=ci step=push pushTag=22.4.0
# TO build locally on ARM64
# ./local-build.sh skipCommitChecks=1 platform=linux/arm64 image=normal

source bash-helpers.sh

# default arg values
version=stable
skipCommitChecks=1
platform=linux/arm64

for argument in "$@"; do
    key=$(echo $argument | cut -f1 -d=)

    key_length=${#key}
    value="${argument:$key_length+1}"

    export "$key"="$value"
done

echo "version          = $version"
echo "platform         = $platform"
echo "type             = $type"
echo "skipCommitChecks = $skipCommitChecks"
echo "step             = $step"
echo "currentTag       = $currentTag"
echo "pushTag          = $pushTag"
echo "image            = $image"

# get version number from build-matrix.json (stable or unstable)
# note: we get the last commit id from a branch to detect last changes in a branch

ORTHANC_COMMIT_ID=$(getCommitId "Orthanc" $version docker $skipCommitChecks)
ORTHANC_GDCM_COMMIT_ID=$(getCommitId "Orthanc-gdcm" $version docker $skipCommitChecks)
ORTHANC_PG_COMMIT_ID=$(getCommitId "Orthanc-postgresql" $version docker $skipCommitChecks)
ORTHANC_MYSQL_COMMIT_ID=$(getCommitId "Orthanc-mysql" $version docker $skipCommitChecks)
ORTHANC_TRANSFERS_COMMIT_ID=$(getCommitId "Orthanc-transfers" $version docker $skipCommitChecks)
ORTHANC_DW_COMMIT_ID=$(getCommitId "Orthanc-dicomweb" $version docker $skipCommitChecks)
ORTHANC_WSI_COMMIT_ID=$(getCommitId "Orthanc-wsi" $version docker $skipCommitChecks)
ORTHANC_OWV_COMMIT_ID=$(getCommitId "Orthanc-webviewer" $version docker $skipCommitChecks)
ORTHANC_AUTH_COMMIT_ID=$(getCommitId "Orthanc-auth" $version docker $skipCommitChecks)
ORTHANC_PYTHON_COMMIT_ID=$(getCommitId "Orthanc-python" $version docker $skipCommitChecks)
ORTHANC_ODBC_COMMIT_ID=$(getCommitId "Orthanc-odbc" $version docker $skipCommitChecks)
ORTHANC_INDEXER_COMMIT_ID=$(getCommitId "Orthanc-indexer" $version docker $skipCommitChecks)
ORTHANC_NEURO_COMMIT_ID=$(getCommitId "Orthanc-neuro" $version docker $skipCommitChecks)
ORTHANC_TCIA_COMMIT_ID=$(getCommitId "Orthanc-tcia" $version docker $skipCommitChecks)
ORTHANC_STONE_VIEWER_COMMIT_ID=$(getCommitId "Orthanc-stone" $version docker $skipCommitChecks)
ORTHANC_AWS_STORAGE_COMMIT_ID=$(getCommitId "Orthanc-aws-storage" $version docker $skipCommitChecks)
ORTHANC_OE2_COMMIT_ID=$(getCommitId "Orthanc-explorer-2" $version docker $skipCommitChecks)
ORTHANC_OE2_VERSION=$(getBranchTagToBuildDocker "Orthanc-explorer-2" $version)

BASE_DEBIAN_IMAGE=bullseye-20230202-slim
BASE_BUILDER_IMAGE_TAG=$BASE_DEBIAN_IMAGE-$version

###### runner-base
# buildx build --load to load the built contains to the local docker deamon
docker build \
    --progress=plain --platform=$platform -t osimis/orthanc-runner-base:$BASE_BUILDER_IMAGE_TAG \
    --build-arg BASE_DEBIAN_IMAGE=$BASE_DEBIAN_IMAGE \
    -f docker/orthanc/Dockerfile.runner-base docker/orthanc

###### builder-base
# buildx build to load the built contains to the local docker deamon
docker build --pull=false \
    --progress=plain --platform=$platform -t osimis/orthanc-builder-base:$BASE_BUILDER_IMAGE_TAG \
    --build-arg BASE_IMAGE_TAG=$BASE_BUILDER_IMAGE_TAG \
    -f docker/orthanc/Dockerfile.builder-base docker/orthanc

target='osimis/orthanc'

# sleep 5
###### osimis/orthanc
# buildx build to load the built contains to the local docker deamon
docker build \
    --progress=plain --platform=$platform \
    --build-arg ORTHANC_COMMIT_ID=$ORTHANC_COMMIT_ID \
    --build-arg ORTHANC_GDCM_COMMIT_ID=$ORTHANC_GDCM_COMMIT_ID \
    --build-arg ORTHANC_PG_COMMIT_ID=$ORTHANC_PG_COMMIT_ID \
    --build-arg ORTHANC_MYSQL_COMMIT_ID=$ORTHANC_MYSQL_COMMIT_ID \
    --build-arg ORTHANC_TRANSFERS_COMMIT_ID=$ORTHANC_TRANSFERS_COMMIT_ID \
    --build-arg ORTHANC_DW_COMMIT_ID=$ORTHANC_DW_COMMIT_ID \
    --build-arg ORTHANC_WSI_COMMIT_ID=$ORTHANC_WSI_COMMIT_ID \
    --build-arg ORTHANC_OWV_COMMIT_ID=$ORTHANC_OWV_COMMIT_ID \
    --build-arg ORTHANC_AUTH_COMMIT_ID=$ORTHANC_AUTH_COMMIT_ID \
    --build-arg ORTHANC_PYTHON_COMMIT_ID=$ORTHANC_PYTHON_COMMIT_ID \
    --build-arg ORTHANC_ODBC_COMMIT_ID=$ORTHANC_ODBC_COMMIT_ID \
    --build-arg ORTHANC_INDEXER_COMMIT_ID=$ORTHANC_INDEXER_COMMIT_ID \
    --build-arg ORTHANC_NEURO_COMMIT_ID=$ORTHANC_NEURO_COMMIT_ID \
    --build-arg ORTHANC_TCIA_COMMIT_ID=$ORTHANC_TCIA_COMMIT_ID \
    --build-arg ORTHANC_STONE_VIEWER_COMMIT_ID=$ORTHANC_STONE_VIEWER_COMMIT_ID \
    --build-arg ORTHANC_AWS_STORAGE_COMMIT_ID=$ORTHANC_AWS_STORAGE_COMMIT_ID \
    --build-arg ORTHANC_OE2_COMMIT_ID=$ORTHANC_OE2_COMMIT_ID \
    --build-arg ORTHANC_OE2_VERSION=$ORTHANC_OE2_VERSION \
    --build-arg BASE_IMAGE_TAG=$BASE_BUILDER_IMAGE_TAG \
    --tag osimis/orthanc:latest \
    -f docker/orthanc/Dockerfile.arm64 docker/orthanc/
