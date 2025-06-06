FROM php:8.3-fpm

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm

# PHPの拡張機能をインストール
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Composerのインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 作業ディレクトリの設定
WORKDIR /var/www/html

# アプリケーションのファイルをコピー
COPY . /var/www/html

# 権限の設定
RUN chown -R www-data:www-data /var/www/html

# Node.jsのバージョンを最新に更新
RUN npm install -g n && n latest

# 開発用のポートを公開
EXPOSE 9000 