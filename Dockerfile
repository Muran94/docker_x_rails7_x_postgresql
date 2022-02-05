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
    apk add --no-cache build-base git imagemagick tzdata postgresql-client postgresql-dev && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime



# GEMS
FROM base as gems
COPY Gemfile* ./
RUN bundle install && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete && \
    find /usr/local/bundle/gems/ -path '/*/ext/*/Makefile' -exec dirname {} \; | xargs -n1 -P$(nproc) -I{} make -C {} clean



# BASE APP
FROM base as base-app
RUN apk update && \
    apk del --purge build-base && \
    apk add --no-cache vim
COPY . .
COPY --from=gems /usr/local/bundle /usr/local/bundle



# APP FOR DEVELOPMENT AND TEST
FROM base-app as app-for-development-and-test



# APP FOR PRODUCTION
FROM base-app as app-for-production
ENV RAILS_ENV=production \
    RACK_ENV=production \
    RAILS_LOG_TO_STDOUT=enabled \
    RAILS_SERVE_STATIC_FILES=enabled \
    AWS_ACCESS_KEY_ID=dummy \
    AWS_SECRET_ACCESS_KEY=dummy \
    S3_DEFAULT_REGION=dummy \
    S3_DEFAULT_BUCKET=dummy \
    SECRET_KEY_BASE=dummy
RUN rails assets:precompile && \
    chmod +x entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]