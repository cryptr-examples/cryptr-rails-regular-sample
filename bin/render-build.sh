#!/usr/bin/env bash
# exit on error
set -o errexit

echo "🧪 lock to linux bundle"
bundle lock --add-platform x86_64-linux

echo "🚀 start bundle install and other rake exec"
bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
