# Base image
FROM ubuntu:18.04

# Information
LABEL maintainer="FrozenFOXX <frozenfoxx@churchoffoxx.net>"

# Variables
ENV APP_HOME="/app" \
  DATAROOT="/data" \
  DOOMWADDIR="/data/wads" \
  MODE="server"
WORKDIR ${APP_HOME}

# Install packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      bash \
      ruby \
      ruby-dev \
      rubygems \
      whiptail

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
RUN mkdir -p /root/.config/zandronum
COPY ${APP_HOME}/configs/zandronum.ini /root/.config/zandronum/
RUN ${APP_HOME}/scripts/install_zandronum.sh

# Clean up unnecessary packages
RUN apt-get autoremove --purge -y

# Expose ports
EXPOSE 8080

# Launch processes
ENTRYPOINT ["${APP_HOME}/scripts/entrypoint.sh"]

