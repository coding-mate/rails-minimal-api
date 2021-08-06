FROM ruby:3.0.1-alpine3.13 AS rails-app-base

ARG RAILS_ROOT=/app
ARG PACKAGES="tzdata sqlite-libs"

WORKDIR $RAILS_ROOT

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES

RUN addgroup -S appgroup \
    && adduser -S appuser -G appgroup -u 1000

RUN mkdir -p $RAILS_ROOT && chown appuser:appgroup $RAILS_ROOT

USER appuser

############### Build step ###############
FROM rails-app-base AS rails-app-build-env

ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="sqlite-dev yaml-dev zlib-dev"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

USER root

RUN apk add --no-cache $BUILD_PACKAGES $DEV_PACKAGES

COPY Gemfile* ./

RUN bundle config --global frozen 1 \
    && bundle config --local path vendor/bundle \
    && bundle config deployment "true" \
    && bundle config without "development test" \
    && bundle install -j4 --retry 3 \
    && rm -rf vendor/bundle/ruby/3.0.0/cache/*.gem \
    && find vendor/bundle/ruby/3.0.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/3.0.0/gems/ -name "*.o" -delete

COPY . .

RUN rm -rf tmp/cache spec

RUN mkdir -p $RAILS_ROOT && chown appuser:appgroup $RAILS_ROOT

USER appuser

############### Dev step ###############
FROM rails-app-base AS rails-app-dev

ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git bash"
ARG DEV_PACKAGES="sqlite-dev yaml-dev zlib-dev"

ENV RAILS_ENV=development
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

USER root

RUN apk add --no-cache $BUILD_PACKAGES $DEV_PACKAGES

USER appuser

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 3000

CMD bin/rails server -b 0.0.0.0

############### Prod step ###############
FROM rails-app-base AS web

ARG RAILS_ROOT=/app
ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

COPY --from=rails-app-build-env $RAILS_ROOT $RAILS_ROOT

USER root

RUN chown -R appuser:appgroup $RAILS_ROOT \
    && chmod +x ./entrypoint.sh

USER appuser

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 3000

CMD bin/rails server -b 0.0.0.0
