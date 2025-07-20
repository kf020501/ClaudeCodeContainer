# Dockerfile
FROM ubuntu:22.04

# Node.js（LTS: 20.x）と必要なツールをインストール
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
      openjdk-11-jre-headless \
      wget \
      graphviz \
      fonts-noto-cjk \
      locales && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends \
      nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 日本語ロケールとエンコーディングを設定
RUN locale-gen ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8
ENV JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

# 非rootユーザーを作成・切り替え、作業ディレクトリを設定
RUN useradd -m -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER user
WORKDIR /home/user/work

# PlantUMLをインストール
RUN mkdir -p /home/user/plantuml && \
    wget -O /home/user/plantuml/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2024.5/plantuml-1.2024.5.jar

# .claudeを作成
RUN mkdir -p /home/user/.claude

# デフォルトで claude コマンドを実行
ENTRYPOINT ["claude"]
