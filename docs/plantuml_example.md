# PlantUML サンプル図

## ウェブアプリケーション構成図

このサンプルでは、典型的なウェブアプリケーションの構成要素と関連性を示しています。

### PlantUMLソースコード

[diagram_sample.puml](./diagram_sample.puml)

```plantuml
@startuml
!theme plain
skinparam defaultFontName "Noto Sans CJK JP Regular"

title ウェブアプリケーション構成図

package "フロントエンド" {
  [ブラウザ] as browser
  [React App] as react
}

package "バックエンド" {
  [APIゲートウェイ] as api
  [認証サービス] as auth
  [ビジネスロジック] as business
}

package "データ層" {
  database "PostgreSQL" as db
  database "Redis" as cache
}

browser -> react : ユーザー操作
react -> api : API呼び出し
api -> auth : 認証確認
api -> business : 業務処理
business -> db : データ操作
business -> cache : キャッシュ

note right of auth
  JWT トークンによる
  認証システム
end note

note bottom of db
  メインデータベース
  ユーザー情報・業務データ
end note

@enduml
```

### 生成された図

![ウェブアプリケーション構成図](./diagram_sample.png)

### 図の説明

この構成図では以下の要素を表現しています：

- **フロントエンド**: ユーザーインターフェース部分
  - ブラウザ: エンドユーザーが使用するクライアント
  - React App: シングルページアプリケーション

- **バックエンド**: サーバーサイドの処理部分
  - APIゲートウェイ: フロントエンドからのリクエストを受付
  - 認証サービス: ユーザー認証とJWTトークン管理
  - ビジネスロジック: 業務処理の中核

- **データ層**: データ保存・管理部分
  - PostgreSQL: メインデータベース
  - Redis: キャッシュシステム

### 使用方法

PlantUMLファイルから画像を生成するには：

```bash
java -jar /home/user/plantuml/plantuml.jar diagram_sample.puml
```

この例は日本語フォント設定とUTF-8エンコーディングの動作確認も兼ねています。