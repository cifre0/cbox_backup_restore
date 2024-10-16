# source https://github.com/shakapark/Backup-Tool/blob/bishopp/Dockerfile
FROM alpine:latest

USER root

ENV DEBUG="false"

ENV ACTION="BACKUP|RESTORE"
ENV SRC_TYPE="BucketAWS|Postgres|AllPostgres|Mysql|Redis|backupAllPodK8sPostgresToBucket"

# PSQL
ENV POSTGRES_PASSWD=""
ENV POSTGRES_USERNAME="postgres"
ENV POSTGRES_HOST=""
ENV POSTGRES_PORT="5432"

# S3 Environments Variables
ENV S3_SOURCE_ACCESS_KEY=""
ENV S3_SOURCE_SECRET_KEY=""
ENV S3_DESTINATION_ACCESS_KEY=""
ENV S3_DESTINATION_SECRET_KEY=""

ENV S3_SOURCE_HOST=""
ENV S3_DESTINATION_HOST="https://s3.amazonaws.com"

ENV S3_SOURCE_BUCKET=""
ENV S3_DESTINATION_BUCKET="bucket-dst"

ENV FILE_BACKUP_PSQL="allDATACbox.sql"

ENV S3_SOURCE_REGION="us-east-1"
ENV S3_DESTINATION_REGION="us-east-1"

ENV ADD_ARG=""

# MINIO conf File
ENV ACCESS_KEY_MINIO="minioadmin"
ENV SECRET_KEY_MINIO="minioadmin"
ENV ENDPOINT_MINIO="IP:9000"
ENV REGION_AWS="eu-west-3"

# Rclone conf file
ENV S3_PROD_BUCKET_NAME=""
ENV S3_DESTINATION_BUCKET=""

# update and install package
# RUN apt-get update
# RUN apt-get install -y 
RUN apk --update --no-cache add bash \
                                coreutils \
                                curl \
                                unzip \
                                gettext \
                                postgresql-client \
                                ca-certificates


# Install kubectl
RUN curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# install mc_client
# RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -s -o $HOME/minio-binaries/mc
# RUN sudo -v ; chmod +x $HOME/minio-binaries/mc
# RUN export PATH=$PATH:$HOME/minio-binaries
# ENV PATH="$PATH:$HOME/minio-binaries"
 RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc \
         -o /bin/mc \
    && chmod +x /bin/mc

# install rclone
RUN mkdir -p /etc/rclone
RUN curl https://rclone.org/install.sh | bash

COPY config/ /config
COPY scripts/ /scripts

# install S3HyperSync 
RUN apk --update --no-cache add openjdk11 wget
RUN wget https://github.com/Starofall/S3HyperSync/releases/download/v0.1.5/S3HyperSync.jar \
    -O /scripts/S3HyperSync.jar

# install S3sync
RUN wget https://github.com/larrabee/s3sync/releases/download/2.62/s3sync_Linux_x86_64.tar.gz \
    -O /scripts/s3sync_Linux_x86_64.tar.gz && tar -xvzf /scripts/s3sync_Linux_x86_64.tar.gz

RUN chmod +x /scripts/entrypoint.sh
ENTRYPOINT ["/scripts/entrypoint.sh"]
