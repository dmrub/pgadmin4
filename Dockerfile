FROM python:2-alpine
MAINTAINER fenglc <fenglc89@gmail.com>
MAINTAINER Dmitri Rubinstein <dmitri.rubinstein@dfki.de>

ENV PGADMIN_SERVER_MODE         True
ENV PGADMIN_SERVER_HOST         0.0.0.0
ENV PGADMIN_SERVER_PORT         5050
ENV PGADMIN_SETUP_EMAIL         ''
ENV PGADMIN_SETUP_PASSWORD      ''
ENV PGADMIN_DATA_DIR            ''
ENV PGADMIN_UID                 6000

ENV PGADMIN4_VERSION            1.1

COPY . /pgadmin4

RUN set -x \
        && apk add --no-cache su-exec \
        && apk add --no-cache postgresql-libs \
        && apk add --no-cache --virtual .build-deps \
                        gcc \
                        postgresql-dev \
                        musl-dev \
        && pip install -r /pgadmin4/requirements_py2.txt \
        && cd /pgadmin4/web/ \
        && cp config_docker.py config_local.py \
        && apk del .build-deps \
        && rm -rf /root/.cache

EXPOSE 5050

COPY docker-entrypoint.sh /

USER root
ENTRYPOINT ["/docker-entrypoint.sh"]
