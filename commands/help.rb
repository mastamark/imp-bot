class Help < SlackRubyBot::Commands::Base
  HELP = <<-EOS.freeze
```
I am imp-bot, here to help.

General
-------

help               - get this helpful message
whoami             - print your username
echo               - repeats whatever you just said back to you


Based off Open-Source at https://github.com/slack-ruby/slack-ruby-bot-server
```
  EOS
  def self.call(client, data, _match)
    client.say(channel: data.channel, text: [HELP])
    logger.info "HELP: #{client.owner}, user=#{data.user}"
  end
end
