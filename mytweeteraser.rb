#! /usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'twitter'
require 'csv'
load File.expand_path("../credential_twitter.rb", __FILE__)
MAX_TWEET_ID = 334334334

#==============================================
# MAX_TWEET_IDにセットされたIDのツイートより過去のツイートを全て消す
# tweets.csvはTwitterWebサイトよりリクエストする
#==============================================


client = Twitter::REST::Client.new do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.access_token = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

csv_data = CSV.read('tweets.csv', headers: true)
ctr = 0
csv_data.each do |tweet|
  tweet_id = (tweet['tweet_id']).to_i
  if tweet_id <= MAX_TWEET_ID
    ctr += 1

    printf("[%d]%d ", ctr, tweet_id)
    begin
      printf("%s", client.destroy_status(tweet_id))
    rescue => e
      printf("FAIL: %s", e.message)
    end
    printf("\n")

    # for avoiding api rate limit
    sleep(1000) if ctr % 150 == 0
  end
end
