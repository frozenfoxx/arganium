# Gloom

__Gloom__ is the web component to *Arganium*.  It is written in *Rails* and wraps up all the other components into a presentable server.  It presents Challenges, allows the Control team to interact with the Marine team, and otherwise runs the game.

## Requirements
* Certain
* Rails 5.2+
* Ruby 2.4+
* Whiptail
* *Zandronum* executable within PATH

## Setup
The primary component to getting this up and running is the *setup* script.  It contains functionality for building and executing a setup configuration file for the server.  After it is loaded simply run the Rails server and you should be good to go.

### Steps
* `./setup`
* *Walkthrough prompts to create configuration YAML file*
* `./setup <name of configuration file>`
* `SECRET_KEY_BASE=$(rails secret) rails server -b 0.0.0.0`
