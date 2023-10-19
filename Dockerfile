# Dockerコンテナのベースイメージを指定します。
# 元のWebアプリの.ruby-version、Gemfileを参考にします。
FROM ruby:3.2.2
# コンテナ内でLinuxパッケージの更新と必要なパッケージのインストールを行います。
# apt-get コマンドを使用して、ビルドツール、PostgreSQLクライアント、Node.js、libpq-devなどがインストールされます。
# -y オプションは、パッケージのインストール時に確認プロンプトを無効にしています。
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client \
    yarn
# この行は、作業ディレクトリを /rails-docker に設定します。後続のコマンドはこのディレクトリ内で実行されます。
WORKDIR /rails-docker
#ローカルの Gemfile と Gemfile.lock ファイルをコンテナ内の /rails-docker/ ディレクトリにコピーします。
COPY Gemfile Gemfile.lock /rails-docker/
# Bundlerを使用してGemfileに記載されているGem依存関係をインストールします。
RUN bundle install
