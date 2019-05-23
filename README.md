# pig_market

Test project for learning Crystal / PostgreSQL / JavaScript.

### Setting up the project

1. Install [Crystal](https://crystal-lang.org/reference/installation/), [PostgreSQL](https://www.postgresql.org/download/), `libyaml-dev` (if you're using Linux)
2. Install [Lucky Framework](http://luckyframework.org/guides/installing.html)
3. Create database in PostgreSQL
4. Copy `.env.template` to `.env` and replace here `DATABASE_URL` and `API_KEY`
5. Run `shards install` to download required libraries
6. Run `lucky db.migrate` to create tables in the database
7. Run `lucky db.create_sample_seeds` to generate sample rows. If you don't need running application, you may skip next steps.
8. Install [Node.js](https://nodejs.org/en/download/package-manager/) (tested on v12), [Yarn](https://yarnpkg.com/en/docs/install)
9. Install [Forego](https://dl.equinox.io/ddollar/forego/stable), or [Foreman](https://github.com/ddollar/foreman), or [Overmind](https://github.com/DarthSim/overmind), or [Hivemind](https://github.com/DarthSim/hivemind)
10. Run `yarn install` to download required libraries
11. Run `lucky dev` to start the app

## Usage

Use your `API_KEY` as a query parameter with all your API queries.

List users:

    http://localhost:3001/api/users?api_key=any-string

User info, addresses and orders (replace `123` with a user id):

    http://localhost:3001/api/users/123?api_key=any-string

Earned bonuses for a user (replace `123` with a user id):

    http://localhost:3001/api/users/123/bonuses?api_key=any-string

Used delivery points for a user (replace `123` with a user id):

    http://localhost:3001/api/users/123/delivery_points?api_key=any-string

List orders for this user as a customer (replace `123` with a user id):

    http://localhost:3001/api/users/123/user_orders?api_key=any-string

List orders for this user as a worker of a store (replace `123` with a user id):

    http://localhost:3001/api/users/123/store_orders?api_key=any-string

List units:

    http://localhost:3001/api/units?api_key=any-string

What goods are destributed in this unit (package)? Replace `123` with a unit id:

    http://localhost:3001/api/units/123?api_key=any-string

List goods:

    http://localhost:3001/api/goods?api_key=any-string

More info about selected goods (replace `123` with a goods id):

    http://localhost:3001/api/goods/123?api_key=any-string

List categories:

    http://localhost:3001/api/categories?api_key=any-string

List goods in selected category and nested categories (replace `123` with a category id):

    http://localhost:3001/api/categories/123?api_key=any-string

List user orders (for customers, *b2c*):

    http://localhost:3001/api/user_orders?api_key=any-string

User order info (replace `123` with an order id):

    http://localhost:3001/api/user_orders/123?api_key=any-string

List store orders (from stores to stores, *b2b*):

    http://localhost:3001/api/store_orders?api_key=any-string

Store order info (replace `123` with an order id):

    http://localhost:3001/api/store_orders/123?api_key=any-string

List stores:

    http://localhost:3001/api/stores?api_key=any-string

Goods in selected store (replace `123` with a store id):

    http://localhost:3001/api/stores/123?api_key=any-string

List addresses:

    http://localhost:3001/api/addresses?api_key=any-string

Address info (replace `123` with an address id):

    http://localhost:3001/api/addresses/123?api_key=any-string

