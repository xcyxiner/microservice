docker run -d --restart=always --name shipyard-rethinkdb rethinkdb
docker run -d --restart=always --name swarm-replication-master -p 3375:3375 swarm:latest manage -H :3375 --replication --advertise MASTERIP:3375 consul://MASTERIP:8500
docker run -d --restart=always --name shipyard-swarm-manager swarm:latest join --advertise MASTERIP:2375 consul://MASTERIP:8500
docker run -d --restart=always --name shipyard-controller --link shipyard-rethinkdb:rethinkdb --link swarm-replication-master:swarm -p 8080:8080 shipyard/shipyard:latest    server -d tcp://swarm:3375