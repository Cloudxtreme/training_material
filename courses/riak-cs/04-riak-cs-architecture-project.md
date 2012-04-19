# Deploy Riak CS to a Local VM

## Download and Install

* Download Riak, Stanchion, and Riak CS from Zendesk

* Install Riak, Stanchion, and Riak CS

```bash
 # Ubuntu
sudo dpkg -i PACKAGE_NAME
```

## Configure

* Locate the configuration files for Riak, Stanchion, and Riak CS

```bash
 # Riak
/etc/riak/app.config
/etc/riak/vm.args

 # Stanchion
/etc/stanchion/app.config
/etc/stanchion/vm.args

 # Riak CS
/etc/riak-cs/app.config
/etc/riak-cs/vm.args
```

### Riak

* Open Riak's `vm.args` file

* Add Riak CS's libraries to the code path

```
 # Add to the end of the existing vm.args file
-pa /usr/lib/riak-cs/lib/riak_moss-1.0.1/ebin
```

* Save and close the file

* Open Riak's `app.config` file

* Configure Riak's `storage_backend` in the `riak_kv` section

```erlang
{storage_backend, riak_cs_kv_multi_backend},
{multi_backend_prefix_list, [{<<"0b:">>, be_blocks}]},
{multi_backend_default, be_default},
{multi_backend, [
 % format: {name, module, [Configs]}
 {be_default, riak_kv_eleveldb_backend, [
   {max_open_files, 50},
   {data_root, "/var/lib/riak/leveldb"}
 ]},
 {be_blocks, riak_kv_bitcask_backend, [
  {data_root, "/var/lib/riak/bitcask"}
 ]}
]},
```

* Save and close the file

### Stanchion

* Determine the port Riak is listening on for protocol buffers

```bash
grep pb_ /etc/riak/app.config
```

* Verify Stanchion is pointing at Riak

```bash
grep riak_ /etc/stanchion/app.config
```

### Riak CS

* Determine the port Stanchion is listening on

```bash
grep stanchion_ /etc/stanchion/app.config
```

* Verify Riak CS is pointing at Riak and Stanchion

```bash
grep riak_ /etc/riak-cs/app.config
grep stanchion_ /etc/stanchion/app.config
```

## Start

* Start Riak, Stanchion, and Riak CS

```bash
sudo riak start
sudo stanchion start
sudo riak-cs start
```

* Verify Riak, Stanchion, and Riak CS are running

```bash
sudo riak ping
sudo stanchion ping
sudo riak-cs ping
```

* Create a user

```bash
curl -X POST http://HOST:PORT/user --data "email=foo@bar.com&name=foo%20bar"
```

* Setup s3cmd to access the local install

* Make a bucket

* Upload the website created earlier

* Verify website is accessible publically
