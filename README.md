# PostgreSQL container image with pg_partman

This repo is meant to provide an OCI (Docker) container image that is based on the popular [bitnami/postgresql](https://hub.docker.com/r/bitnami/postgresql) image, that comes preinstalled with the [pg_partman](https://github.com/pgpartman/pg_partman) PostgreSQL extension.

It pushes a nightly latest image of all tag versions to [ghcr.io](https://github.com/orgs/dbsystel/packages/container/package/postgresql-partman)

## Usage

```shell
docker run ghcr.io/dbsystel/postgresql-partman
docker run ghcr.io/dbsystel/postgresql-partman:{13,14,15,16}
docker run ghcr.io/dbsystel/postgresql-partman:{13-4,14-4,15-4,16-4}
docker run ghcr.io/dbsystel/postgresql-partman:{14-5,15-5,16-5}
```

The first part of the tag represents the PostgreSQL major version, the second part represents the partman major version. If you leave out the second part, you will get the default version of partman as specified by this repository. Be aware, that this can change without notice.

You can find out the actual versions used by looking at the labels of an image.

`docker inspect ghcr.io/dbsystel/postgresql-partman:13`

````
  "de.dbsystel.partman-version" : "v4.7.4",
  "de.dbsystel.postgres-version" : "13",
````

## License

This project is licensed under the Apache-2.0 license, see [LICENSE](LICENSE).
