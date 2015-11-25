#!/bin/bash
  echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
  sudo aptitude update
  sudo aptitude install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libcurl4-openssl-dev curl wget

echo '--> Installing git'
  sudo aptitude install -y git

echo '--> Installing Nodejs'
  sudo add-apt-repository ppa:chris-lea/node.js
  sudo aptitude install -y nodejs

echo '--> Installing Imagemagick'
  sudo aptitude install -y imagemagick

echo '--> Installing PostgreSQL'
  sudo aptitude install -y postgresql-9.3 libpq-dev postgresql-server-dev-9.3

echo '--> Installing rbenv'
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

echo '--> Installing ruby'
  export RBENV_ROOT="${HOME}/.rbenv"
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  export PATH="${RBENV_ROOT}/shims:${PATH}"
  rbenv install 2.1.4
  rbenv global 2.1.4
  gem install bundler
  rbenv rehash

echo '--> Running Bundler'
  cd /vagrant
  bundle
  rbenv rehash
  sudo sudo -u postgres psql -1 -c "CREATE USER vagrant WITH PASSWORD 'secret';"
  sudo sudo -u postgres psql -1 -c "ALTER USER vagrant WITH SUPERUSER;"
  cp config/database.yml.sample config/database.yml

echo '--> Running Rails'

  rake db:setup

  rails s -b 0.0.0.0
