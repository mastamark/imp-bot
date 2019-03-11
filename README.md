# imp-bot

An app incarnation of the sample [slack-ruby-bot-server](https://github.com/slack-ruby/slack-ruby-bot-server) with ActiveRecord, customized for common operations for a development team.

It combines a few operations as inspired from:

- https://github.com/dblock/slack-aws
- https://github.com/accessd/slack-deploy-bot

## Develop

Make a new command in ./commands/. Each command is its own class. 3 simple commands are included, and a ton more exist at any of the github repos from above.

## Setup

- Setup postgres database somewhere
- Export envs necessary to connect to it:
  - POSTGRES_HOST
  - POSTGRES_PORT
  - POSTGRES_USERNAME
  - POSTGRES_PASSWORD
  - SLACK_CLIENT_ID
  - SLACK_CLIENT_SECRET
- Export envs as necessary for various specific commands
  - OCTOKIT_ACCESS_TOKEN (\* to use the 'release' command)

### Run

```
bundle install
bundle exec rake db:create db:migrate
bundle exec unicorn -p 9292
```

## Docker

Dockerfile and (dev hackathon quality at best) docker-compose file included.

Suggested deploy is to use some hosted db (rds) service for the data and deploy the bot docker image to point at it.

This 'fork' of the slack-ruby-bot-server includes logic that will initialize any commands found in the subfolder "commands." In theory one could run this docker image and mount their own "commands" folder to /srv/commands and the docker container would simply load those up. Huzzah!
