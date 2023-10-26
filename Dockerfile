ARG POSTGRESQL_VERSION="13"
FROM bitnami/postgresql:$POSTGRESQL_VERSION
LABEL org.opencontainers.image.source="https://github.com/dbsystel/postgresql-partman-container"
ARG PARTMAN_VERSION="v4.7.4"
ARG PARTMAN_CHECKSUM="28e4fdb83ecc16525959ae9593bfbfd077db429285f5f7d8e2468bfff6cbdbf2c81ace79a9ddeb4f00f51eb709163dbd713fe6b221a432ac2ff766f98d4cf8e4"
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
