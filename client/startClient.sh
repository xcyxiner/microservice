docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
sh clientconsul.sh
sh clientRegistrator.sh
sh clientSwarm.sh