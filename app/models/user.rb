class User < ActiveRecord::Base
  has_many :tweets

  def tweet(status, delay)
    tweet = tweets.create!(:status => status)
    if delay == 0
      TweetWorker.perform_async(tweet.id)
    else
      TweetWorker.perform_in(delay.seconds, tweet.id)
    end
  end
end
