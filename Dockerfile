FROM debian:stretch

MAINTAINER Vitaliy Filippov

ADD etc/apt/apt.conf /etc/apt/apt.conf
ADD etc/locale.gen /etc/locale.gen

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" install -y wget git zip unzip poppler-utils locales procps cron \
    graphviz patchutils sphinxsearch mc nginx perl mariadb-server libreoffice libdbi-perl libdatetime-perl libemail-address-perl \
    libtemplate-perl libjson-perl libemail-mime-perl libtest-taint-perl \
    libxml-twig-perl libtext-tabulardisplay-perl libemail-sender-perl \
    liblingua-translit-perl libarchive-zip-perl libdbd-mysql-perl libimage-magick-perl \
    libgd-perl libtemplate-plugin-gd-perl libgd-graph-perl libgd-graph3d-perl \
    libmail-rfc822-address-perl libemail-reply-perl \
    libdevel-stacktrace-perl libemail-mime-attachment-stripper-perl \
    libsoap-lite-perl libxmlrpc-lite-perl libjson-rpc-perl libjson-xs-perl libtext-csv-perl libhtml-strip-perl \
    libtext-csv-xs-perl libspreadsheet-parseexcel-perl libspreadsheet-xlsx-perl \
    liblingua-stem-snowball-perl libtheschwartz-perl \
    libdaemon-generic-perl libhttp-server-simple-perl libnet-server-perl build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD etc /etc

RUN service mysql start && echo "CREATE DATABASE bugzilla; \
    GRANT ALL PRIVILEGES ON bugzilla.* TO bugzilla@localhost IDENTIFIED BY 'bugzilla'; \
    FLUSH PRIVILEGES;" | mysql --defaults-file=/etc/mysql/debian.cnf

RUN cpan Module::Build CGI Math::Random::Secure Sys::Sendfile Date::Parse Text::Wrap MIME::Parser

RUN mkdir /home/data && \
    mv /var/lib/mysql /home/data/mysql && \
    mv /var/lib/sphinxsearch /home/data/sphinxsearch && \
    ln -s /home/data/mysql /var/lib/mysql && \
    ln -s /home/data/sphinxsearch /var/lib/sphinxsearch && \
    rm /etc/nginx/sites-enabled/default && \
    mkdir /home/data/logs && \
    mv /var/log/nginx /home/data/logs && \
    ln -s /home/data/logs/nginx /var/log/nginx && \
    mv /var/log/mysql /home/data/logs && \
    ln -s /home/data/logs/mysql /var/log/mysql && \
    mv /var/log/sphinxsearch /home/data/logs && \
    ln -s /home/data/logs/sphinxsearch /var/log/sphinxsearch && \
    cd /home && \
    git clone -b beta https://github.com/vitalif/bugzilla-4intranet bugzilla && \
    cd /home/bugzilla && \
    mv data /home/data/bugzilla && \
    chown www-data:www-data /home/data/bugzilla && \
    ln -s /home/data/bugzilla data

ADD home /home

RUN service sphinxsearch start && \
    service mysql start && \
    cd /home/bugzilla && \
    ./checksetup.pl answers && \
    rm answers

# Update image incrementally

# ADD bugzilla4intranet-version /etc/bugzilla4intranet-version

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" dist-upgrade -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN service sphinxsearch start && \
    service mysql start && \
    cd /home/bugzilla && \
    git pull && \
    ./checksetup.sh

CMD /home/start.sh

EXPOSE 80
