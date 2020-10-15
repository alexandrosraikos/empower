FROM mongo
COPY quotes.json /quotes.json
CMD mongoimport --host db --db empower --collection quotes --type json --file /quotes.json --jsonArray
EXPOSE 19999
RUN bash <(curl -Ss https://my-netdata.io/kickstart.sh)