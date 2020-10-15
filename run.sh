# Initialize MongoDB container and seed data.
docker run -d -p 1920:27017 --name empower-db mongo
docker cp database/quotes.json empower-db:/quotes.json
docker exec -it empower-db mongoimport --db empower --collection quotes --type json --file /quotes.json --jsonArray

# TODO: Initialize Swift (back-end) container.

# Initialize NodeJS (front-end) container.
# -> NOTICE: Edit "BACKEND_URL" to the desired Swift back-end url.
docker build --build-arg BACKEND_URL=exampleurl -t empower/front:1.0 ./storefront && docker run -p 80:80 --name empower-front empower/front:1.0