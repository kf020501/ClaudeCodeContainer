# Makefile

# イメージ名とタグ
IMAGE_NAME := claude-code
IMAGE_TAG  := latest
CLAUDE_DIR := ~/.claude
CLAUDE_JSON := ~/.claude.json

# デフォルトのビルドターゲット
.PHONY: all
all: build

.PHONY: setup
setup: ## プロジェクトディレクトリの作成
	mkdir -p bin src docs tests config scripts logs tmp

# Docker イメージをビルド
build:
	@echo "Ensure ~/.claude exists…"
	@mkdir -p $(CLAUDE_DIR)
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

# claude コマンドを対話モードで実行
# 対象ディレクトリを指定する場合は WORK にセットできます:
#   make run WORK=/path/to/target
run:
ifeq ($(WORK),)
	@echo "Error: WORK variable is not set. Please specify the directory to mount:"
	@echo "  make run WORK=/path/to/target"
	@exit 1
endif
	docker run -v $(CLAUDE_DIR):/home/user/.claude -v ~/.claude.json:/home/user/.claude.json -v $(WORK):/home/user/work -it --rm $(IMAGE_NAME):$(IMAGE_TAG)

# コンテナに入ってシェルを開きたいとき
.PHONY: shell
shell:
ifeq ($(WORK),)
	@echo "Error: WORK variable is not set. Please specify the directory to mount:"
	@echo "  make shell WORK=/path/to/target"
	@exit 1
endif
	docker run -v $(CLAUDE_DIR):/home/user/.claude -v ~/.claude.json:/home/user/.claude.json -v $(WORK):/home/user/work -it --rm --entrypoint /bin/bash $(IMAGE_NAME):$(IMAGE_TAG)

# イメージの削除
clean:
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
