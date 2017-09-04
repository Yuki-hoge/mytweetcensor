# 動作確認済環境
- ruby (2.3.1)
  - activesupport (5.1.3)
  - twitter (6.1.0)

# mytweetcensor.rb
一定時間ごとに自分のつぶやきを取得し，社会的に不適切なツイートをチェック，定刻(デフォルトでは朝4時，1日ごと)に消去

社会的に不適切なツイート: デフォルトでは@nullへのリプライとしている．（つまり現段階では，ツイート時に不適切であるという認識が必要）
## つかいかた
### `credential_twitter.rb`を作成
以下の形式のファイル`credential_twitter.rb`をスクリプトと同じディレクトリに作成．各値はTwitter Application Managementでアプリを作って取得．
```
CONSUMER_KEY = "YOUR CONSUMER KEY"
CONSUMER_SECRET = "YOUR CONSUMER SECRET"
ACCESS_TOKEN = "YOUR ACCESS TOKEN"
ACCESS_TOKEN_SECRET = "YOUR ACCESS TOKEN SECRET"
```
### RubyGemをインストール(入ってれば省略)
```
gem install twitter
gem install activesupport
```
### 実行
```
ruby mytweetcensor.rb
```
### バックグラウンドでの実行
```
nohup ruby mytweetcensor.rb >out.log 2>err.log </dev/null &
```

# mytweeteraser
MAX\_TWEET\_IDより古いtweet\_idを持つツイートを全て消去する．Twitter公式にリクエストして得る全ツイート履歴の中の`tweets.csv`を使う．
## つかいかた
### `credential_twitter.rb`を作成
略
### RubyGemをインストール(入ってれば省略)
```
gem install twitter
```
### 実行
```
ruby mytweeteraser.rb
```

注: `tweets.csv`と同じディレクトリで実行する．
