class Help < SlackRubyBot::Commands::Base
  HELP = <<-EOS.freeze
```
I am imp-bot, here to help.

General
-------

help               - get this helpful message
whoami             - print your username
echo               - repeats whatever you just said back to you
release            - execute a github release (consuming OCTOKIT_ACCESS_TOKEN from env)
                   -> call 'release help' for details


Source Repo: https://github.com/mastamark/imp-bot
```
  EOS
  def self.call(client, data, _match)
    client.say(channel: data.channel, text: [HELP])
    logger.info "HELP: #{client.owner}, user=#{data.user}"
  end
end
