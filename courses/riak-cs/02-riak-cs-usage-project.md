# Publish a Website on Riak CS

* Riak CS Information

```
proxy_host = 107.20.111.200
proxy_port = 80
```

* Create a new user

```
curl -X POST http://107.20.111.200/user --data "email=EMAIL_ADDRESS&name=NAME"
```

* Update `~/.s3cfg`

* Create a bucket

```
s3cmd mb s3://BUCKET
```

* Create a new directory

```
mkdir my_website
cd my_website
```

* Create an `index.html` file with the following contents

```
<html>
        <img src="images/kittah1">
        <img src="images/kittah2">
        <img src="images/kittah3">
</html>
```

* Make an `images` directory

```
mkdir images
```

* Add images to the directory

```
for i in {1..5}
do
        curl http://placekitten.com/g/200/300 -o images/kitten${i}
done
```

* Upload files

```
s3cmd put --acl-public --recursive * s3://BUCKET
```

* Navigate to the website

```
http://107.20.111.200/BUCKET/index.html
```
