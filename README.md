# Postgresql container with pg_partman

This repo is meant to provide a Docker container that is based on the popular [bitnami/postgresql](https://hub.docker.com/r/bitnami/postgresql) container, that comes preinstalled with the [pg_partman](https://github.com/pgpartman/pg_partman) postgresql extension.

It pushes a nightly latest image to ghcr.io

## Usage

```
docker run ghcr.io/dbsystel/postgresql-partman:13
docker run ghcr.io/dbsystel/postgresql-partman:14
docker run ghcr.io/dbsystel/postgresql-partman:15
docker run ghcr.io/dbsystel/postgresql-partman:16
```

The tags represent the postgresql major version. They will contain the latest available pg_partman version that was available at build time.

## License

This project is licensed under the Apache-2.0 license, see [LICENSE](LICENSE).
