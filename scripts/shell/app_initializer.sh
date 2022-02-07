#!/bin/bash

# 1. Docker compose build
printf '\033[36m%s\033[m\n' 'docker compose build --no-cache'
docker compose build --no-cache
wait

# 2. Rails new
printf '\033[36m%s\033[m\n' 'docker compose run --no-deps web rails new . --force --skip-bundle --database=postgresql'
docker compose run --no-deps web rails new . --force --skip-bundle --database=postgresql
wait

# 3. Git init
printf '\033[36m%s\033[m\n' 'Initialize git.'
rm -rf .git && git init && git commit -am "Initialized App."
wait

# 4. Bundle install
printf '\033[36m%s\033[m\n' 'docker compose run --no-deps web bundle install'
docker compose run --no-deps web bundle install
wait

# 5. Configure database
printf '\033[36m%s\033[m\n' 'Configuring database...'
mv -f database.template.yml config/database.yml
docker compose run web bundle exec rails db:create
wait

# 6. Replace .gitignore.
printf '\033[36m%s\033[m\n' 'Replacing.gitignore file.'
mv .gitignore.template .gitignore
wait

# 7. Commit changes to git.
printf '\033[36m%s\033[m\n' 'Commit changes to git.'
git commit -am "Configured app."
wait

# 8. docker-compose up -d
printf '\033[36m%s\033[m\n' 'Starting server background...'
docker compose up -d
wait

# 9. Enter web container
printf '\033[36m%s\033[m\n' 'Enter web container'
docker compose exec web sh
wait