 # Deploy Riak CS to a Local VM

* Download Riak, Stanchion, and Riak CS from Zendesk

* Install Riak, Stanchion, and Riak CS

```bash
sudo dpkg -i PACKAGE_NAME
```

* Local the configuration files for Riak, Stanchion, and Riak CS

```
/etc/riak/app.config
/etc/stanchion/app.config
/etc/riak-cs/app.config
```

* Determine the port Riak is listening on for protocol buffers

```
grep pb_ /etc/riak/app.config
```

* Verify Stanchion is pointing at Riak

```
grep riak_ /etc/stanchion/app.config
```

* Determine the port Stanchion is listening on

```
grep stanchion_ /etc/stanchion/app.config
```

* Verify Riak CS is pointing at Riak and Stanchion

```
grep riak_ /etc/riak-cs/app.config
grep stanchion_ /etc/stanchion/app.config
```

* Start Riak, Stanchion, and Riak CS

```
sudo riak start
sudo stanchion start
sudo riak-cs start
```

* Create a user

```
curl -X POST http://HOST:PORT/user --data "email=foo@bar.com&name=foo%20bar"
```

* Setup s3cmd to access the local install

* Make a bucket

* Upload the website created earlier

* Verify website is accessible publically
