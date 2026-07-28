# syntax=docker/dockerfile:1.10.0
FROM ruby:3.2.2-slim

WORKDIR /home/gusto

ADD . /home/gusto/

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  git
RUN gem install bundler:2.1.4
# The Cloudsmith read key is provided as a BuildKit secret (mounted only for
# this step, never baked into a layer) so bundler can authenticate to the
# Cloudsmith Ruby source.
RUN --mount=type=secret,id=cloudsmith_api_key,env=CLOUDSMITH_API_KEY \
  BUNDLE_DL__CLOUDSMITH__IO="token:${CLOUDSMITH_API_KEY}" \
  bundle install
