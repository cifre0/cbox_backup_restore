# source: https://github.com/shakapark/Backup-Tool/blob/bishopp/backupToAWS.sh

# secs_to_human() {
#   DIFF_TIME=`expr $1 - $2`
#   echo "$(( ${DIFF_TIME} / 3600 ))h $(( (${DIFF_TIME} / 60) % 60 ))m $(( ${DIFF_TIME} % 60 ))s"
# }

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

  kubectl exec -it -n psql bdd-postgresql-0 -- bash -c "PGPASSWORD=$POSTGRES_PASSWD pg_dumpall -U postgres" \ 
  2>dump_error.log | mc pipe destination/$S3_DESTINATION_BUCKET/$FILE_BACKUP_PSQL


  if [[ -s "dump_error.log" ]]; then
    cat dump_error.log
    exit 6
  fi

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
