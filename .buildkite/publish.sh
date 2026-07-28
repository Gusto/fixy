#!/usr/bin/env bash
set -x -e

# CLOUDSMITH_API_KEY is minted by the cloudsmith-auth Buildkite plugin
# (publish mode) and passed into this container via `docker-compose run -e`.
gem build fixy.gemspec
GEM_HOST_API_KEY="Bearer ${CLOUDSMITH_API_KEY}" \
  gem push --host https://ruby.cloudsmith.io/gusto/gusto fixy-*.gem
