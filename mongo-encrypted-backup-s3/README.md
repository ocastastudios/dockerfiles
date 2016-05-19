# mongo-backup-s3

Backup MongoDB to S3 (supports periodic backups)

## Usage

```sh
$ docker run -e S3_ACCESS_KEY_ID=key -e S3_SECRET_ACCESS_KEY=secret -e S3_BUCKET=my-bucket -e S3_PREFIX=backup -e MONGO_USER=user -e MONGO_PASSWORD=password -e MONGO_HOST=mongocontainer schickling/mongo-backup-s3
```

### Automatic Periodic Backups

You can additionally set the `SCHEDULE` environment variable like `-e SCHEDULE="@daily"` to run the backup automatically.

More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).

## Encrypted backups

Encrypting the backups requires a key pair. You can generate a 2048 bit key with the openssl
command

```openssl req -x509 -nodes -newkey rsa:2048 -keyout dbbackupkey.priv.pem -out dbbackupkey.pub.pem```

You will then need to mount the key in the docker container and set the ENCRYPT environment variable

```sh
$ docker run -v $PWD/dbbackupkey.pub.pem:/var/keys/publickey.pem -e ENCRYPT=/var/keys/publickey.pem -e S3_ACCESS_KEY_ID=key -e S3_SECRET_ACCESS_KEY=secret -e S3_BUCKET=my-bucket -e S3_PREFIX=backup -e MONGO_USER=user -e MONGO_PASSWORD=password -e MONGO_HOST=mongocontainer schickling/mongo-backup-s3
```

To unencrypt the file
```openssl smime -decrypt -in database.gz.enc -binary -inform DEM -inkey dbbackupkey.priv.pem -out database.gz```