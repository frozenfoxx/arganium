# Base image
FROM ubuntu:18.04

# Information
LABEL maintainer="FrozenFOXX <frozenfoxx@churchoffoxx.net>"

# Variables
ENV DATAROOT="/data" \
    DOOMWADDIR="/data/wads" \
    MODE="server"

# Install packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      bash \
      ruby \
      rubygems \
      whiptail

# Clean up unnecessary packages
RUN apt-get autoremove --purge -y

# Set up RubyGems
RUN gem update && \
  gem install bundler

# Copy over app
COPY . /app

# Install Gems
RUN cd /app/gloom && \
  bundle install

# Expose ports
EXPOSE 8080

# Launch processes
ENTRYPOINT ["/app/scripts/entrypoint.sh"]

