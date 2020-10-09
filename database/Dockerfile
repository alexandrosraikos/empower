FROM mongo

COPY quotes.json /quotes.json

CMD mongoimport --host db --db empower --collection quotes --type json --file /quotes.json --jsonArray