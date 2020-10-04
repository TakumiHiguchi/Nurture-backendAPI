FROM ruby:2.5.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

RUN mkdir /nurtureAPI
WORKDIR /nurtureAPI

COPY Gemfile /nurtureAPI/Gemfile
COPY Gemfile.lock /nurtureAPI/Gemfile.lock

RUN gem install bundler
RUN bundle install

EXPOSE 3020

CMD bundle exec rails server
