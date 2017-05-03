FROM       registry.access.redhat.com/rhscl/php-70-rhel7:latest
MAINTAINER Samuel Terburg <sterburg@redhat.com>
LABEL      io.k8s.description="S2I Builder Images for PHP+NodeJS" \
           io.k8s.display-name="PHP+NodeJS S2I Image" \
           io.openshift.tags="builder,php,nodejs,nodejs4"

ENV NODEJS_VERSION=4 \
    NPM_RUN=start \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

USER 0

RUN yum repolist > /dev/null && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum-config-manager --enable rhel-7-server-ose-3.2-rpms && \
    yum-config-manager --disable epel >/dev/null || : && \
    INSTALL_PKGS="rh-nodejs4 rh-nodejs4-npm rh-nodejs4-nodejs-nodemon nss_wrapper" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

RUN  mv $STI_SCRIPTS_PATH/assemble $STI_SCRIPTS_PATH/assemble-php
COPY ./s2i/bin/ $STI_SCRIPTS_PATH/

USER 1001
