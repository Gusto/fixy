FROM ruby:3.2.2-slim

WORKDIR /home/gusto

ADD . /home/gusto/

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential\
  git
RUN gem install bundler:2.1.4
RUN bundle install
