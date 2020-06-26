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
