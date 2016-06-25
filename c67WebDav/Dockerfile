FROM centos:6.7
MAINTAINER Adam Lyon <lyon@fnal.gov>

RUN useradd -u 1000 -g 100 -M apache

RUN yum update -y && \
    yum install -y \
          httpd \
          emacs which && \
    yum clean all

RUN htpasswd -cb /tmp/webdav-login webdav webdav && \
    chown apache /tmp/webdav-login && \
    chgrp apache /tmp/webdav-login

EXPOSE 80

ADD startWebDav.sh /startWebDav.sh
RUN chmod -v +x /startWebDav.sh

CMD ["bash", "/startWebDav.sh"]
