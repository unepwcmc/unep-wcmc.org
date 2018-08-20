FROM ruby:2.2.2
RUN apt-get update && apt-get -y install build-essential libpq-dev nodejs
RUN gem install bundler
RUN mkdir /wcmc
WORKDIR /wcmc
ADD Gemfile /wcmc/Gemfile
ADD Gemfile.lock /wcmc/Gemfile.lock
RUN bundle install

ADD . /wcmc
