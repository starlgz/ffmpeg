#!/bin/bash

# 定义要安装的FFmpeg版本和目录
FFMPEG_VERSION="4.4"
INSTALL_DIR="/usr/local"

# 检查是否安装了curl
if ! command -v curl &> /dev/null; then
    echo "请先安装curl工具."
    exit 1
fi

# 检查是否具有管理员权限
if [ "$(id -u)" -ne 0 ]; then
    echo "需要管理员权限来安装FFmpeg."
    exit 1
fi

# 下载并安装FFmpeg
echo "正在下载并安装FFmpeg v$FFMPEG_VERSION..."
curl -sSL "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz" -o ffmpeg.tar.xz
tar -xf ffmpeg.tar.xz
cd "ffmpeg-$FFMPEG_VERSION-amd64-static"
cp ffmpeg ffprobe "$INSTALL_DIR/bin/"

# 清理临时文件
cd ..
rm -rf "ffmpeg-$FFMPEG_VERSION-amd64-static" ffmpeg.tar.xz

# 配置环境变量
echo 'export PATH="$PATH:'"$INSTALL_DIR"'/bin"' >> ~/.bashrc
source ~/.bashrc

echo "FFmpeg v$FFMPEG_VERSION 安装完成！"
ffmpeg -version
