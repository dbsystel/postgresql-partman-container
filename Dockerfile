ARG POSTGRESQL_VERSION="17"
ARG JOBMON_VERSION="v1.4.1"
ARG PARTMAN_VERSION="v5.2.4"

FROM postgres:$POSTGRESQL_VERSION-alpine AS builder
LABEL org.opencontainers.image.source="https://github.com/dbsystel/postgresql-partman-container"
ARG JOBMON_VERSION
LABEL de.dbsystel.jobmon-version=$JOBMON_VERSION
ARG PARTMAN_VERSION
LABEL de.dbsystel.partman-version=$PARTMAN_VERSION
ARG POSTGRESQL_VERSION
LABEL de.dbsystel.postgres-version=$POSTGRESQL_VERSION
ARG JOBMON_CHECKSUM="db67c068ecdc136305eafb25bd8fc737f6b9944d4ef3d59ecf7006933686e272995b1733f1fa1a72bd932443669b26e25647701190d92419226b774707d8cc44"
ARG PARTMAN_CHECKSUM="8328a00ce1a55a5c9173d4adbf251e784fed62413fb76bba89dd893749a720a5ecb25ee668eb0b826b8e1f2b89d9dd7da219fd797bfd9ab1a43d05f5b3ac494f"
USER root

RUN apk add --no-cache wget gcc make musl-dev postgresql-dev $DOCKER_PG_LLVM_DEPS

RUN wget "https://github.com/omniti-labs/pg_jobmon/archive/refs/tags/${JOBMON_VERSION}.tar.gz" \
    && echo "${JOBMON_CHECKSUM}  ${JOBMON_VERSION}.tar.gz" | sha512sum -c \
    && tar zxf ${JOBMON_VERSION}.tar.gz && cd pg_jobmon-${JOBMON_VERSION#v}\
    && make \
    && make install

RUN wget "https://github.com/pgpartman/pg_partman/archive/refs/tags/${PARTMAN_VERSION}.tar.gz" \
    && echo "${PARTMAN_CHECKSUM}  ${PARTMAN_VERSION}.tar.gz" | sha512sum -c \
    && tar zxf ${PARTMAN_VERSION}.tar.gz && cd pg_partman-${PARTMAN_VERSION#v}\
    && make \
    && make install

FROM postgres:$POSTGRESQL_VERSION-alpine
LABEL org.opencontainers.image.source="https://github.com/dbsystel/postgresql-partman-container"
ARG JOBMON_VERSION
LABEL de.dbsystel.jobmon-version=$JOBMON_VERSION
ARG PARTMAN_VERSION
LABEL de.dbsystel.partman-version=$PARTMAN_VERSION
ARG POSTGRESQL_VERSION
LABEL de.dbsystel.postgres-version=$POSTGRESQL_VERSION

COPY --from=builder /usr/local/share/postgresql/extension/pg_jobmon* /usr/local/share/postgresql/extension/
COPY --from=builder /usr/local/share/postgresql/extension/pg_partman* /usr/local/share/postgresql/extension/
COPY --from=builder /usr/local/lib/postgresql/pg_partman_bgw.so /usr/local/lib/postgresql/
COPY --from=builder pg_partman-*/bin/common/* /usr/local/bin/

USER postgres
