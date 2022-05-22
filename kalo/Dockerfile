# syntax=docker/dockerfile:1

FROM centos:7

LABEL maintainer="kaloyansen@gmail.com"

ARG buildno
ARG gitcommithash
ARG workdir
ARG expose
ARG ipaddress

RUN echo "Build number: $buildno"
RUN echo "Based on commit: $gitcommithash"
RUN echo "workdir: $workdir"
RUN echo "expose: $expose"
RUN echo "ipaddress: $ipaddress"

################ update
RUN yum -y update

############### repositories
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

##################################### tools perl perl-cgi 
RUN yum -y install httpd httpd-tools curl tcsh nano file man perl perl-CGI perl-CGI-Session perl-DBI perl-DBD-MySQL perl-HTML-Template
# perl-DateTime-Format-MySQL
# perl-JSON perl-CGI-Application perl-Crypt-RC4

############################################### php 
# RUN yum -y install php php-mysqlnd php-pdo
RUN yum --enablerepo=remi-php73 -y install php php-bcmath php-cli php-common php-gd php-intl php-ldap php-mbstring php-mysqlnd php-pdo php-pear php-soap php-xml php-xmlrpc php-zip
# RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

################## apache configuration hmmm i do not like it
# RUN sed -E -i -e '/<Directory "\/var\/www\/cgi-bin\/bnotes">/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
# RUN sed -E -i -e 's/DirectoryIndex (.*)$/DirectoryIndex bnotes \1/g' /etc/httpd/conf/httpd.conf
RUN echo "ServerName $ipaddress" >> /etc/httpd/conf/httpd.conf
##################### envirenment has been gone to docker-compose.yml
# ADD ./src/root/.tcshrc /root/.tcshrc
# ADD ./src/root/.emacs /root/.emacs

#################### start apache
EXPOSE 80
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
WORKDIR /var/www/cgi-bin/bnotes

