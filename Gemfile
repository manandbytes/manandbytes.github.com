source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

gem 'therubyracer'
gem 'github-pages', versions['github-pages']
gem 'jekyll-feed'
gem 'jekyll-sitemap'
gem 'org-ruby'
