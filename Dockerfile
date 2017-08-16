FROM centos:centos7

# Install any required system packages. We need the Apache httpd web
# server in this instance, plus the 'rsync' package so we can copy
# files into the running container if necessary.

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum install -y centos-release-scl scl-utils && \
    PACKAGES="httpd24 httpd24-httpd-devel httpd24-mod_auth_kerb httpd24-mod_ldap httpd24-mod_session rsync" && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus ${PACKAGES} && \
    yum -y install --setopt=tsflags=nodocs --enablerepo=centosplus https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install --setopt=tsflags=nodocs --enablerepo=centosplus rubygem-asciidoctor && \
    rpm -V ${PACKAGES} && \
    yum clean all -y

# Create a non root account called 'default' to be the owner of all the
# files which the Apache httpd server will be hosting. This account
# needs to be in group 'root' (gid=0) as that is the group that the
# Apache httpd server would use if the container is later run with a
# unique user ID not present in the host account database, using the
# command 'docker run -u'.

ENV HOME=/opt/app-root

RUN mkdir -p ${HOME} && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
            -c "Default Application User" default

# Modify the default Apache configuration to listen on a non privileged
# port of 8080 and log everything to stdout/stderr. Also include our own
# configuration file so we can override other configuration.

RUN mkdir -p ${HOME}/htdocs && \
    sed -ri -e 's/^Listen 80$/Listen 8080/' \
            -e 's%"logs/access_log"%"/proc/self/fd/1"%' \
            -e 's%"logs/error_log"%"/proc/self/fd/2"%' \
            /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    echo "Include ${HOME}/httpd.conf" >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf

COPY openshift/httpd.conf ${HOME}/httpd.conf

EXPOSE 8080

# Copy into place S2I builder scripts, the run script, and label the Docker
# image so that the 's2i' program knows where to find them.

COPY openshift/s2i ${HOME}/s2i
COPY openshift/run ${HOME}/run

LABEL io.k8s.description="S2I builder for hosting files with Apache HTTPD server" \
      io.k8s.display-name="Apache HTTPD Server" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,httpd" \
      io.openshift.s2i.scripts-url="image://${HOME}/s2i/bin"

# Fixup all the directories under the account so they are group writable
# to the 'root' group (gid=0) so they can be updated if necessary, such
# as would occur if using 'oc rsync' to copy files into a container.

ADD images /opt/app-root/htdocs/images
ADD *.adoc /opt/app-root/htdocs/
RUN for i in $(ls -1 /opt/app-root/htdocs/*_*.adoc | grep -v 0_toc); do sed -i 's/0_toc.adoc/index.html/g' $i; done
RUN sed -e 's/\.adoc/\.html/g' /opt/app-root/htdocs/0_toc.adoc > /opt/app-root/htdocs/index.adoc
RUN asciidoctor /opt/app-root/htdocs/*.adoc -D /opt/app-root/htdocs/
RUN rm -rf /opt/app-root/htdocs/*.adoc

RUN chown -R 1001:0 /opt/app-root && \
    find ${HOME} -type d -exec chmod g+ws {} \;

# Ensure container runs as non root account from its home directory.

WORKDIR ${HOME}

USER 1001

# Set the Apache httpd server to be run when the container is run.

CMD [ "/opt/app-root/run" ]
