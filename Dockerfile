# ベースイメージ
FROM ruby:3.2.2

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  curl \
  wget

# Bundlerを最新バージョンに更新する
RUN gem install bundler -v 2.5.20

# Node.jsとYarnのセットアップ
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn

# 作業ディレクトリ設定
WORKDIR /app

# Gemfileをコピーし、依存関係をインストール
COPY Gemfile* /app/
RUN bundle install

# アプリのソースコードをコピー
COPY . /app

# ポートを開放
EXPOSE 3000

# サーバー起動コマンド
CMD ["rails", "server", "-b", "0.0.0.0"]