# function checkBackup() {
#   aws --endpoint-url $S3_DESTINATION_HOST s3 ls --summarize --human-readable s3://$S3_DESTINATION_BUCKET/$BACKUP_NAME
# }

function restorePostgresFromBucket() {
  # # BACKUP=getLastBackup

  # if [ "$COMPRESSION_ENABLE" = "true" ]; then
  #   echo "Enable compression"
  #   COMPRESSION="-Fc"
  # else
  #   echo "Disable compression"
  #   COMPRESSION=""
  # fi

  # if [ "$S3_DESTINATION_HOST" != "https://s3.amazonaws.com" ]; then
  #   ENDPOINT_URL="--endpoint-url $S3_DESTINATION_HOST"
  # else
  #   ENDPOINT_URL=""
  # fi

  # set -e

  # checkBackup

  # echo "Restore from $BACKUP_NAME..."
  # DATE_BEGIN=`date +%s`

  # aws $ENDPOINT_URL s3 cp s3://$S3_DESTINATION_BUCKET/$BACKUP_NAME - |\
  #   PGPASSWORD=$POSTGRES_PASSWD psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DATABASE \
  #   --no-owner $COMPRESSION

  # DATE_ENDING=`date +%s`
  # echo "Restoration Done"

  # TIME=$(secs_to_human $DATE_ENDING $DATE_BEGIN)
  # echo "Resume:"
  # echo "  Total time: $TIME"
}
