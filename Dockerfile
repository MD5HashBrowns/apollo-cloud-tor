############################################################
# Dockerfile to build Apollo Cloud
############################################################

# Set the base image
FROM alpine:latest

# Original author is Carlos Tighe
MAINTAINER MD5HashBrowns

# Install packages
RUN apk add --update \
    apache2 \
    apache2-mod-wsgi \
    alpine-sdk \
    python \
    python-dev \
    py-pip \
    nano \
    ffmpeg \
    && rm -rf /var/cache/apk/*

# Copy over and install the requirements
COPY ./app/requirements.txt /var/www/apollo-cloud/app/requirements.txt
RUN pip install -r /var/www/apollo-cloud/app/requirements.txt

# Copy over the apache configuration file and enable the site
RUN mkdir /var/sites-enabled
COPY ./apollo-cloud.conf /var/sites-available/apollo-cloud.conf
RUN echo Include ../sites-enabled >> /etc/apache2/httpd.conf

# Copy over the wsgi file
COPY ./apollo-cloud.wsgi /var/www/apollo-cloud/apollo-cloud.wsgi

COPY ./run.py /var/www/apollo-cloud/run.py
COPY ./app /var/www/apollo-cloud/app/



# Set permissions for the static directory
RUN chmod -R 777 /var/www/apollo-cloud/app/static/  

EXPOSE 80

WORKDIR /var/www/apollo-cloud

# CMD ["/bin/bash"]
CMD /usr/sbin/httpd -D FOREGROUND
# The commands below get apache running but there are issues accessing it online
# The port is only available if you go to another port first
# ENTRYPOINT ["/sbin/init"]
# CMD ["/usr/sbin/apache2ctl"]
