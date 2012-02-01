# Getting Started - Installing

## Package Install

1. Go to http://basho.com/resources/downloads/

2. Navigate to Riak > CURRENT

3. Download the appropriate package for your system

4. Install the package

## Source Install

1. Install kerl (https://github.com/spawngrid/kerl)

2. Install Erlang 

3. Clone Riak 

    git clone git://github.com/basho/riak_kv.git

4. Build Riak

    cd riak
    make

5. Build a Riak release

    make rel
