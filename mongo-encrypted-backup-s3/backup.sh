#! /bin/sh

set -e

if [ "${S3_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${S3_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${MONGO_HOST}" = "**None**" ]; then
  echo "You need to set the MONGO_HOST environment variable."
  exit 1
fi

if [ "${MONGO_USER}" = "**None**" ]; then
  echo "You need to set the MONGO_USER environment variable."
  exit 1
fi

if [ "${MONGO_PASSWORD}" = "**None**" ]; then
  echo "You need to set the MONGO_PASSWORD environment variable or link to a container named MONGO."
  exit 1
fi

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

MONGO_HOST_OPTS="--host $MONGO_HOST -u $MONGO_USER -p$MONGO_PASSWORD --gzip"

echo "Creating dump of database(s) from ${MONGO_HOST}..."


mongodump $MONGO_HOST_OPTS $MONGODUMP_OPTIONS --archive | \
 openssl smime -encrypt -binary -text -aes256 -out database.gz.enc -outform DER /var/keys/publickey.pem


echo "Uploading encrypted dump to $S3_BUCKET"

cat database.gz.enc | aws s3 cp - s3://$S3_BUCKET/$S3_PREFIX/$(date +"%Y-%m-%dT%H%M%SZ").gz.enc || exit 2

echo "MONGO backup uploaded successfully"
