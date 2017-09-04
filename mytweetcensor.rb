#! /usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'twitter'
require 'date'
require 'active_support/all'
load File.expand_path("../credential_twitter.rb", __FILE__)

#==============================================
# 設定した認証情報に基づき自分のツイートを監視するスクリプト
# 警告を投げ，定刻になったら消去
#==============================================

# authentication
client = Twitter::REST::Client.new do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.access_token = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

# interval for censoring new tweets
CENSOR_INTERVAL_SEC = 600

# interval for praying that tweets may rest in peace
RIP_INTERVAL = 1.day

# hour of rip time
RIP_HOUR = 4

# last watched tweet id
last_watched_tid = 0

# blacklist for tweets
black_list = []

def is_socially_inappropriate(tweet)
  tweet.in_reply_to_screen_name == "null"
end


##### main #####

# initialize rip time
now = Time.now
next_rip_time = Time.new(now.year, now.month, now.day, RIP_HOUR)
next_rip_time += RIP_INTERVAL

while true do
  if Time.now < next_rip_time
    # censoring

    next_lwt = 0
    client.user_timeline.each do |tweet|
      p tweet
      tid = tweet.id
      if tid > last_watched_tid && is_socially_inappropriate(tweet)
        black_list.push(tid)
        alert_msg = "@null このツイートは" + next_rip_time + "に消去されます．"
        client.update(alert_msg, in_reply_to_status_id: tid)
      end
      next_lwt = tid > next_lwt ? tid : next_lwt
    end

    last_watched_tid = next_lwt
  else
    # May socially inappropriate tweets rest in peace...

    ctr = 0
    black_list.each do |tid|
      ctr += 1

      printf("[%d]%d ", ctr, tid)
      begin
        printf("%s", client.destroy_status(tid))
      rescue => e
        printf("FAIL: %s", e.message)
      end
      printf("\n")

      # for avoiding api rate limit
      sleep(1000) if ctr % 150 == 0
    end
    black_list.clear

    # reflesh next rip time
    next_rip_time += RIP_INTERVAL
  end

  sleep(CENSOR_INTERVAL_SEC)
end