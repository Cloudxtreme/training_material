autoscale: true
build-lists: true
footer: © Basho, 2015
slidenumbers: true

![fit](design-assets/Basho-Logos/eps/basho-logo-color-horiz.eps)

---

# Basho Bench

![left fit](./design-assets/Bashomen/png/diagnose.png)

* performance and stress testing

---

# Basho Bench

* A simple, yet powerful tool created to conduct reliable performance & stress tests, accompanied by
* beautiful R graphs.



---

# Why?

* Minimise surprises during deployment
* Test expected / peak load
* Identify failure points early
* "You can expect what you inspect."

---

# What?

* Basho Bench focuses on 2 metrics:
* Throughput: number of operations performed in a timeframe, captured in aggregate across all operation types
* Latency: time to complete single operations, captured in quantiles per-operation

---

# How?

* Setup the Riak (EE) cluster
* Install Basho Bench on a dedicated server
* Plan & Configure a (BB) test scenario
* Run Basho Bench against the Riak cluster
* Generate Graphs & Evaluate Results
* GOTO 3

---

# Installing

* Erlang
* $ wget http://erlang.org/download/otp_src_R15B01.tar.gz
* $ tar zxvf otp_src_R15B01.tar.gz
* $ cd otp_src_R15B01
* $ ./configure && make && sudo make install
* Basho Bench
* $ git clone git://github.com/basho/basho_bench.git
* $ cd basho_bench
* $ make all
* R
* $ wget http://cran.r-project.org/src/base/R-3/R-3.0.2.tar.gz
* $ cd R-3.0.2
* $ ./configure && make && sudo make install

---

# Configuring 1/2

* Start from one of the example configurations (under ./example/) and adjust it according to your needs
* Define rate limit, concurrency, duration, operations (PUT/GET/DELETE/2i/MR), key/value generator

---

# Configuring 2/2

* run at max, i.e.: as quickly as possible: {mode, max} 
* run 15 operations per second per worker: {mode, {rate, 15}}
* run 10 concurrent processes:{concurrent, 10}
* run the test for one hour: {duration, 60}
* run 80% GETs, 20% PUTs: {operations, [{get, 4}, {put, 1}]}
* generate a fixed size, random binary of 512 bytes {value_generator, {fixed_bin, 512}}
* use a randomly selected integer between 1 and 10,000: {key_generator, {uniform_int, 10000}}

---

# Running

* $ cd basho_bench
* $ ./basho_bench example/riakc_pb.config
* or
* $ ./basho_bench example/bitcask.config
* or
* $ ./basho_bench my-PeTe-scenario.config
* $ make results

---

# Analysing

* BB+R will write its output files under ./tests/current/
* *_latencies.csv
* summary.csv
* summary.png —>

---

# Resources

* http://docs.basho.com
* http://github.com/basho/basho_bench/
* http://www.erlang.org
* http://www.r-project.org


