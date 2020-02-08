# Base image
FROM ubuntu:18.04

# Information
LABEL maintainer="FrozenFOXX <frozenfoxx@churchoffoxx.net>"

# Variables
ENV DATAROOT=/data

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

# Copy over app
COPY . /app

# Install Gems
RUN cd /app/gloom && \
  gem install bundler && \
  bundle install

# Expose ports
EXPOSE 8080

# Launch processes
ENTRYPOINT ["/app/scripts/entrypoint.sh"]

