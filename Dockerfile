FROM registry.access.redhat.com/rhscl/php-70-rhel7

MAINTAINER Christian Hernandez <chernand@redhat.com>

USER root:0

ENV PHP_VERSION=7.0 \
    PATH=$PATH:/opt/rh/rh-php70/root/usr/bin

ENV SUMMARY="Platform for building and running PHP $PHP_VERSION applications" \
    DESCRIPTION="PHP $PHP_VERSION available as docker container is a base platform for \
building and running various PHP $PHP_VERSION applications and frameworks. \
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers \
to write dynamically generated web pages. PHP also offers built-in database integration \
for several commercial and non-commercial database management systems, so writing \
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding \
is probably as a replacement for CGI scripts."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Apache 2.4 with PHP 7.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,php,php70,rh-php70" \
      name="rhscl/php-70-rhel7" \
      com.redhat.component="rh-php70-docker" \
      version="7.0" \
      release="5.0"

# Install Apache httpd and PHP
# To use subscription inside container yum command has to be run first (before yum-config-manager)
# https://access.redhat.com/solutions/1443553
RUN yum repolist > /dev/null && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    INSTALL_PKGS="rh-php70 rh-php70-php rh-php70-php-mysqlnd rh-php70-php-pgsql rh-php70-php-bcmath \
                  rh-php70-php-gd rh-php70-php-intl rh-php70-php-ldap rh-php70-php-mbstring rh-php70-php-pdo \
                  rh-php70-php-process rh-php70-php-soap rh-php70-php-opcache rh-php70-php-xml \
                  rh-php70-php-gmp" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install rubygem-asciidoctor
RUN yum clean all -y

# Copy extra files to the image.
COPY ./root/ /

ADD images /opt/app-root/src/
ADD *.adoc /opt/app-root/src/

RUN asciidoctor /opt/app-root/src/*.adoc -D /opt/app-root/src/
RUN rm -rf /opt/app-root/src/*.adoc

# In order to drop the root user, we have to make some directories world
# writeable as OpenShift default security model is to run the container under
# random UID.
RUN sed -i -f /opt/app-root/etc/httpdconf.sed /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    sed -i '/php_value session.save_path/d' /opt/rh/httpd24/root/etc/httpd/conf.d/rh-php70-php.conf && \
    head -n151 /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf | tail -n1 | grep "AllowOverride All" || exit && \
    echo "IncludeOptional /opt/app-root/etc/conf.d/*.conf" >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    mkdir /tmp/sessions && \
    chown -R 1001:0 /opt/app-root /tmp/sessions && \
    chmod -R a+rwx /tmp/sessions && \
    chmod -R ug+rwx /opt/app-root && \
    chmod -R a+rwx /etc/opt/rh/rh-php70 && \
    chmod -R a+rwx /opt/rh/httpd24/root/var/run/httpd

USER 1001

EXPOSE 8080
ENTRYPOINT ["httpd"]
CMD ["-D", "FOREGROUND"]
