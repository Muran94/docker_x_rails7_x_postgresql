#!/bin/bash

# 1. Docker compose build
printf '\033[36m%s\033[m\n' 'docker compose build --no-cache'
docker compose build --no-cache
wait



# 2. Rails new
printf '\033[36m%s\033[m\n' 'docker compose run --no-deps web rails new . --force --skip-bundle --database=postgresql'
docker compose run --no-deps web rails new . --force --skip-bundle --database=postgresql -j esbuild
wait



# 3. Bundle install
printf '\033[36m%s\033[m\n' 'docker compose run --no-deps web bundle install'
docker compose run --no-deps web bundle install
wait



# 4. Configure database
printf '\033[36m%s\033[m\n' 'Configuring database...'
cp -f database.yml config/database.yml && rm database.yml
docker compose run web bundle exec rails db:create
wait



# 5. docker-compose up -d
printf '\033[36m%s\033[m\n' 'Starting server background...'
docker compose up -d
wait



# 5. Enter web container
printf '\033[36m%s\033[m\n' 'Enter web container'
docker compose exec web sh
wait