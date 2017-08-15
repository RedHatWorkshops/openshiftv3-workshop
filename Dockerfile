FROM registry.access.redhat.com/rhscl/php-70-rhel7

MAINTAINER Christian Hernandez <chernand@redhat.com>

USER root:0

RUN yum -y --enablerepo=rhel-server-rhscl-7-rpms update
RUN yum -y --enablerepo=rhel-server-rhscl-7-rpms update httpd24 httpd24-*
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install rubygem-asciidoctor

ADD images /opt/app-root/src/
ADD *.adoc /opt/app-root/src/

RUN asciidoctor /opt/app-root/src/*.adoc -D /opt/app-root/src/
RUN rm -rf /opt/app-root/src/*.adoc

RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

USER 1001

EXPOSE 8080
ENTRYPOINT ["/opt/rh/httpd24/root/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
