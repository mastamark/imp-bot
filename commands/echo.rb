class Echo < SlackRubyBot::Commands::Base
  def self.call(client, data, _match)
    client.say(channel: data.channel, text: "#{just_the_facts(data.text)}")
    logger.info "ECHO: #{client.owner}, user=#{data.user}"
  end

  def self.just_the_facts(data)
    data.partition('echo').last
  end
end