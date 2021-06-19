# docker

# docker-compose 
```
alias dc=docker-compose
docker-compose build --no-cache
docker-compose up -d or docker-compose up
docker-compose logs
```

# docker swarm
```
docker swarm init
docker stack rm node-demo
sleep 5
docker network create -d overlay --attachable node-demo
docker stack deploy -c docker-swarm.yaml node-demo
docker stack services node-demo --format "table {{.Name}}\t{{.Image}}\t{{.Ports}}" | sort
docker stack rm node-demo
```

# docker swarm
```
docker swarm init
docker-compose push
docker stack rm stackdemo
sleep 5
<!-- docker network create -d overlay --attachable stackdemo (not required) -->
docker stack deploy --compose-file docker-swarm.yaml stackdemo
docker stack services stackdemo
docker service ls
    ID             NAME                MODE         REPLICAS   IMAGE                              PORTS
    nv2ua60h3hqw   stackdemo_app       replicated   1/1        127.0.0.1:3000/node-mongo:latest   *:3000->3000/tcp
    twz7t7fz80os   stackdemo_mongodb   replicated   1/1        mongo:latest                       *:27017->27017/tcp
docker service logs -f stackdemo_app
docker stack services stackdemo --format "table {{.Name}}\t{{.Image}}\t{{.Ports}}" | sort
docker stack rm stackdemo
docker service rm registry (for CI/CD)
docker swarm leave --force
```