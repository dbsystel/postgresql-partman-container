ARG POSTGRESQL_VERSION="16"
FROM bitnami/postgresql:$POSTGRESQL_VERSION AS builder
LABEL org.opencontainers.image.source="https://github.com/dbsystel/postgresql-partman-container"
ARG JOBMON_VERSION="v1.4.1"
LABEL de.dbsystel.jobmon-version=$JOBMON_VERSION
ARG PARTMAN_VERSION="v5.2.4"
LABEL de.dbsystel.partman-version=$PARTMAN_VERSION
ARG POSTGRESQL_VERSION
LABEL de.dbsystel.postgres-version=$POSTGRESQL_VERSION
ARG JOBMON_CHECKSUM="db67c068ecdc136305eafb25bd8fc737f6b9944d4ef3d59ecf7006933686e272995b1733f1fa1a72bd932443669b26e25647701190d92419226b774707d8cc44"
ARG PARTMAN_CHECKSUM="8328a00ce1a55a5c9173d4adbf251e784fed62413fb76bba89dd893749a720a5ecb25ee668eb0b826b8e1f2b89d9dd7da219fd797bfd9ab1a43d05f5b3ac494f"
USER root

RUN install_packages wget gcc make build-essential \
    && export C_INCLUDE_PATH=/opt/bitnami/postgresql/include/:/opt/bitnami/common/include/ \
    && export LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/ \
    && export LD_LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/

RUN wget "https://github.com/omniti-labs/pg_jobmon/archive/refs/tags/${JOBMON_VERSION}.tar.gz" \
    && echo "${JOBMON_CHECKSUM} ${JOBMON_VERSION}.tar.gz" | sha512sum --check \
    && tar zxf ${JOBMON_VERSION}.tar.gz && cd pg_jobmon-${JOBMON_VERSION#v}\
    && make \
    && make install

RUN wget "https://github.com/pgpartman/pg_partman/archive/refs/tags/${PARTMAN_VERSION}.tar.gz" \
    && echo "${PARTMAN_CHECKSUM} ${PARTMAN_VERSION}.tar.gz" | sha512sum --check \
    && tar zxf ${PARTMAN_VERSION}.tar.gz && cd pg_partman-${PARTMAN_VERSION#v}\
    && make \
    && make install

FROM bitnami/postgresql:$POSTGRESQL_VERSION
LABEL org.opencontainers.image.source="https://github.com/dbsystel/postgresql-partman-container"
ARG JOBMON_VERSION="v1.4.1"
LABEL de.dbsystel.jobmon-version=$JOBMON_VERSION
ARG PARTMAN_VERSION="v5.2.4"
LABEL de.dbsystel.partman-version=$PARTMAN_VERSION
ARG POSTGRESQL_VERSION
LABEL de.dbsystel.postgres-version=$POSTGRESQL_VERSION

COPY --from=builder pg_jobmon-${JOBMON_VERSION#v}/sql/pg_jobmon--${JOBMON_VERSION#v}.sql pg_jobmon-${JOBMON_VERSION#v}/pg_jobmon.control pg_partman-${PARTMAN_VERSION#v}/sql/pg_partman--${PARTMAN_VERSION#v}.sql pg_partman-${PARTMAN_VERSION#v}/pg_partman.control /opt/bitnami/postgresql/share/extension/
COPY --from=builder /opt/bitnami/postgresql/lib/pg_partman_bgw.so /opt/bitnami/postgresql/lib/pg_partman_bgw.so
COPY --from=builder pg_partman-${PARTMAN_VERSION#v}/bin/common/* /opt/bitnami/lib/postgresql/bin/

USER 1001
