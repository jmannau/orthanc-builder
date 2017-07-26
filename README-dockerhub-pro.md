# Orthanc for Docker
Docker image with [Orthanc](http://www.orthanc-server.com/) and its official plugins (including commercial plugins). Orthanc is a lightweight, RESTful Vendor Neutral Archive for medical imaging.

Full documentation is available in the [Orthanc Book](http://book.orthanc-server.com/users/docker.html).

Sample procedure (docker-compose file) to use this image is available [here](https://bitbucket.org/snippets/osimis/eynLn/running-orthanc-with-docker)

# packages content

#### 17.7.1
```

component                             version
---------------------------------------------
Orthanc server                        1.3.0
Osimis Web viewer plugin              1.0.0
Modality worklists plugin             1.3.0
Serve folders plugin                  1.3.0
Orthanc Web viewer plugin             2.3
DICOMweb plugin                       0.4
PostgreSQL plugin                     2.0
WSI Web viewer plugin                 0.4
Authorization plugin                  0.1.0

MSSql plugin                          0.4.1
Osimis Web viewer pro plugin          bd0f243 *
```

#### 17.7.0
```

component                             version
---------------------------------------------
Orthanc server                        1.3.0 *
Osimis Web viewer plugin              1.0.0 *
Modality worklists plugin             1.3.0 *
Serve folders plugin                  1.3.0 *
Orthanc Web viewer plugin             2.3   *
DICOMweb plugin                       0.4   *
PostgreSQL plugin                     2.0
WSI Web viewer plugin                 0.4
Authorization plugin                  0.1.0

MSSql plugin                          0.4.1
Osimis Web viewer pro plugin          bd0f243 *
```

#### 17.6.1
```

component                             version
---------------------------------------------
Orthanc server                        1.2.0
Osimis Web viewer plugin              0.9.1 *
Modality worklists plugin             1.2.0
Serve folders plugin                  1.2.0
Orthanc Web viewer plugin             2.2
DICOMweb plugin                       0.3
PostgreSQL plugin                     2.0
WSI Web viewer plugin                 0.4
Authorization plugin                  0.1.0

MSSql plugin                          0.4.1
Osimis Web viewer pro plugin          f017049 *

```


#### 17.5
```

component                             version
---------------------------------------------
Orthanc server                        1.2.0
Osimis Web viewer plugin              0.8.0
Modality worklists plugin             1.2.0
Serve folders plugin                  1.2.0
Orthanc Web viewer plugin             2.2
DICOMweb plugin                       0.3
PostgreSQL plugin                     2.0
WSI Web viewer plugin                 0.4
Authorization plugin                  0.1.0

MSSql plugin                          0.4.1
Osimis Web viewer pro plugin          preview

```

# Settings

#### Osimis Web Viewer Pro Plugin

Docker secrets:

- `wvp-licensestring`: Osimis-provided license string

#### MSSQL Plugin

Docker secrets:

- `mssql-connectionstring`: SQL Server connection string
- `mssql-licensestring`: Osimis-provided license string

#### Azure Storage Plugin

Docker secrets:

- `azstor-accname`: Azure Storage account name
- `azstor-acckey`: Azure Storage account key
- `azstor-licensestring`: Osimis-provided license string

Environment variables:

- `AZSTOR_CONTAINER` (default: "orthanc"): Azure Storage Blob service container name