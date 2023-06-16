ARG POSTGRESQL_VERSION="13"
FROM bitnami/postgresql:$POSTGRESQL_VERSION
LABEL org.opencontainers.image.source="https://github.com/dbsystel/postgresql-partman-container"
ARG PARTMAN_VERSION="v4.7.3"
USER root
RUN install_packages wget gcc make build-essential
RUN cd /tmp \
    && wget "https://github.com/pgpartman/pg_partman/archive/refs/tags/${PARTMAN_VERSION}.tar.gz" \
    && export C_INCLUDE_PATH=/opt/bitnami/postgresql/include/:/opt/bitnami/common/include/ \
    && export LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/ \
    && export LD_LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/ \
    && tar zxf ${PARTMAN_VERSION}.tar.gz && cd pg_partman-${PARTMAN_VERSION#v}\
    && make \
    && make install \
    && cd .. && rm -r pg_partman-${PARTMAN_VERSION#v} ${PARTMAN_VERSION}.tar.gz

USER 1001
