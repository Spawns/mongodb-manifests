# Pull base image.
ARG IMAGE_REPOSITORY=registry.hub.docker.com/library
ARG IMAGE_NAME=centos
ARG IMAGE_TAG=7
FROM $IMAGE_REPOSITORY/$IMAGE_NAME:$IMAGE_TAG

#Default env variables
ENV MONGO_VERSION=4.0 \
    MONGO_CONFIG_DIR=/mongo/config \
    MONGO_PORT=2181

# Make dirs
RUN mkdir -p /mongo/log /mongo/data $MONGO_CONFIG_DIR /mongo/run

# Install MongoDB.
RUN yum -y update && \
    yum -y install epel-release && \
    echo -e "[mongodb-org-$MONGO_VERSION]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/$MONGO_VERSION/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-$MONGO_VERSION.asc" >> /etc/yum.repos.d/mongodb4.repo && \
    yum install -y mongodb-org && \
    yum clean all && \
    mkdir -p /mongo

# Define mountable directories.
VOLUME ["/mongo"]

# Define working directory.
WORKDIR /

# Expose ports for each Mongo replica set instance
EXPOSE $MONGO_PORT
EXPOSE $DOT_port

#Specify the docker entrypoint
COPY .deployment/docker/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

#Run mongo
CMD mongod --config ${MONGO_CONFIG_DIR}/${MONGO_ID}.conf
