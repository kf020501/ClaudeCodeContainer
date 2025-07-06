# Dockerfile
FROM ubuntu:22.04

# Node.js（LTS: 20.x）と必要なツールをインストール
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends \
      nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 非rootユーザーを作成・切り替え、作業ディレクトリを設定
RUN useradd -m -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER user
WORKDIR /home/user/work

# .claudeを作成
RUN mkdir -p /home/user/.claude

# デフォルトで claude コマンドを実行
ENTRYPOINT ["claude"]
