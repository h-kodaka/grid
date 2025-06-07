#!/bin/bash

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ログ出力関数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# エラーハンドリング
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'if [ $? -ne 0 ]; then log_error "コマンドが失敗しました: $last_command"; exit 1; fi' EXIT

# 環境変数ファイルの設定
setup_env() {
    log_info "環境変数ファイルを設定中..."
    if [ ! -f "src/.env.example" ]; then
        log_error ".env.exampleファイルが見つかりません"
        exit 1
    fi
    cp src/.env.example src/.env
    log_info "環境変数ファイルの設定が完了しました"
}

# Docker環境の構築
setup_docker() {
    log_info "Docker環境を構築中..."
    docker compose up -d --build
    log_info "Docker環境の構築が完了しました"
}

# アプリケーションのセットアップ
setup_app() {
    log_info "アプリケーションのセットアップを開始..."
    
    log_info "Composerパッケージをインストール中..."
    docker compose exec app composer install
    
    log_info "アプリケーションキーを生成中..."
    docker compose exec app php artisan key:generate
    
    log_info "データベースをマイグレーション中..."
    docker compose exec app php artisan migrate:fresh
    
    log_info "シーダーを実行中..."
    docker compose exec app php artisan db:seed
    
    log_info "npmパッケージをインストール中..."
    docker compose exec app npm install
    
    log_info "アプリケーションのセットアップが完了しました"
}

# メイン処理
main() {
    log_info "環境構築を開始します..."
    
    setup_env
    setup_docker
    setup_app
    
    log_info "Viteのホットリロードをバックグラウンドで開始中..."
    docker compose exec -d app npm run dev -- --host 0.0.0.0
    
    log_info "環境構築が完了しました"
    log_info "アプリケーションは以下のURLで起動しています"
    echo -e "${BLUE}http://localhost:8000${NC}"
}

# スクリプトの実行
main
