# mongo docker cluster

Usage:

  1. Generate mongo keyfile by script `generate_keyfile.sh` (need superuser rights)

  2. Copy `template.env` to `.env`

  3. Set needed preferences in `.env` (username, password, ports)

  4. Start `docker-compose -f mongo_cluster.yml up`


Also you can manually add some parts of cluster in mongo_cluster.yml.


Note:

  - `MONGO_HOST_PORT` must be free on host

  - if you get error about docker can not allocate memory, then it means that
    you not have free space on you host. You need remove not using containers
    (`docker rm $(docker container list -aq) -f` - remove all containers). And
    call `docker volume prune`.

  - if some of shards was not added, maybe you increase some of `ROUTER_WAITING_TIME`

  - if you change something in `mongo_cluster.yml` or `.env`, then you need
    recreate all cluster


TODO:

  - add volume containers for storing databases

  - add simple way for adding new shard, config or router

