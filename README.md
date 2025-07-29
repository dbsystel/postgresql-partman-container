# PostgreSQL container image with pg_partman

This repo is meant to provide an OCI (Docker) container image that is based on the official [postgres](https://hub.docker.com/_/postgres) image in the alpine variant, that comes preinstalled with the [pg_partman](https://github.com/pgpartman/pg_partman) and [pg_jobmon](https://github.com/omniti-labs/pg_jobmon) PostgreSQL extensions.

It pushes a nightly latest image of all tag versions to [ghcr.io](https://github.com/orgs/dbsystel/packages/container/package/postgresql-partman)

## Usage

```shell
docker run ghcr.io/dbsystel/postgresql-partman
docker run ghcr.io/dbsystel/postgresql-partman:{14,15,16,17}
docker run ghcr.io/dbsystel/postgresql-partman:{14-4,15-4,16-4,17-4}
docker run ghcr.io/dbsystel/postgresql-partman:{14-5,15-5,16-5,17-5}
```

The first part of the tag represents the PostgreSQL major version, the second part represents the partman major version. If you leave out the second part, you will get the default version of partman as specified by this repository. Be aware, that this can change without notice.

You can find out the actual versions used by looking at the labels of an image.

`docker inspect ghcr.io/dbsystel/postgresql-partman:17`

````
  "de.dbsystel.partman-version" : "v5.2.4",
  "de.dbsystel.postgres-version" : "17",
````

## Development

### test-build.sh

The `test-build.sh` script builds all PostgreSQL and partman version combinations locally for testing purposes. It extracts version information from the GitHub workflow to ensure consistency.

```shell
./test-build.sh
```

This builds Docker images for all supported PostgreSQL versions with both partman v4 and v5, tagged as `test-partman:{pg_version}-{partman_major}`.

## License

This project is licensed under the Apache-2.0 license, see [LICENSE](LICENSE).
