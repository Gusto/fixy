FROM ruby:2.6.5-stretch

WORKDIR /home/gusto

ADD . /home/gusto/

RUN gem install bundler:2.1.4
RUN bundle install
