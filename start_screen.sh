#!/bin/bash

# 作者名字
author_name="满天繁星"

# 检查是否已安装 screen，如果没有安装则进行安装
if ! command -v screen &> /dev/null; then
    echo "正在安装 screen..."
    sudo apt-get update
    sudo apt-get install -y screen
fi

start_screen_session() {
    # 交互式地询问目标目录
    read -p "请输入目标目录（绝对路径）：" target_directory

    # 检查目录是否存在
    if [ ! -d "$target_directory" ]; then
        echo "目录 '$target_directory' 不存在，请输入有效的绝对路径。"
        start_screen_session
    else
        # 进入目标目录
        cd "$target_directory"

        # 交互式地询问会话名称
        read -p "请输入要创建的会话名称：" session_name

        # 检查会话是否已存在
        if screen -ls | grep -q "\.$session_name\t"; then
            echo "会话 '$session_name' 已存在，请选择其他名称。"
            start_screen_session
        else
            # 使用 screen 命令启动会话
            screen -S "$session_name"

            # 显示提示信息
            echo "会话 '$session_name' 已启动。您可以在会话中运行您的命令。"
        fi
    fi
}

list_screen_sessions() {
    # 查看已存在的会话列表
    screen -ls
}

# 显示菜单选项
while true; do
    echo "======= Screen 一键使用菜单 ======="
    echo "作者: $author_name"
    echo "1. 查看已存在的会话"
    echo "2. 启动一个新的会话"
    echo "3. 退出脚本"
    echo "==================================="
    read -p "请输入数字（1-3），选择您要进行的操作：" choice

    case "$choice" in
        1)
            list_screen_sessions
            ;;
        2)
            start_screen_session
            ;;
        3)
            echo "已退出脚本。"
            exit 0
            ;;
        *)
            echo "请输入有效的数字（1-3）。"
            ;;
    esac
done
