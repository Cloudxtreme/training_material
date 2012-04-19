# Creating a User

```
curl -X POST http://HOST:PORT/user --data "email=foo@bar.com&name=foo%20bar"
```

* Users cannot currently be modified

# Installing s3cmd

* http://s3tools.org/repositories

```
# OS X homebrew
brew install s3cmd
```

# Setting up s3cmd

```
s3cmd --configure
```

* Set `access_key`
* Set `secret_key`
* Development/Test
 * Set `proxy_host`
 * Set `proxy_port`
* data.attstorage.com
 * Manually modify `~/.s3cfg`
 * Set `host_base = data.attstorage.com`
 * Set `host_bucket = %(bucket)s.data.attstorage.com`

# Listing Buckets

```
s3cmd ls
```

# Creating a Bucket

```
s3cmd mb s3://BUCKET
```

# Listing Files in a Bucket

```
s3cmd ls s3://BUCKET
```

# Uploading a File

```
s3cmd put FILENAME s3://BUCKET
s3cmd put FILENAME s3://BUCKET/OBJECT
```

# Download a File

```
s3cmd get s3://BUCKET/OBJECT
```

# Deleting a File

```
s3cmd del s3://BUCKET/OBJECT
```

# Uploading a Directory

```
s3cmd put --recursive DIRNAME s3://BUCKET
```

# Applying Object ACLs

## Public

```
s3cmd put --acl-public s3://BUCKET/OBJECT
s3cmd setacl --acl-public s3://BUCKET/OBJECT
s3cmd setacl --acl-public --recursive s3://BUCKET
```

## Private

```
s3cmd put --acl-private s3://BUCKET/OBJECT
s3cmd setacl --acl-private s3://BUCKET/OBJECT
s3cmd setacl --acl-public --recursive s3://BUCKET
```
