# 手順
-  postgres:12を使用

### 1.git cloneをする
```
git clone アプリのリポジトリ
```

```
cd rails-docker
code .
```

dockerを作成するためのブランチを作成する
```
git checkout -b docker
```

### 2. Dockerfileとdocker-compose.ymlを作成する
Dockerfile
```Dockerfile
FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client \
  yarn
WORKDIR /rails-docker
COPY Gemfile Gemfile.lock /rails-docker/
RUN bundle install
CMD rails s -p 3000 -b '0.0.0.0'
```
Docker-compose.yml
```Docker-compose.yml
version: "3.9"

volumes:
  db-data:

services:
  web:
    build: .
    ports:
      - '3000:3000'
    volumes:
      - '.:/rails-docker'
    environment:
      - 'DATABASE_PASSWORD=postgres'
    tty: true
    stdin_open: true
    depends_on:
      - db
    links:
      - db

  db:
    image: postgres:12
    volumes:
      - 'db-data:/var/lib/postgresql/data'
    environment:
      - 'POSTGRES_USER=postgres'
      - 'POSTGRES_PASSWORD=postgres'
```

### 3.config/database.yml修正
host,user,portを追記
```database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  user: postgres
  port: 5432
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

### 4.docker立ち上げる
```
docker-compose build
```
```
docker-compose run web rails db:create db:migrate
```
```
docker-compose up -d
```
bashに入る
```
docker-compose exec web bash
```
```
rails db:create
rails db:migrate
rails s -b 0.0.0.0
```

Qiita記事
https://qiita.com/kum32/items/4d8c4abe8101cadcf168#%E3%81%AF%E3%81%98%E3%82%81%E3%81%AB

