# Health_Meter

## 概要
本システムは作業者のラジオ体操の動画を自動的に推定し活動量を算出し，体調診断を自動で行うことで，  
事業者の作業者に対する体調管理を補助し，かつ客観的なデータを元に体調不良の疑いのある作業者を  
事業者に伝えることを目的としています。

---

## ファイル，ディレクトリ一覧

- README.md  
  - このファイル
- analysis/  
  - 本システムで利用する手法のデモプログラム
- app/  
  - RailsのMVCに関する各種ファイル
- bin/  
  - Rails標準の実行ファイルなど
- config/  
  - Railsアプリケーションの各種設定ファイル
- db/  
  - データベース関連ファイル
- lib/  
  - 自作ライブラリ・モジュールなど
- model/  
  - アプリケーション独自のモデル関連ファイル
- log/  
  - ログファイル
- public/  
  - 公開用静的ファイル(利用する動画データ)
- storage/  
  - 分析結果やアップロードデータの保存用ディレクトリ
- test/  
  - テストコード関連
- tmp/  
  - 一時ファイル関連
- vendor/  
  - 外部ライブラリなど
- Gemfile  
  - Railsアプリで使用するgemの管理ファイル
- yolov8n.pt  
  - 本システムで利用するモデルデータ

---

## 使用方法
 1. リポジトリをクローン
      ```bash
      git clone https://github.com/KentaYoshioka/Health_Meter.git
      ```
 2. 依存関係をインストール  
      ```bash
      bundle install
      ```
 3. データベースを作成・マイグレーションを実行
      ```bash
      rails db:create
      rails db:migrate
      ```
 4. Railsサーバを起動する．
      ```bash
      rails s
      ```
 5. ブラウザで [http://localhost:3000](http://localhost:3000) にアクセスする．

---

## 環境構築
1. **Ruby / Rails のインストール**  
   - Rubyのインストール
   - Railsのインストール
     ```bash
     gem install rails
     ```
   - `bundle install` を実行し、Gemfile で指定されたライブラリをインストール

2. **Python環境の構築 (分析用)**  
   - 必要ライブラリをインストール（`analysis/` 配下の `requirements.txt` 等を参照）

---

## 実行環境

- **Ruby / Rails**: Ruby 3.1.2 / Rails 7.0.8.6
- **Python**: 3.11.3  
- **DBサーバ**: SQLite 
