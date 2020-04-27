# Base image
FROM ubuntu:18.04

# Information
LABEL maintainer="FrozenFOXX <frozenfoxx@churchoffoxx.net>"

# Variables
ENV APP_HOME="/app" \
  APP_DEPS="ruby rubygems sqlite3 whiptail wget" \
  BUILD_DEPS="build-essential libgdbm-dev libgdbm-compat-dev libsqlite3-dev libssl-dev ruby-dev software-properties-common zlib1g-dev" \
  DATAROOT="/data" \
  DEBIAN_FRONTEND=noninteractive \
  DOOMWADDIR="/data/wads" \
  MODE="server"
WORKDIR ${WORKDIR}

# Install packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      ${APP_DEPS} \
      ${BUILD_DEPS}

# Set up RubyGems
RUN gem update --system && \
  gem install bundler

# Install Gems
COPY ./gloom/Gemfile* /app/gloom/
RUN cd /app/gloom && \
  bundle config set system 'true' && \
  bundle install

# Add source
COPY . /app

# Set up Zandronum
RUN mkdir -p /root/.config/zandronum && \
  cp /app/configs/zandronum.ini /root/.config/zandronum/ && \
  /app/scripts/install_zandronum.sh

# Clean up unnecessary packages
RUN apt-get remove -y ${BUILD_DEPS} && \
  apt-get autoremove --purge -y && \
  rm -rf /var/lib/apt/lists/*

# Expose ports
EXPOSE 8080 10666

# Launch processes
ENTRYPOINT ["./scripts/entrypoint.sh"]
