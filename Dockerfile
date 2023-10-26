ARG POSTGRESQL_VERSION="13"
FROM bitnami/postgresql:$POSTGRESQL_VERSION
LABEL org.opencontainers.image.source="https://github.com/dbsystel/postgresql-partman-container"
ARG PARTMAN_VERSION="v4.7.3"
ARG PARTMAN_CHECKSUM="c0db6784e2d337645d8a1a89eb947635e547eab2be24545ebc52f02ee98098648cc00ae86adf677b196023e9290522a30b87b02081f782bfc8de4bd30c39980c"
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
