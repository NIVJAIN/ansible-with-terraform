FROM mongo:4.0.19-xenial
WORKDIR /app/data/
COPY ratings_data.json /app/data/
COPY script.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/script.sh
