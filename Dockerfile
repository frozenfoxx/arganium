# Base image
FROM ubuntu:18.04

# Information
LABEL maintainer="FrozenFOXX <frozenfoxx@churchoffoxx.net>"

# Variables
WORKDIR /app
ENV DATAROOT="/data" \
    DOOMWADDIR="/data/wads" \
    MODE="server"

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

# Copy over app
COPY . /app

# Install Gems
RUN cd /app/gloom && \
  bundle install --system

# Set up Zandronum
RUN mkdir -p /root/.config/zandronum
COPY /app/configs/zandronum.ini /root/.config/zandronum/
RUN /app/scripts/install_zandronum.sh

# Clean up unnecessary packages
RUN apt-get autoremove --purge -y

# Expose ports
EXPOSE 8080

# Launch processes
ENTRYPOINT ["/app/scripts/entrypoint.sh"]

