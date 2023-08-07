#!/bin/bash

# 检查是否安装了snap
if ! command -v snap &> /dev/null; then
    echo "正在安装snap包管理器..."
    sudo apt update
    sudo apt install -y snapd
fi

# 安装FFmpeg
sudo snap install ffmpeg

# 打印安装信息
echo "FFmpeg安装完成！"
ffmpeg -version
