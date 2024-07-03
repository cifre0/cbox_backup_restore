#!/bin/bash

echo "Configure mc client..."
mkdir -p /root/.mc
envsubst < "/config/mc-aliases.tmpl" > "/root/.mc/config.json"
echo "mc client configured"

echo "Configure rclone..."
mkdir -p /root/.config/rclone/
envsubst < "/config/rclone.tmpl" > "/root/.config/rclone/rclone.conf"
echo "rclone configured"


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
        echo "SRC_TYPE: [BucketAWS|Postgres|AllPostgres|Mysql|Redis]"
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
