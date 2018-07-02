FROM nginx:alpine

ENV WWW_DIR /var/www/registry-ui
ENV TMP_DIR /tmp/registry-ui
ENV UI_VERSION v2

RUN mkdir -pv $WWW_DIR $TMP_DIR

RUN apk --no-cache add \
    coreutils \
    git \
    nodejs \
    unzip \
    wget \
    autoconf \
    build-base \
    automake \
    nasm \
    zlib-dev

RUN wget https://github.com/kwk/docker-registry-frontend/archive/$UI_VERSION.zip && \
    unzip $UI_VERSION.zip && \
    mv docker-registry-frontend-2/* $TMP_DIR && ls $TMP_DIR


RUN cd $TMP_DIR && \
    npm install && \
    node_modules/bower/bin/bower install --allow-root && \
    node_modules/grunt-cli/bin/grunt build --allow-root && \
    mv dist/* $WWW_DIR

COPY default.conf /etc/nginx/conf.d/default.conf
ENV VIRTUAL_HOST registry.lan
RUN envsubst '\$VIRTUAL_HOST' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf


EXPOSE 80

