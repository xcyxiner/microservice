docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
sh masterconsul.sh
sh masterRegistrator.sh
sh masterSwarm.sh