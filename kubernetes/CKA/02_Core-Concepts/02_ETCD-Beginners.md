# 2.2 - ETCD For Beginners

- ETCD Is a distributed reliable key-value store that is simple and fast to operate.
- Key-value store stores information ina key-value format, each value is associated with a
unique key and stored in a database.
- To install and run ETCD:

1. Download and extract the binaries from <https://github.com/etcd-io/etcd>
1. Run the associated executable `./etcd`

- This starts a service running on port 2379 by default.
- Clients can then be attached to the etcd service to store and retrieve information.
  - A default
client included is the etcd control client, a CLI client for etcd; used to store and retrieve key-value-pairs.

- To store a key-value-pair: `./etcdctl set <key> <value>`
- To retrieve a value: `./etcdctl get <key>`
- For additional information: `./etcdctl`
