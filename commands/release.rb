# Attempts to execute a github release based on arguments (as flags) passed.
# https://www.rubydoc.info/gems/octokit/4.1.1/Octokit/Client/Releases#create_release-instance_method
# Usage example:
# @bot release --release-repo=<SOME/REPO> --tag-name=<SOME_TAG> --release-name=<SOME_RELEASE_NAME> ...
class Release < SlackRubyBot::Commands::Base
  HELP = <<-EOS.freeze
  ```
  Release
  -------

  Release attempts to execute a github release (using oktakit/github api) using
  access token as provided from env as OCTOKIT_ACCESS_TOKEN.

  Example invocation:
  release --release-repo=mastamark/imp-bot --tag-name=rc1
  release --repo=mastamark/imp-bot --tag=rc2 --sha=6089ea8c0501320340a3f6db4e64abb52ff42fda --draft

  Flags supported:
  REQUIRED:
  * [--release-repo||--repo]=<foo/bar>: Name of the repo to execute a release against.
  * [--tag-name||--tag]=<foo>]: Name of the release tag.
  OPTIONAL:
  * [--release-name||--name]=<foo>: Name of the release.
  * [--release-draft=true||--draft]: Execute the release as a draft. (complete the release via github ui).
  * [--sha||--target_commitish]: Set the commit sha value where the git tag is created from.  Defaults to repo default branch (eg 'master')
  ```
  EOS

  def self.help(client, data)
    client.say(channel: data.channel, text: [HELP])
    logger.info "HELP: #{client.owner}, user=#{data.user}"
  end

  def self.call(client, data, _match)
    operation = parse_command('release', data.text)
    if operation == 'help'
      help(client, data)
    else
      slack_workspace = client.owner.name.downcase
      slack_user = data.user
      release_repo, tag, octo_args = parse_release_flags(operation, slack_workspace, slack_user)
      client.say(channel: data.channel, text: "Ok - executing a github release of [#{release_repo}] with the tag [#{tag}] and the following argument hash: #{octo_args}")
      logger.info "RELEASE START: #{client.owner}, user=#{data.user}, repo=[#{release_repo}] with tag #{tag}"
      begin
        release = github_release(release_repo, tag, octo_args)
        client.say(channel: data.channel, text: ":success: Success! <@#{data.user}> - Github release of [#{release_repo}] completed the tag [#{tag}].  :success: ")
        logger.info "RELEASE SUCCESS: #{client.owner}, user=#{data.user}, repo=[#{release_repo}] with tag #{tag}"
      rescue StandardError => e
        client.say(channel: data.channel, text: ":sadpanda: Failure! <@#{data.user}> - Github release of [#{release_repo}] with the tag [#{tag}] failed with error: [#{e.message}]. :sadpanda: ")
        logger.info "RELEASE FAIL: #{client.owner}, user=#{data.user}, repo=[#{release_repo}] with tag #{tag}, error=#{e.message}, backtrace=#{e.backtrace.inspect}"
      end
    end
  end

  # github release calls using octokit
  def self.github_release(repo, tag, octo_args)
    @client ||= github_auth
    release = @client.create_release(repo, tag, octo_args)
  end

  # Map flags notation to hash notation needed for octokit
  def self.parse_release_flags(args, slack_workspace, slackuser)
    octo_args = {}
    release_repo = nil
    tag = nil

    args.split(/\s+/).each do |arg|
      kw, value = arg.split('=', 2)
      case kw
      when '--release-repo', '--repo'
        release_repo = value
      when '--tag-name', '--tag'
        tag = value
      when '--release-name', '--name'
        octo_args['name'] = value
      when '--release-draft', '--draft'
        octo_args["draft"] = true if value.nil? || value !~ /^(false|no)/i
      when '--target_commitish', '--sha'
        octo_args["target_commitish"] = value
      else
        raise "Unknown flag '#{kw}' - Try 'release help' for reference"
      end
    end

    # Always make sure we add the username of the person who requested the release.
    octo_args['body'] = "IMp-bot release executed for https://#{slack_workspace}.slack.com/team/#{slackuser}"

    return release_repo, tag, octo_args
  end

  def self.parse_command(keyword,data)
    data.partition("#{keyword}").last.strip
  end

  def self.github_auth()
    # Reads OCTOKIT_ACCESS_TOKEN (oauth token) from env
    @client = Octokit::Client.new if not @client
  end
end
