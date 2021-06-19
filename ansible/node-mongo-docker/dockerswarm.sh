docker stack rm node-demo
sleep 5
# docker network create -d overlay --attachable node-demo
docker stack deploy -c docker-swarm.yaml node-demo
docker stack services node-demo --format "table {{.Name}}\t{{.Image}}\t{{.Ports}}" | sort
docker service ls