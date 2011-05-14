Twitter.configure do |config|
  config.consumer_key = Settings.twitter.key
  config.consumer_secret = Settings.twitter.secret
  # config.oauth_token = YOUR_OAUTH_TOKEN
  # config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end
