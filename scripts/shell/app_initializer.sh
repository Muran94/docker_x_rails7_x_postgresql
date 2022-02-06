#!/bin/bash

# 1. Docker compose build
printf '\033[36m%s\033[m\n' 'docker compose build --no-cache'
docker compose build --no-cache
wait

# 2. Rails new
printf '\033[36m%s\033[m\n' 'docker compose run --no-deps web rails new . --force --skip-bundle --database=postgresql'
docker compose run --no-deps web rails new . --force --skip-bundle --database=postgresql
wait

# 3. Bundle install
printf '\033[36m%s\033[m\n' 'docker compose run --no-deps web bundle install'
docker compose run --no-deps web bundle install
wait

# 4. Configure database
printf '\033[36m%s\033[m\n' 'Configuring database...'
cp -f database.template.yml config/database.yml && rm database.template.yml
docker compose run web bundle exec rails db:create
wait

# 5. Replace .gitignore.
printf '\033[36m%s\033[m\n' 'Replacing.gitignore file.'
cp -f .gitignore.template .gitignore && rm .gitignore.template
wait

# 6. Initializing git.
printf '\033[36m%s\033[m\n' 'Initializing Git.'
git add . git commit -m "Initialized App"
wait

# 7. docker-compose up -d
printf '\033[36m%s\033[m\n' 'Starting server background...'
docker compose up -d
wait

# 8. Enter web container
printf '\033[36m%s\033[m\n' 'Enter web container'
docker compose exec web sh
wait