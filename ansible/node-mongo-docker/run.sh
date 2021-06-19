docker stop rest-server
docker rm rest-server
# docker run -itd -p 27017:27017 --name mongojain mongo
docker build --tag node-mongo . --no-cache
docker run -it --rm -d --name rest-server -p 3000:3000 -e CONNECTIONSTRING=mongodb://mongodb:27017/yoda_notes node-mongo
