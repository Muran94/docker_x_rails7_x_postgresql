# Instructions to initialize your rails app.
## Step. 1
Copy this folder and create your own.

`$ cp -r <path to this directory> <path to your app directory>`

exp) `$ cp -r ../docker/templates/rails7_x_postgresql my_app`

## Step. 2
Either run a script to initialize the app, or initialize manually by running the commands bellow.

### How to run the initializer script.
`./scripts/shell/app_initializer.sh`

### How to initialize manually.
1. `docker compose build --no-cache`
2. `docker compose run --no-deps web rails new . --force --skip-bundle --database=postgresql -j esbuild`
3. `docker compose run --no-deps web bundle install`
4. `cp -f database.yml config/database.yml && rm database.yml`
5. `docker compose run web bundle exec rails db:create`
6. `docker compose up -d`
7. `docker compose exec web sh`
