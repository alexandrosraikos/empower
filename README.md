# Empower
*~ The absolute motivational tool. ~*

Empower is a web service which serves you the freshest, coolest, most inspiring quote each and every day. Don't find that quote inspiring enough? Demand greatness!

## Architecture
Empower is comprised of three components:
1. Front-end Storefront (NodeJS w/ React)
2. Back-end Request Handler (Swift)
3. Quote Database (MongoDB)

Everything communicates via REST API. Simple! Motivational!

### Storefront (Front-end)
A simple front-end React App which fetches quotes from the back-end. Functionality includes refreshing manually for a new inspirational quote, or refreshing automatically after a given amount of time.

### Request Handler (Back-end)
A Swift component designed to handle secure transactions with the database and the Storefront.

### Quote Database (Database)
A MongoDB instance storing all quote data.