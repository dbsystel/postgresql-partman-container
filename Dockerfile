ARG POSTGRESQL_VERSION="16"
FROM bitnami/postgresql:$POSTGRESQL_VERSION
LABEL org.opencontainers.image.source="https://github.com/dbsystel/postgresql-partman-container"
ARG PARTMAN_VERSION="v5.2.4"
LABEL de.dbsystel.partman-version=$PARTMAN_VERSION
ARG POSTGRESQL_VERSION
LABEL de.dbsystel.postgres-version=$POSTGRESQL_VERSION
ARG PARTMAN_CHECKSUM="8328a00ce1a55a5c9173d4adbf251e784fed62413fb76bba89dd893749a720a5ecb25ee668eb0b826b8e1f2b89d9dd7da219fd797bfd9ab1a43d05f5b3ac494f"
USER root
RUN install_packages wget gcc make build-essential
RUN cd /tmp \
    && wget "https://github.com/pgpartman/pg_partman/archive/refs/tags/${PARTMAN_VERSION}.tar.gz" \
    && echo "${PARTMAN_CHECKSUM} ${PARTMAN_VERSION}.tar.gz" | sha512sum --check \
    && export C_INCLUDE_PATH=/opt/bitnami/postgresql/include/:/opt/bitnami/common/include/ \
    && export LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/ \
    && export LD_LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/ \
    && tar zxf ${PARTMAN_VERSION}.tar.gz && cd pg_partman-${PARTMAN_VERSION#v}\
    && make \
    && make install \
    && cd .. && rm -r pg_partman-${PARTMAN_VERSION#v} ${PARTMAN_VERSION}.tar.gz

USER 1001
