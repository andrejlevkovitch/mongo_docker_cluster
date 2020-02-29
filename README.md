# mongo docker cluster

## Usage

  1. Generate mongo keyfile by script [generate_keyfile.sh](generate_keyfile.sh) (need superuser rights)

  2. Copy [template.env](template.env) to [environment.env](environment.env)

  3. Set needed preferences in [environment.env](environment.env) (username, password, ports)

  4. run [cluster_deploy.sh](./cluster_deploy.sh)


Also you can manually add some parts of cluster in [mongo_cluster.yml](mongo_cluster.yml).

For create new sharded replica set you must:

  1. Append in [environment.env](environment.env) new `RS*SHARD_COUNT` with count
  of new shards in replica set ( __NOTE__ number can not be less than [3](https://docs.mongodb.com/manual/core/sharded-cluster-components/#production-configuration))

  2. In [mongo_cluster.yml](mongo_cluster.yml) append new `rs*shard` (see others)

  3. Add new init lin in `cluster_init` in [mongo_cluster.yml](mongo_cluster.yml)
  (see others)

  4. In [cluster_deploy.sh](cluster_deploy.sh) add new `--scale` flag for 
  `docker-compose` running

```
... --scale rs*shard=$RS*SHARD_COUNT
```

## Note

  - `MONGO_HOST_PORT` must be free on host

  - if you get error about docker can not allocate memory, then it means that
    you not have free space on you host. You need remove not using containers
    (`docker rm $(docker container list -aq) -f` - remove all containers). And
    call `docker volume prune`.

  - if some of shards was not added, maybe you need increase some of
    `*_WAITING_TIME` variables in [environment.env](environment.env) file

  - if you changed something in [mongo_cluster.yml](mongo_cluster.yml) or
    [environment.env](environment.env), then you need recreate all cluster

## Problems

  - you can not use specific `volumes` for shards, because it is impassible to
    set different volumes in config file before scaling
