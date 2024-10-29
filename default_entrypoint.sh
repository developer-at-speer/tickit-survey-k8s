#!/bin/bash

set -x
bundle exec rake db:create db:schema:load
bundle exec rails s -p 3000 -b 0.0.0.0
