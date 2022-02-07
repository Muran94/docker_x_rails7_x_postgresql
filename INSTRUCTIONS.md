# Instructions to initialize your rails app.
## Step.1 Copy the folder.
Copy this folder and create your own.

```bash
$ cp -r <path to this directory> <path to your app directory>

# Example
$ cp -r ../docker/templates/rails7_x_postgresql my_app
```

## Step.2 Configure .env file.
Configure the .env files `APP_NAME` value.
The default value for `APP_NAME` is `app`, and will be used to config the WORKDIR and rails new command.

## Step.3 Initialize the app.
Either run a script to initialize the app, or initialize manually by running the commands bellow.

### How to run the initializer script.
`$ ./scripts/shell/app_initializer.sh`

### How to initialize manually.

```bash
docker compose build --no-cache
docker compose run --no-deps web rails new . --force --skip-bundle --database=postgresql
git init && git commit -am "Initialized App."
docker compose run --no-deps web bundle install
mv -f database.template.yml config/database.yml
docker compose run web bundle exec rails db:create
mv .gitignore.template .gitignore
git commit -am "Configured app."
docker compose up -d
docker compose exec web sh
```