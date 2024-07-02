# source https://github.com/shakapark/Backup-Tool/blob/bishopp/Dockerfile
FROM ubuntu:latest

USER root

ENV ACTION="BACKUP|RESTORE"
ENV SRC_TYPE="BucketAWS|Postgres|AllPostgres|Mysql|Redis|backupAllPodK8sPostgresToBucket"

# PSQL
ENV POSTGRES_PASSWD=""

# S3 Environments Variables
ENV S3_DESTINATION_HOST="https://s3.amazonaws.com"
ENV S3_DESTINATION_ACCESS_KEY=""
ENV S3_DESTINATION_SECRET_KEY=""

ENV S3_DESTINATION_BUCKET="bucket-dst"
ENV FILE_BACKUP_PSQL="allDATACbox.sql"

# MINIO conf File
ENV ACCESS_KEY_MINIO="minioadmin"
ENV SECRET_KEY_MINIO="minioadmin"
ENV ENDPOINT_MINIO="IP:9000"
ENV REGION_AWS="eu-west-3"

# update and install package
RUN apt-get update
RUN apt-get install -y curl

# Install kubectl
RUN curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# install mc_client
RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -s -o $HOME/minio-binaries/mc
RUN chmod +x $HOME/minio-binaries/mc
RUN export PATH=$PATH:$HOME/minio-binaries
ENV PATH="$PATH:$HOME/minio-binaries"

# install rclone
RUN mkdir -p /etc/rclone
RUN sudo -v ; curl https://rclone.org/install.sh | sudo bash
