#!/bin/bash

echo "Configure mc client..."
#mkdir -p /root/.mc
#envsubst < "/config/mc-aliases.tmpl" > "/root/.mc/config.json"
mc alias set destination $S3_DESTINATION_HOST $S3_DESTINATION_ACCESS_KEY $S3_DESTINATION_SECRET_KEY
echo "mc client configured"

echo "Configure rclone..."
mkdir -p /root/.config/rclone/
envsubst < "/config/rclone.tmpl" > "/root/.config/rclone/rclone.conf"
echo "rclone configured"

if [[ $DEBUG = "true" ]]; then
  echo "### DEBUG:"
  echo "### /config/mc-aliases.tmpl"
  cat /config/mc-aliases.tmpl
  echo "### /root/.mc/config.json"
  cat /root/.mc/config.json
  echo "## mc ls destination"
  mc ls destination
  echo "### /config/rclone.tmpl"
  cat /config/rclone.tmpl
  echo "### /root/.config/rclone/rclone.conf
  cat /root/.config/rclone/rclone.conf
  echo "## cat /etc/hosts"
  cat /etc/hosts
  ## wait
  #sleep 3600
fi

case $ACTION in

  BACKUP)
    source /scripts/backup.sh

    case $SRC_TYPE in
      #BucketAWS)
      #  backupBucketToBucket
      #  ;;

      Postgres)
        backupPostgresToBucket
        ;;

      AllPostgres)
        backupAllPostgresToBucket
        ;;

      AllPodK8sPostgres)
        backupAllPodK8sPostgresToBucket
        ;;

      #Mysql)
      #  backupMySqlToBucket
      #  ;;

      #Redis)
      #  backupRedisToBucket
      #  ;;

      *)
        echo "SRC_TYPE: [BucketAWS|Postgres|AllPostgres|Mysql|Redis|AllPodK8sPostgres]"
        exit 1
    esac
    ;;
  
  RESTORE)
    source /scripts/restore.sh
    case $DST_TYPE in
      BucketAWS)
        restoreBucketFromBucket
        ;;

      Postgres)
        restorePostgresFromBucket
        ;;

      # Mysql)
      #   restoreMySqlFromBucket
      #   ;;

      # Redis)
      #   restoreRedisFromBucket
      #   ;;

      *)
        echo "DST_TYPE: [BucketAWS|Postgres]"
        exit 1
    esac
    ;;
  *)
      echo "ACTION: [BACKUP|RESTORE]"

esac


  
