# pig_market

Test project for learning Crystal / PostgreSQL.

See installation steps in [INSTALL.md](INSTALL.md)

## Usage

Use your `API_KEY` (defined in `.env`) as a query parameter with all your API queries.

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
