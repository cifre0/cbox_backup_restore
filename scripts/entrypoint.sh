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

if [ $DEBUG = true ]; then
  echo "### DEBUG:"
  echo "### /config/mc-aliases.tmpl"
  cat /config/mc-aliases.tmpl
  cat /root/.mc/config.json
  echo "## mc ls destination"
  mc ls destination
  echo "## command backup psql:"
  echo "  PGPASSWORD=$POSTGRES_PASSWD pg_dumpall -U $POSTGRES_USERNAME -h $POSTGRES_HOST -p $POSTGRES_PORT \
  2>dump_error.log | mc pipe destination/$S3_DESTINATION_BUCKET/acb_$FILE_BACKUP_PSQL"
  echo "### /config/rclone.tmpl"
  cat /config/rclone.tmpl
  cat /root/.config/rclone/rclone.conf
fi
  
