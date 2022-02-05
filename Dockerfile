# BASE
FROM ruby:3.1.0-alpine3.15 as base
ARG bundle_jobs
ARG bundle_without
WORKDIR /app
ENV LANG=ja_JP.UTF-8 \
    TZ=Asia/Tokyo \
    BUNDLE_JOBS=$bundle_jobs \
    BUNDLE_WITHOUT=$bundle_without
RUN apk update && \
    apk add --no-cache build-base git imagemagick tzdata postgresql-client postgresql-dev vim yarn && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime



# GEMS
FROM base as gems
COPY Gemfile* ./
RUN bundle install && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete && \
    find /usr/local/bundle/gems/ -path '/*/ext/*/Makefile' -exec dirname {} \; | xargs -n1 -P$(nproc) -I{} make -C {} clean



# YARN
FROM base as yarn
COPY package.json ./
RUN apk add --no-cache python2 && \
    yarn install --check-files && \
    yarn cache clean



# BASE APP
FROM base as base-app
COPY . .
COPY --from=gems /usr/local/bundle /usr/local/bundle
COPY --from=yarn /app/yarn.lock yarn.lock



# APP FOR DEVELOPMENT AND TEST
FROM base-app as app-for-development-and-test



# APP FOR PRODUCTION
FROM base-app as app-for-production
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]