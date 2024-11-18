ARG POSTGRESQL_VERSION="16"
FROM bitnami/postgresql:$POSTGRESQL_VERSION
LABEL org.opencontainers.image.source="https://github.com/dbsystel/postgresql-partman-container"
ARG PARTMAN_VERSION="v5.1.0"
LABEL de.dbsystel.partman-version=$PARTMAN_VERSION
ARG POSTGRESQL_VERSION
LABEL de.dbsystel.postgres-version=$POSTGRESQL_VERSION
ARG PARTMAN_CHECKSUM="42f527f93c7c4da957a84d4b81dafc4b37beed8fe66d2b4d908386c8ed2256f7356a8af7bdc8b0f4281c65a6ceded8d114a0c7db715dd2cc093a6b15c5ae23f4"
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
