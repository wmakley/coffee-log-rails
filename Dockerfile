FROM ruby:3.1.2
LABEL maintainer="will@willmakley.dev"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends \
      nodejs \
      npm \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

ARG BUNDLER_VERSION=2.3.26
ARG YARN_VERSION=1.22.19

RUN npm -g install yarn@${YARN_VERSION}
RUN gem install bundler:${BUNDLER_VERSION}

RUN bundle config --global frozen 1
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle config set --local without development test
RUN bundle install

COPY package.json yarn.lock /usr/src/app/
RUN yarn install

COPY . /usr/src/app

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

RUN bundle exec rails DATABASE_URL=postgresql:does_not_exist assets:precompile

EXPOSE 8080
CMD ["/usr/src/app/bin/rails", "server", "-b", "0.0.0.0", "-p", "8080"]
