# Cluster setup
This docker image allow to setup the container as a cluster device. 
The device itself has to be created in Phabricator prior to boot.
Following environment variables are used for cluster setup:
- `PHABRICATOR_ALLOW_HTTP_AUTH` - This is mandatory for cluster setup.
- `PHABRICATOR_CLUSTER_DATABASE_JSON` - Provides database cluster nodes, if any.
- `PHABRICATOR_CLUSTER_MAILER_JSON` - Configure outbound email strategy.
- `PHABRICATOR_CLUSTER_ADDRESSES_JSON` - Provides the whitelist of cluster nodes IP addresses.
- `PHABRICATOR_CLUSTER_DEVICE_KEY` - Give path to the private key to be used for this cluster device registration. This key is provided by Almanac.
- `MYSQL_SSL` - Set it to 'true' to force SSL communication between this node and Mysql server
