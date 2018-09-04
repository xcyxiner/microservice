docker run -d --restart=always --name swarm-replication-client  -p 3375:3375 swarm:latest manage -H :3375 --replication --advertise CLIENTIP:3375 consul://CLIENTIP:8500
docker run -d --restart=always --name swarm-agent swarm:latest join --addr CLIENTIP:2375 consul://CLIENTIP:8500