# pig_market

Test project for learning Crystal / PostgreSQL / JavaScript.

### Setting up the project

1. Install [Crystal](https://crystal-lang.org/reference/installation/)
2. Install [Lucky Framework](http://luckyframework.org/guides/installing.html)
3. Create database
4. Copy `.env.template` to `.env` and replace there `DATABASE_URL` and `API_KEY`
5. Run `lucky db.migrate` to create tables in the database
6. Run `lucky db.create_sample_seeds` to generate sample rows
7. Run `lucky dev` to start the app

## Usage

Use your `API_KEY` as a query parameter with all your API queries.

List users:

    http://localhost:3001/api/users?api_key=any-string

User info, addresses and orders (replace `123` with a user id):

    http://localhost:3001/api/users/123?api_key=any-string

Earned bonuses for a user (replace `123` with a user id):

    http://localhost:3001/api/users/123/bonuses?api_key=any-string

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

List orders:

    http://localhost:3001/api/orders?api_key=any-string

Order info (replace `123` with an order id):

    http://localhost:3001/api/orders/123?api_key=any-string

List stores:

    http://localhost:3001/api/stores?api_key=any-string

Goods in selected store (replace `123` with a store id):

    http://localhost:3001/api/stores/123?api_key=any-string

