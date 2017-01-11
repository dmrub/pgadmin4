FROM python:2-alpine
MAINTAINER fenglc <fenglc89@gmail.com>
MAINTAINER Dmitri Rubinstein <dmitri.rubinstein@dfki.de>

ENV SERVER_MODE                 True
ENV DEFAULT_SERVER_PORT         5050
ENV DEFAULT_SERVER              0.0.0.0
ENV PGADMIN_SETUP_EMAIL         ''
ENV PGADMIN_SETUP_PASSWORD      ''
ENV PGADMIN4_VERSION            1.1

COPY . /pgadmin4

RUN set -x \
        && apk add --no-cache postgresql-libs \
        && apk add --no-cache --virtual .build-deps \
                        gcc \
                        postgresql-dev \
                        musl-dev \
        && pip install -r  /pgadmin4/requirements_py2.txt \
        && cd /pgadmin4/web/ \
        && cp config.py config_local.py \
        && sed -i "s/SERVER_MODE = True/SERVER_MODE = ${SERVER_MODE}/g;s/DEFAULT_SERVER = 'localhost'/DEFAULT_SERVER = '${DEFAULT_SERVER}'/g" config_local.py \
        && sed -i "s/DEFAULT_SERVER_PORT = 5050/DEFAULT_SERVER_PORT = ${DEFAULT_SERVER_PORT}/g" config_local.py \
        && apk del .build-deps \
        && rm -rf /root/.cache

EXPOSE 5050

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
