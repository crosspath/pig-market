# pig_market

Test project for learning Crystal / PostgreSQL.

## Setting up the project

### If you're using Linux

Tested on Ubuntu/Kubuntu 18.10.

1. Install from OS repositories: PostgreSQL, `libyaml-dev`
2. Install [Crystal](https://crystal-lang.org/install/), [Lucky Framework](https://luckyframework.org/guides/getting-started/installing)
3. Install [Forego](https://dl.equinox.io/ddollar/forego/stable), or [Foreman](https://github.com/ddollar/foreman), or [Overmind](https://github.com/DarthSim/overmind), or [Hivemind](https://github.com/DarthSim/hivemind)
4. Create database in PostgreSQL. Run `sudo -u postgres psql` to open PostgreSQL console. Recommendation: run these SQL queries in PostgreSQL console  
```
CREATE USER pig_user PASSWORD '12345678';
CREATE DATABASE pig_db OWNER pig_user;
```
5. Run `git clone` for this repo and go to the cloned repo in `Terminal / Konsole` (type `cd`, space and path to the cloned repo on your computer). All next commands should be run in the cloned repo.
6. Copy `.env.template` to `.env` in the cloned repo and replace here `DATABASE_URL` and `API_KEY`. Parameter `DATABASE_URL` should include connection settings for user name, user password & database in PostgreSQL. Parameter `API_KEY` may have any string value. Recommendation: run `nano .env.template`, replace `DATABASE_URL` and `API_KEY`, press `Ctrl+O` (`O` as letter), delete `.template`, press `Enter/Return` and then press `Ctrl+X`.
7. Run `shards install` to download required libraries
8. Run `lucky db.migrate` to create tables in the database
9. Run `lucky db.create_sample_seeds` to generate sample rows
10. Run `lucky dev` to start the app

### If you're using MacOS

Tested on MacOS Catalina (10.15.4).

1. Install [Homebrew](https://brew.sh/), [Crystal](https://crystal-lang.org/install/), [PostgreSQL](https://www.postgresql.org/download/), [Lucky Framework](https://luckyframework.org/guides/getting-started/installing)
2. Install [Forego](https://dl.equinox.io/ddollar/forego/stable), or [Foreman](https://github.com/ddollar/foreman), or [Overmind](https://github.com/DarthSim/overmind), or [Hivemind](https://github.com/DarthSim/hivemind). Recommendation: `brew install forego`.
3. Run PostgreSQL server service, see [answers in StackOverflow](https://stackoverflow.com/questions/7975556/how-to-start-postgresql-server-on-mac-os-x#answers)
4. Create database in PostgreSQL. Recommendation: run these SQL queries in PostgreSQL console  
```
CREATE USER pig_user PASSWORD '12345678';
CREATE DATABASE pig_db OWNER pig_user;
```
5. Run `git clone` for this repo and go to the cloned repo in `Terminal` (type `cd`, space and path to the cloned repo on your computer). All next commands should be run in the cloned repo.
6. Copy `.env.template` to `.env` in the cloned repo and replace here `DATABASE_URL` and `API_KEY`. Parameter `DATABASE_URL` should include connection settings for user name, user password & database in PostgreSQL. Parameter `API_KEY` may have any string value. Recommendation: `nano .env.template`, replace `DATABASE_URL` and `API_KEY`, press `Ctrl+O` (`O` as letter), delete `.template`, press `Enter/Return` and then press `Ctrl+X`.
7. Run `shards install` to download required libraries
8. Run `lucky db.migrate` to create tables in the database
9. Run `lucky db.create_sample_seeds` to generate sample rows
10. Run `lucky dev` to start the app

## Usage

Use your `API_KEY` as a query parameter with all your API queries.

### Users

`index.cr`  
List users:

    http://localhost:5000/api/users?api_key=any-string

`show.cr`  
User info, addresses and orders (replace `123` with a user id):

    http://localhost:5000/api/users/123?api_key=any-string

`bonuses.cr`  
Earned bonuses for a user (replace `123` with a user id):

    http://localhost:5000/api/users/123/bonuses?api_key=any-string

`delivery_points.cr`  
Used delivery points for a user (replace `123` with a user id):

    http://localhost:5000/api/users/123/delivery_points?api_key=any-string

`user_orders.cr`  
List orders for this user as a customer (replace `123` with a user id):

    http://localhost:5000/api/users/123/user_orders?api_key=any-string

`store_orders.cr`  
List orders for this user as a worker of a store (replace `123` with a user id):

    http://localhost:5000/api/users/123/store_orders?api_key=any-string

### Units

`index.cr`  
List units:

    http://localhost:5000/api/units?api_key=any-string

`show.cr`  
What goods are destributed in this unit (package)? Replace `123` with a unit id:

    http://localhost:5000/api/units/123?api_key=any-string

### Goods

`index.cr`  
List goods:

    http://localhost:5000/api/goods?api_key=any-string

`show.cr`  
More info about selected goods (replace `123` with a goods id):

    http://localhost:5000/api/goods/123?api_key=any-string

### Categories

`index.cr`  
List categories:

    http://localhost:5000/api/categories?api_key=any-string

`show.cr`  
List goods in selected category and nested categories (replace `123` with a category id):

    http://localhost:5000/api/categories/123?api_key=any-string

### User Orders

`index.cr`  
List user orders (for customers, *b2c*):

    http://localhost:5000/api/user_orders?api_key=any-string

`show.cr`  
User order info (replace `123` with an order id):

    http://localhost:5000/api/user_orders/123?api_key=any-string

### Store Orders

`index.cr`  
List store orders (from stores to stores, *b2b*):

    http://localhost:5000/api/store_orders?api_key=any-string

`show.cr`  
Store order info (replace `123` with an order id):

    http://localhost:5000/api/store_orders/123?api_key=any-string

### Stores

`index.cr`  
List stores:

    http://localhost:5000/api/stores?api_key=any-string

`show.cr`  
Goods in selected store (replace `123` with a store id):

    http://localhost:5000/api/stores/123?api_key=any-string

### Delivery Points

`index.cr`  
List delivery points:

    http://localhost:5000/api/delivery_points?api_key=any-string

### Addresses

`index.cr`  
List addresses:

    http://localhost:5000/api/addresses?api_key=any-string

`show.cr`  
Address info (replace `123` with an address id):

    http://localhost:5000/api/addresses/123?api_key=any-string
