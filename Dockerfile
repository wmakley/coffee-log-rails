FROM ruby:3.1.3-slim AS build
LABEL maintainer="will@willmakley.dev"

ENV DEBIAN_FRONTEND=noninteractive
# runtime deps (shared by both stages)
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      libpq5 \
      libvips \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/* && apt-get clean
# build deps
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      autoconf \
      automake \
      nodejs \
      npm \
      libpq-dev \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

ARG BUNDLER_VERSION=2.3.26
ARG YARN_VERSION=1.22.19

RUN npm -g install yarn@${YARN_VERSION}
RUN gem install bundler:${BUNDLER_VERSION}

RUN bundle config --global frozen 1
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle config set --local without development test
# RUN bundle config set --local deployment 'true'
RUN bundle install

COPY package.json yarn.lock /usr/src/app/
RUN yarn install

COPY . /usr/src/app

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# TODO: this logs the master key to STDOUT. Is there a better way? The key should not be needed to compile assets.
ARG RAILS_MASTER_KEY
RUN bundle exec rails RAILS_MASTER_KEY=$RAILS_MASTER_KEY DATABASE_URL=postgresql:does_not_exist assets:precompile
RUN rm -rf node_modules

EXPOSE 8080
CMD ["/usr/src/app/bin/rails", "server", "-b", "0.0.0.0", "-p", "8080"]
HEALTHCHECK --start-period=30s CMD curl -f http://localhost:8080/ || exit 1


FROM ruby:3.1.3-slim AS prod
LABEL maintainer="will@willmakley.dev"

ENV DEBIAN_FRONTEND=noninteractive
# runtime deps (shared by both stages)
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      libpq5 \
      libvips \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

ARG BUNDLER_VERSION=2.3.26
RUN gem install bundler:${BUNDLER_VERSION}
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /usr/src/app /usr/src/app

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

EXPOSE 8080
CMD ["/usr/src/app/bin/rails", "server", "-b", "0.0.0.0", "-p", "8080"]
HEALTHCHECK --start-period=30s CMD curl -f http://localhost:8080/ || exit 1
