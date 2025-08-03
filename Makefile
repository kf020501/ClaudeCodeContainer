# Makefile

# イメージ名とタグ
IMAGE_NAME := claude-code
IMAGE_TAG  := latest
CLAUDE_DIR := ~/.claude
CLAUDE_JSON := ~/.claude.json

# デフォルトのビルドターゲット
.PHONY: all
all: build ## デフォルトビルドターゲット

.PHONY: help
help: ## このヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## プロジェクトディレクトリの作成
	mkdir -p bin src docs tests config scripts logs tmp

.PHONY: build
build: ## Docker イメージをビルド
	@echo "Ensure ~/.claude exists…"
	@mkdir -p $(CLAUDE_DIR)
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

# claude コマンドを対話モードで実行
# 対象ディレクトリを指定する場合:
#   make run /path/to/target
.PHONY: run
run: ## Claude Codeを対話モードで実行（meke run /path/to/project）
	docker run -v $(CLAUDE_DIR):/home/user/.claude -v ~/.claude.json:/home/user/.claude.json -v $(word 2, $(MAKECMDGOALS)):/home/user/work -it --rm $(IMAGE_NAME):$(IMAGE_TAG)

# コンテナに入ってシェルを開きたいとき
.PHONY: shell
shell: ## コンテナのシェルを開く（meke shell /path/to/project）
	docker run -v $(CLAUDE_DIR):/home/user/.claude -v ~/.claude.json:/home/user/.claude.json -v $(word 2, $(MAKECMDGOALS)):/home/user/work -it --rm --entrypoint /bin/bash $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: clean
clean: ## Docker イメージの削除
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
