# source: https://github.com/shakapark/Backup-Tool/blob/bishopp/backupToAWS.sh

secs_to_human() {
  DIFF_TIME=`expr $1 - $2`
  echo "$(( ${DIFF_TIME} / 3600 ))h $(( (${DIFF_TIME} / 60) % 60 ))m $(( ${DIFF_TIME} % 60 ))s"
}

# DATEHOUR=$(date +"%Y-%m-%d_%H-%M")

backupAllPostgresToBucket() {
  set -e

  echo "Starting Backup All Postgres"

  # DATE=$(date +"%d-%m-%Y")
  # DATEHOUR=$(date +"%d-%m-%Y_%H-%M-%S")
  # FILE=backup-$POSTGRES_DATABASE-$DATEHOUR

  # if [ "$S3_DESTINATION_HOST" != "https://s3.amazonaws.com" ]; then
  #   ENDPOINT_URL="--endpoint-url $S3_DESTINATION_HOST"
  # else
  #   ENDPOINT_URL=""
  # fi

  echo "Begin Backup..."
  # DATE_BEGIN=`date +%s`

  #PGPASSWORD=$POSTGRES_PASSWD pg_dumpall -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER 2> dump_error.log | \
  #aws $ENDPOINT_URL s3 cp - s3://$S3_DESTINATION_BUCKET/postgres-$DATE/$FILE.sql

  # if [[ -s "dump_error.log" ]]; then
  #   cat dump_error.log
  #   exit 6
  # fi

  # DATE_ENDING=`date +%s`
  echo "Backup Done"

  # SIZE=$(aws $ENDPOINT_URL s3 ls --summarize --human-readable s3://$S3_DESTINATION_BUCKET/postgres-$DATE/$FILE.sql | grep "Total Size" | awk -F': ' '{print $2}')
  # if [[ ! $SIZE =~ ^[0-9]+(\.[0-9]+)?[[:space:]][K|M|G]iB$ ]]; then
  #   echo "Can't get backup Size from S3 ($SIZE)"
  #   exit 2
  # fi
  # TIME=$(secs_to_human $DATE_ENDING $DATE_BEGIN)
  # if [[ ! $TIME =~ ^[0-9]+h[[:space:]][0-9]{1,2}m[[:space:]][0-9]{1,2}s$ ]]; then
  #   echo "Error with Time Calcul ($TIME)"
  #   exit 3
  # fi

  # echo "Resume:"
  # echo "  File name: postgres-$DATE/$FILE.sql"
  # echo "  Dump size: $SIZE"
  # echo "  Total time: $TIME"

  # echo "Resume:" > postgres-$DATE.done
  # echo "  File name: postgres-$DATE/$FILE.sql" >> postgres-$DATE.done
  # echo "  Dump size: $SIZE" >> postgres-$DATE.done
  # echo "  Total time: $TIME" >> postgres-$DATE.done
  # aws $ENDPOINT_URL s3 cp postgres-$DATE.done s3://$S3_DESTINATION_BUCKET/postgres-$DATE.done
  # # cat postgres-$DATE.done
  # rm postgres-$DATE.done

  # LAST_BACKUP=$(check_last_backup "postgres" "postgres-$DATE.done")
  # if [[ ! $LAST_BACKUP =~ ^postgres-[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]; then
  #   echo "Can't get last backup name from S3 ($LAST_BACKUP)"
  #   exit 4
  # fi
  # echo "Last Backup: $LAST_BACKUP.done"
  # LAST_SIZE_BACKUP=$(aws $ENDPOINT_URL s3 cp s3://$S3_DESTINATION_BUCKET/$LAST_BACKUP.done - | grep "Dump size:" | cut -d':' -f2)
  # if [[ ! $LAST_SIZE_BACKUP =~ ^[[:space:]]*[0-9]+(\.[0-9]+)?[[:space:]][K|M|G]iB$ ]]; then
  #   echo "Can't get last backup Size from S3 ($LAST_SIZE_BACKUP)"
  #   exit 5
  # fi
  # echo "Last Backup Size: $LAST_SIZE_BACKUP"

  # DIFF=$(compare_dump_size $SIZE $LAST_SIZE_BACKUP)
  # # [[ ! $DIFF =~ ^$ ]] && echo "Something wrong with diff calcul"; exit 6
  # echo "Difference since last backup: $DIFF%"

  # if [ $DIFF -lt -5 ] || [ $DIFF -gt 5 ]; then
  #   echo "Difference too big: $DIFF%"
  #   exit 1
  # fi

  # echo "Backup checked"

  # set +e
  # echo "Remove old folder"
  # DATE=$(date -d "$RETENTION days ago" +"%d-%m-%Y")
  # aws $ENDPOINT_URL s3 rm --recursive s3://$S3_DESTINATION_BUCKET/postgres-$DATE
  # aws $ENDPOINT_URL s3 rm s3://$S3_DESTINATION_BUCKET/postgres-$DATE.done

  exit 0
}

backupAllPodK8sPostgresToBucket() {
  set -e

  echo "Starting Backup All Postgres"

  echo "Begin Backup..."
  # DATE_BEGIN=`date +%s`

  #PGPASSWORD=$POSTGRES_PASSWD pg_dumpall -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER 2> dump_error.log | \
  #aws $ENDPOINT_URL s3 cp - s3://$S3_DESTINATION_BUCKET/postgres-$DATE/$FILE.sql

  # POSTGRES_PASSWD=$(kubectl get secrets -n $namespaceCBOX postgres -o yaml | grep postgres-password | awk -F" " '{print $2}' | base64 -d)
  # POSTGRES_PASSWD=$(kubectl get secrets -n psql bdd-postgres -o yaml | grep postgres-password | awk -F" " '{print $2}' | base64 -d)
  # username= postgres
  # kubectl exec -it -n psql bdd-postgresql-0 -- bash -c "PGPASSWORD=$POSTGRES_PASSWD pg_dumpall -U $POSTGRES_USERNAME" \ 
  # 2>dump_error.log | mc pipe destination/$S3_DESTINATION_BUCKET/acb_$FILE_BACKUP_PSQL
  
  PGPASSWORD=$POSTGRES_PASSWD pg_dumpall -U $POSTGRES_USERNAME -h $POSTGRES_HOST -p $POSTGRES_PORT \
  2>dump_error.log | mc pipe destination/$S3_DESTINATION_BUCKET/acb_$FILE_BACKUP_PSQL

  if [[ $DEBUG = "true" ]]; then
    echo "## command backup backupAllPodK8sPostgresToBucket:"
    echo "PGPASSWORD=$POSTGRES_PASSWD pg_dumpall -U $POSTGRES_USERNAME -h $POSTGRES_HOST -p $POSTGRES_PORT \
    2>dump_error.log | mc pipe destination/$S3_DESTINATION_BUCKET/acb_$FILE_BACKUP_PSQL"
    echo "### dump_error.log" 
  
    if [[ -s "dump_error.log" ]]; then
      echo "### dump_error.log" 
      cat dump_error.log
      exit 6
    else
      echo "'dump_error.log' don't exist"
    fi
    ## wait
    sleep 3600
  fi



  # DATE_ENDING=`date +%s`
  echo "Backup Done"


  exit 0
}

SynchRcloneToBucket() {
  set -e

  echo "Begin Backup..."
  # cmd rclone pour synch
  # rclone sync source:path dest:path [flags]
  # --no-check-certificate if self signed
  #rclone sync -P $S3_PROD_ALIAS_NAME:$S3_PROD_BUCKET_NAME $S3_BACK_ALIAS_NAME:$S3_BACK_BUCKET_NAME_OBJ
  DATE_BEGIN=`date +%s`
  rclone sync -P prodcboxonprem:$S3_PROD_BUCKET_NAME backupminio:$S3_DESTINATION_BUCKET 2>synch_error.log
  DATE_ENDING=`date +%s`
  TIME=$(secs_to_human $DATE_ENDING $DATE_BEGIN)
  echo "rclone time of synch: $TIME"
  # logger -t "rclone time of synch" "$TIME"
  
  if [[ $DEBUG = "true" ]]; then
    echo "## command backup SynchRcloneToBucket:"
    echo "rclone sync -P prodcboxonprem:$S3_PROD_BUCKET_NAME backupminio:$S3_DESTINATION_BUCKET 2>synch_error.log"
    echo "Duration of synch: $TIME sec"
    echo "### synch_error.log" 
    
    if [[ -s "synch_error.log" ]]; then
      echo "### synch_error.log" 
      cat synch_error.log
      exit 6
    else
      echo "'synch_error.log' don't exist"
    fi
    ## wait
    sleep 3600
  fi

  echo "Backup Done"
  
  exit 0
}

SynchS3HyperSyncToBucket() {
  set -e

  echo "Begin Backup with S3HyperSync..."
  # pwd
  # ls
  DATE_BEGIN=`date +%s`
  java -jar /scripts/S3HyperSync.jar --source-bucket=$S3_PROD_BUCKET_NAME --source-endpoint=$ENDPOINT_PROD_CBOX \
  --source-key=$ACCESS_KEY_PROD_CBOX --source-secret=$SECRET_KEY_PROD_CBOX --source-region=other-v2-signature \
  --source-path-style --target-bucket=$S3_DESTINATION_BUCKET --target-endpoint=$ENDPOINT_MINIO --target-key=$ACCESS_KEY_MINIO \
  --target-secret=$SECRET_KEY_MINIO --target-region=other-v2-signature --target-path-style 
  DATE_ENDING=`date +%s`
  TIME=$(secs_to_human $DATE_ENDING $DATE_BEGIN)

  if [[ $DEBUG = "true" ]]; then
    echo "## command backup SynchRcloneToBucket:"
    echo "  java -jar /scripts/S3HyperSync.jar --source-bucket=$S3_PROD_BUCKET_NAME --source-endpoint=$ENDPOINT_PROD_CBOX \
    --source-key=$ACCESS_KEY_PROD_CBOX --source-secret=$SECRET_KEY_PROD_CBOX --source-region=other-v2-signature \
    --source-path-style --target-bucket=$S3_DESTINATION_BUCKET --target-endpoint=$ENDPOINT_MINIO --target-key=$ACCESS_KEY_MINIO \
    --target-secret=$SECRET_KEY_MINIO --target-region=other-v2-signature --target-path-style 2>synch_error.log"
    echo "Duration of synch: $TIME sec"
    echo "### synch_error.log" 
    
    if [[ -s "synch_error.log" ]]; then
      echo "### synch_error.log" 
      cat synch_error.log
      exit 6
    else
      echo "'synch_error.log' don't exist"
    fi
    ## wait
    sleep 3600
  fi
  
  echo "Backup Done"
  
  exit 0
}

SynchS3SyncToBucket() {
  set -e

  echo "Begin Backup with S3Sync..."
  # pwd
  # ls
  DATE_BEGIN=`date +%s`

  # s3sync --tk KEY2 --ts SECRET2 --sk KEY1 --ss SECRET1 --se "http://127.0.0.1:7484" --te "http://127.0.0.1:7484" -w 128 s3://bucket_name_source s3://bucket_destination
  ./s3sync  --tk $ACCESS_KEY_MINIO --ts $SECRET_KEY_MINIO --sk $ACCESS_KEY_PROD_CBOX --ss $SECRET_KEY_PROD_CBOX --se "$ENDPOINT_PROD_CBOX" \
            --te "$ENDPOINT_MINIO" -w 128 s3://$S3_PROD_BUCKET_NAME s3://$S3_DESTINATION_BUCKET $ADD_ARG
  
  DATE_ENDING=`date +%s`
  TIME=$(secs_to_human $DATE_ENDING $DATE_BEGIN)

  if [[ $DEBUG = "true" ]]; then
    echo "## command backup SynchRcloneToBucket:"
    echo "./s3sync  --tk $ACCESS_KEY_MINIO --ts $SECRET_KEY_MINIO --sk $ACCESS_KEY_PROD_CBOX --ss $SECRET_KEY_PROD_CBOX --se "$ENDPOINT_PROD_CBOX" \
                    --te "$ENDPOINT_MINIO" -w 128 s3://$S3_PROD_BUCKET_NAME s3://$S3_DESTINATION_BUCKET $ADD_ARG"
    echo "Duration of synch: $TIME sec"
    echo "### synch_error.log" 
    
    if [[ -s "synch_error.log" ]]; then
      echo "### synch_error.log" 
      cat synch_error.log
      exit 6
    else
      echo "'synch_error.log' don't exist"
    fi
    ## wait
    sleep 3600
  fi
  
  echo "Backup Done"
  
  exit 0
}

