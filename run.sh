docker stop empower-db && docker rm empower-db
docker stop empower-backend && docker rm empower-backend
docker stop empower-front && docker rm empower-front

# Initialize MongoDB container and seed data.
docker run -d -p 27017:27017 --name empower-db mongo
docker cp database/quotes.json empower-db:/quotes.json
docker exec -it empower-db mongoimport --db empower --collection quotes --type json --file /quotes.json --jsonArray
DATABASE_URL=$(hostname -I | awk '{print $1}')

# TODO: Initialize Swift (back-end) container.
docker build --build-arg DATABASE_URL=$DATABASE_URL -t empower/backend:1.0 ./handler
docker run -d -p 8080:8080 --name empower-backend empower/backend:1.0
BACKEND_URL=$(hostname -I | awk '{print $1}')

# Initialize NodeJS (front-end) container.
# -> NOTICE: Edit "BACKEND_URL" to the desired Swift back-end url.
docker build --build-arg BACKEND_URL=$BACKEND_URL -t empower/front:1.0 ./storefront 
docker run -d -p 80:80 --name empower-front empower/front:1.0