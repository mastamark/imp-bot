# imp-bot

An app incarnation of the sample [slack-ruby-bot-server](https://github.com/slack-ruby/slack-ruby-bot-server) with ActiveRecord, customized for common operations for a development team.

It combines a few operations as inspired from:
* https://github.com/dblock/slack-aws
* https://github.com/accessd/slack-deploy-bot

## Setup

* Setup postgres database somewhere
* Export envs necessary to connect to it:
  * POSTGRES_HOST
  * POSTGRES_PORT
  * POSTGRES_USERNAME
  * POSTGRES_PASSWORD
  * SLACK_CLIENT_ID
  * SLACK_CLIENT_SECRET

### Run

```
bundle install
bundle exec rake db:create db:migrate
bundle exec rackup
bundle exec unicorn -p 9292
```
