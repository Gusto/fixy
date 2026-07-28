#!/usr/bin/env ruby
# frozen_string_literal: true

# Build and publish this gem to Cloudsmith. Idempotent: skips the push if this
# version is already published (Cloudsmith does not 409 a duplicate version -- it
# leaves a Failed package -- so we check first). Uses Net::HTTP rather than curl
# so it works in the slim Ruby image, which ships no curl. CLOUDSMITH_API_KEY is
# minted by the cloudsmith-auth plugin (publish mode); gem push reads it as
# GEM_HOST_API_KEY="Bearer <token>".
require 'net/http'
require 'json'

key = ENV.fetch('CLOUDSMITH_API_KEY') { abort('ERROR: CLOUDSMITH_API_KEY is required') }
spec = Gem::Specification.load('fixy.gemspec') || abort('could not load fixy.gemspec')

api = URI('https://api.cloudsmith.io/v1/packages/gusto/gusto/')
api.query = URI.encode_www_form(query: "name:#{spec.name} version:#{spec.version}")
get = Net::HTTP::Get.new(api)
get['X-Api-Key'] = key
res = Net::HTTP.start(api.host, api.port, use_ssl: true) { |http| http.request(get) }
if res.is_a?(Net::HTTPSuccess) &&
   JSON.parse(res.body).any? { |p| p['version'] == spec.version.to_s && p['status_str'] == 'Completed' }
  puts "#{spec.name} #{spec.version} already published to Cloudsmith; skipping."
  exit 0
end

system('gem', 'build', 'fixy.gemspec') || abort('gem build failed')
gem_file = "#{spec.name}-#{spec.version}.gem"
ENV['GEM_HOST_API_KEY'] = "Bearer #{key}"
system('gem', 'push', '--host', 'https://ruby.cloudsmith.io/gusto/gusto', gem_file) || abort('gem push failed')
puts "Published #{spec.name} #{spec.version} to Cloudsmith."
