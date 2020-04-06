# Base image
FROM ubuntu:18.04

# Information
LABEL maintainer="FrozenFOXX <frozenfoxx@churchoffoxx.net>"

# Variables
ENV APP_HOME="/app" \
  APP_DEPS="ruby rubygems sqlite3 whiptail wget" \
  BUILD_DEPS="build-essential libgdbm-dev libgdbm-compat-dev libsqlite3-dev libssl-dev ruby-dev zlib1g-dev" \
  DATAROOT="/data" \
  DEBIAN_FRONTEND=noninteractive \
  DOOMWADDIR="/data/wads" \
  MODE="server"
WORKDIR ${APP_HOME}

# Install packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      ${APP_DEPS} \
      ${BUILD_DEPS}

# Set up RubyGems
RUN gem update && \
  gem update --system && \
  gem install bundler

# Install Gems
COPY ./gloom/Gemfile* ${APP_HOME}/gloom/
RUN cd ${APP_HOME}/gloom && \
  bundle config set system 'true' && \
  bundle install

# Add source
COPY . ${APP_HOME}

# Set up Zandronum
RUN mkdir -p /root/.config/zandronum && \
  cp ${APP_HOME}/configs/zandronum.ini /root/.config/zandronum/ && \
  ${APP_HOME}/scripts/install_zandronum.sh

# Clean up unnecessary packages
RUN apt-get remove ${BUILD_DEPS} && \
  apt-get autoremove --purge -y && \
  rm -rf /var/lib/apt/lists/*

# Expose ports
EXPOSE 8080

# Launch processes
ENTRYPOINT ["${APP_HOME}/scripts/entrypoint.sh"]
