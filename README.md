Claude Code Docker Container
================================================================================

AnthropicのClaude Codeをコンテナ化したプロジェクトです。開発環境を汚さずに、Claude Codeをどこでも使用できます。


概要
--------------------------------------------------------------------------------

| 項目                   | 説明                                                              |
| ---------------------- | ----------------------------------------------------------------- |
| **隔離された環境**     | Dockerコンテナ内でClaude Codeを実行                               |
| **柔軟なマウント**     | 任意のディレクトリを作業ディレクトリとしてマウント可能            |
| **設定の永続化**       | `.claude`ディレクトリと`.claude.json`をマウントして設定を完全保持 |
| **Ubuntu 22.04ベース** | 安定した環境でNode.js 20.xを使用                                  |
| **PlantUML対応**       | Java環境とPlantUMLが利用可能、日本語フォント対応                   |


使い方
--------------------------------------------------------------------------------

### Docker操作

| コマンド                           | 説明                                         |
| ---------------------------------- | -------------------------------------------- |
| `make build`                       | Docker イメージをビルド                      |
| `make run`                         | Claude Codeを対話モードで実行（デフォルト）  |
| `make run WORK=/path/to/project`   | 特定のディレクトリを指定して実行             |
| `make shell`                       | コンテナ内でシェルを開く                     |
| `make shell WORK=/path/to/project` | 特定のディレクトリをマウントしてシェルを開く |
| `make clean`                       | イメージを削除                               |


### 初回起動時の設定

初回起動時は以下の設定が必要です：

1. **APIキーの設定**: AnthropicのAPIキーを入力
2. **プロジェクト設定**: 作業ディレクトリやプロジェクト名を設定

設定は自動的に永続化されるため、次回起動時は不要です。


### Claude Codeのスラッシュコマンド（/コマンド）

[Slash commands - Anthropic](https://docs.anthropic.com/en/docs/claude-code/slash-commands)

Claude Codeでは、`/`で始まるコマンドを使用して効率的に作業できます：

| コマンド  | 説明                                   | 使用例                          |
| --------- | -------------------------------------- | ------------------------------- |
| `/search` | プロジェクト内のファイルやコードを検索 | `/search "function login"`      |
| `/edit`   | 特定のファイルを編集モードで開く       | `/edit src/app.js`              |
| `/create` | 新しいファイルを作成                   | `/create components/Button.jsx` |
| `/run`    | コマンドを実行                         | `/run npm test`                 |
| `/tree`   | ディレクトリ構造を表示                 | `/tree src/`                    |
| `/diff`   | ファイルの差分を表示                   | `/diff file1.js file2.js`       |
| `/help`   | ヘルプを表示                           | `/help`                         |
| `/clear`  | 会話履歴をクリア                       | `/clear`                        |


### PlantUMLの使用方法

コンテナ内でPlantUMLを使用できます：

| コマンド例                                                                | 説明                                  |
| ------------------------------------------------------------------------- | ------------------------------------- |
| `java -jar /home/user/plantuml/plantuml.jar diagram.puml`                | PlantUMLファイルをPNG画像に変換       |
| `java -jar /home/user/plantuml/plantuml.jar -tsvg diagram.puml`          | SVG形式で出力                         |
| `java -jar /home/user/plantuml/plantuml.jar -tpng -o ./output *.puml`    | 複数ファイルを指定ディレクトリに出力  |
| `java -jar /home/user/plantuml/plantuml.jar *.puml`                      | 現在のディレクトリの全.pumlファイル処理 |
| `java -jar /home/user/plantuml/plantuml.jar -checkonly diagram.puml`     | 構文チェックのみ実行                  |
| `java -jar /home/user/plantuml/plantuml.jar -version`                    | PlantUMLバージョン確認                |

Claude Codeから `/run` コマンドでPlantUMLを実行することも可能です：
```
/run java -jar /home/user/plantuml/plantuml.jar diagram.puml
```

#### 日本語対応PlantUMLファイルの作成

日本語を含むPlantUMLファイルを作成する場合は、以下のヘッダーを必ず含めてください：

```plantuml
@startuml
!theme plain
skinparam defaultFontName "Noto Sans CJK JP Regular"

title システム構成図
actor ユーザー as user
participant "ウェブアプリ" as webapp
# ... 以下、図の内容 ...

@enduml
```

**動作確認済みサンプル**: `/docs/plantuml_example.md` に日本語対応の構成図サンプルが含まれています

**動作確認済み環境**:
- PlantUML v1.2024.5
- OpenJDK 11 + UTF-8エンコーディング設定
- Graphviz 2.43.0  
- 日本語フォント対応（Noto CJK JP Regular）
- 出力形式: PNG, SVG対応
- 日本語ロケール: ja_JP.UTF-8


設計内容
--------------------------------------------------------------------------------

### ディレクトリ構成

```
.
├── Dockerfile          # コンテナイメージの定義
├── Makefile            # ビルドと実行の自動化
└── README.md           # このファイル
```

### アーキテクチャ

| コンポーネント         | 詳細                                  |
| ---------------------- | ------------------------------------- |
| **ベースイメージ**     | Ubuntu 22.04                          |
| **Node.js**            | LTS版（20.x）                         |
| **Claude Code**        | npmから最新版をグローバルインストール |
| **Java**               | OpenJDK 11（PlantUML用）              |
| **PlantUML**           | v1.2024.5（`/plantuml/plantuml.jar`） |
| **追加ツール**         | Graphviz、日本語フォント              |
| **ユーザー**           | 非rootユーザー（user）、sudo権限付き  |
| **作業ディレクトリ**   | `/home/user/work`                     |
| **エントリーポイント** | `claude`コマンド                      |

### マウント設定

| ホスト           | コンテナ                  | 用途                                       |
| ---------------- | ------------------------- | ------------------------------------------ |
| `~/.claude`      | `/home/user/.claude`      | API認証情報、todos、プロジェクト設定       |
| `~/.claude.json` | `/home/user/.claude.json` | テーマ、オンボーディング状態、ユーザー設定 |
| `$(WORK)`        | `/home/user/work`         | プロジェクトファイル                       |

### 環境変数

| 変数名       | デフォルト値  | 説明                             |
| ------------ | ------------- | -------------------------------- |
| `IMAGE_NAME` | `claude-code` | Docker イメージ名                |
| `IMAGE_TAG`  | `latest`      | イメージタグ                     |
| `CLAUDE_DIR` | `~/.claude`   | 設定ディレクトリパス             |
| `WORK`       | -             | 実行時に指定する対象ディレクトリ |


要件
--------------------------------------------------------------------------------

| 項目                   | 説明                    |
| ---------------------- | ----------------------- |
| **Docker**             | コンテナ実行環境        |
| **Make**               | ビルドツール            |
| **AnthropicのAPIキー** | Claude Codeの利用に必要 |
