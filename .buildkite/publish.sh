#!/usr/bin/env bash
set -e

# CLOUDSMITH_API_KEY is minted by the cloudsmith-auth Buildkite plugin
# (publish mode) and passed into this container via `docker-compose run -e`.
: "${CLOUDSMITH_API_KEY:?ERROR: CLOUDSMITH_API_KEY is required}"

gem build fixy.gemspec

VERSION="$(ruby -e "puts Gem::Specification.load('fixy.gemspec').version")"
GEM_FILE="fixy-${VERSION}.gem"

# Idempotency: skip the push only if THIS exact name+version is already Completed in Cloudsmith.
# Cloudsmith's ?query= is a fuzzy token search (version:1.2.3 can match 1.2.30; name matches
# related packages), so we parse the JSON and require an exact name+version+status match rather
# than grepping the whole response. Best-effort: on any lookup failure (empty/401/parse error)
# we fall through to the push, since the push is the source of truth.
if curl -sS -H "X-Api-Key: ${CLOUDSMITH_API_KEY}" \
     "https://api.cloudsmith.io/v1/packages/gusto/gusto/?query=name:fixy+version:${VERSION}" 2>/dev/null \
   | ruby -rjson -e 'pkgs = (JSON.parse(STDIN.read) rescue nil); exit(pkgs.is_a?(Array) && pkgs.any? { |p| p["name"] == "fixy" && p["version"] == ARGV[0] && p["status_str"] == "Completed" } ? 0 : 1)' "$VERSION"; then
  echo "fixy ${VERSION} is already published to Cloudsmith - skipping push."
  exit 0
fi

# gem push reads the token via GEM_HOST_API_KEY (not argv); no `set -x` here so the Bearer
# token is never echoed into the build log.
GEM_HOST_API_KEY="Bearer ${CLOUDSMITH_API_KEY}" \
  gem push --host https://ruby.cloudsmith.io/gusto/gusto "${GEM_FILE}"
