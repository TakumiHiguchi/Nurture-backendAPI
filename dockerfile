FROM ruby:2.5.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR ${APP_ROOT}

COPY Gemfile ${APP_ROOT}
COPY Gemfile.lock ${APP_ROOT}

RUN gem install bundler
RUN bundle install

EXPOSE 3000

CMD bundle exec rails server
