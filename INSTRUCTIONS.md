# Instructions to initialize your rails app.
## Step.1 Copy the folder.
Copy this folder and create your own.

```bash
$ cp -r <path to this directory> <path to your app directory>

# Example
$ cp -r ../docker/templates/rails7_x_postgresql my_app
```


## Step.2 Edit .env file.
Add a value to the APP_NAME.
Only use snakecase letters.
```
APP_NAME=<some_name>
```

## Step.3 Initialize the app.
Either run a script to initialize the app, or initialize manually by running the commands bellow.

### How to run the initializer script.
`$ ./scripts/shell/app_initializer.sh`

### How to initialize manually.

```bash
docker compose build --no-cache
docker compose run --no-deps web rails new . --force --skip-bundle --database=postgresql -j esbuild
docker compose run --no-deps web bundle install
cp -f database.yml config/database.yml && rm database.yml
docker compose run web bundle exec rails db:create
docker compose up -d
docker compose exec web sh
```
