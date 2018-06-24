class OperateSpreadsheet
  def self.session
    credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: Rails.application.credentials.spreadsheet_api[:client_id],
      client_secret: Rails.application.credentials.spreadsheet_api[:client_secret],
      scope: [
        'https://www.googleapis.com/auth/drive',
        'https://spreadsheets.google.com/feeds/',
      ],
      refresh_token: Rails.application.credentials.spreadsheet_api[:refresh_token],
    )
    # @session = GoogleDrive::Session.from_credentials(credentials)
    GoogleDrive::Session.from_credentials(credentials)
  end

  def self.debug
    # Tweet.new.final_valid_vote_tweets.each do
    spreadsheet_uri = Rails.application.credentials.spreadsheet_uri
    spreadsheet = session.spreadsheet_by_url(spreadsheet_uri)
    worksheet_name = 'マスターデータ'
    worksheet = spreadsheet.worksheet_by_title(worksheet_name)

    tweet_text_column_index = 2 # B列
    uri_column_index = 15 # O列
    tweet_id_index = 17 # Q列
    tweeted_at_index = 18 # R列

    tweets_ascending = Tweet.where(is_retweet: 0).where(tweeted_at: '2018-06-22 21:00:00'.in_time_zone('Tokyo')..'2018-06-24 09:00:00'.in_time_zone('Tokyo')).where.not(user_id: 28).order(tweeted_at: :asc)

    tweets_ascending.each.with_index(2) do |tweet, i|
      user_name = User.find(tweet.user_id).name
      screen_name = User.find(tweet.user_id).screen_name

      tweet_content = <<~TEXT
        #{tweet.text}

        #{user_name} (@#{screen_name})
      TEXT
      tweet_content.chomp!

      worksheet[2, tweet_text_column_index] = tweet_content
      worksheet[2, uri_column_index] = %Q(=HYPERLINK("#{tweet.uri}", 'リンク'))
      worksheet[2, tweet_id_index] = tweet.id
      worksheet[2, tweeted_at_index] = tweet.tweeted_at

      break if i > 10
    end

    # worksheet.save

    # target_tweets = User.joins(:tweets).joins(:search_words).includes(:tweets).includes(:search_words).where(tweets: { id: 1006680791961628673 })
    # users = User.joins(:tweets).includes(:tweets).where(users: { screen_name: 'gensosenkyo' })
    # users = users.order('tweets.tweeted_at DESC')

    # users.each do |user|
    #   user.tweets.each.with_index(2) do |tweet, i|
    #     worksheet[i, tweet_text_column_index] = tweet.text
    #     worksheet[i, tweet_account_column_index] = user.screen_name
    #     worksheet[i, tweeted_at_column_index] = tweet.tweeted_at
    #     worksheet[i, tweet_uri_column_index] = %Q(=HYPERLINK("#{tweet.uri}","ツイートへのリンク"))
    #     break if i > 100
    #   end
    # end
  end
end
