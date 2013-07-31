class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user  = tweet.user

    # set up Twitter OAuth client here
    # actually make API call
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here

    # @consumer ||= OAuth::Consumer.new(
    #   ENV['TWITTER_KEY'],
    #   ENV['TWITTER_SECRET'],
    #   :site => "https://api.twitter.com"
    # )

    # host_and_port = request.host
    # host_and_port << ":9393" if request.host == "localhost"

    # the `oauth_consumer` method is defined above

    # session[:request_token] = @consumer.get_request_token(
    #   :oauth_callback => "http://localhost:9393/auth"
    # )

    Twitter.configure do |config|
      config.oauth_token = user.oauth_token
      config.oauth_token_secret = user.oauth_secret
    end

    Twitter.update(tweet.status)
  end
end
