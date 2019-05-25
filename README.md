# pig_market

Test project for learning Crystal / PostgreSQL / JavaScript.

## Setting up the project

### If you're using Linux

Tested on Ubuntu/Kubuntu 18.10.

1. Install from OS repositories: PostgreSQL, `libyaml-dev`, `nodejs` (or `node.js`; tested on v8 & v12)
2. Install [Crystal](https://crystal-lang.org/reference/installation/), [Lucky Framework](http://luckyframework.org/guides/installing.html), [Yarn](https://yarnpkg.com/en/docs/install)
3. Install [Forego](https://dl.equinox.io/ddollar/forego/stable), or [Foreman](https://github.com/ddollar/foreman), or [Overmind](https://github.com/DarthSim/overmind), or [Hivemind](https://github.com/DarthSim/hivemind)
4. Create database in PostgreSQL. Run `sudo -u postgres psql` to open PostgreSQL console. Recommendation: run these SQL queries in PostgreSQL console  
```
CREATE USER pig_user PASSWORD '12345678';
CREATE DATABASE pig_db OWNER pig_user;
```
5. Run `git clone` for this repo and go to the cloned repo in `Terminal / Konsole` (type `cd`, space and path to the cloned repo on your computer). All next commands should be run in the cloned repo.
6. Copy `.env.template` to `.env` in the cloned repo and replace here `DATABASE_URL` and `API_KEY`. Parameter `DATABASE_URL` should include connection settings for user name, user password & database in PostgreSQL. Parameter `API_KEY` may have any string value. Recommendation: run `nano .env.template`, replace `DATABASE_URL` and `API_KEY`, press `Ctrl+O` (`O` as letter), delete `.template`, press `Enter/Return` and then press `Ctrl+X`.
7. Run `shards install && yarn install` to download required libraries
8. Run `echo {} > public/mix-manifest.json`
9. Run `lucky db.migrate` to create tables in the database
10. Run `lucky db.create_sample_seeds` to generate sample rows
11. Run `lucky dev` to start the app

### If you're using MacOS

Tested on MacOS Mojave.

1. Install [Homebrew](https://brew.sh/), [Crystal](https://crystal-lang.org/reference/installation/), [PostgreSQL](https://www.postgresql.org/download/), [Lucky Framework](http://luckyframework.org/guides/installing.html), [Node.js](https://nodejs.org/en/download/package-manager/) (tested on v12), [Yarn](https://yarnpkg.com/en/docs/install)
2. Install [Forego](https://dl.equinox.io/ddollar/forego/stable), or [Foreman](https://github.com/ddollar/foreman), or [Overmind](https://github.com/DarthSim/overmind), or [Hivemind](https://github.com/DarthSim/hivemind). Recommendation: `brew install forego`.
3. Run PostgreSQL server service, see [answers in StackOverflow](https://stackoverflow.com/questions/7975556/how-to-start-postgresql-server-on-mac-os-x#answers)
4. Add this line to your `~/.bash_profile` file:  
```
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
```
5. Create database in PostgreSQL. Recommendation: run these SQL queries in PostgreSQL console  
```
CREATE USER pig_user PASSWORD '12345678';
CREATE DATABASE pig_db OWNER pig_user;
```
6. Run `git clone` for this repo and go to the cloned repo in `Terminal` (type `cd`, space and path to the cloned repo on your computer). All next commands should be run in the cloned repo.
7. Copy `.env.template` to `.env` in the cloned repo and replace here `DATABASE_URL` and `API_KEY`. Parameter `DATABASE_URL` should include connection settings for user name, user password & database in PostgreSQL. Parameter `API_KEY` may have any string value. Recommendation: `nano .env.template`, replace `DATABASE_URL` and `API_KEY`, press `Ctrl+O` (`O` as letter), delete `.template`, press `Enter/Return` and then press `Ctrl+X`.
8. Run `shards install && yarn install` to download required libraries
9. Run `echo {} > public/mix-manifest.json`
10. Run `lucky db.migrate` to create tables in the database
11. Run `lucky db.create_sample_seeds` to generate sample rows
12. Run `lucky dev` to start the app

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

