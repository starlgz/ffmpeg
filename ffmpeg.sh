#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================================#
#   System Required: CentOS7 X86_64                               #
#   Description: FFmpeg Stream Media Server                       #
#   Author: LALA                                    #
#   Website: https://www.lala.im                                  #
#=================================================================#

# 颜色选择
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
font="\033[0m"

# 日志文件
log_file="/var/log/ffmpeg_stream.log"

# 错误处理函数
error_exit() {
    echo -e "${red}Error: $1${font}"
    echo -e "${red}Exiting...${font}"
    exit 1
}

# 安装FFmpeg
ffmpeg_install(){
    read -p "你的机器内是否已经安装过FFmpeg4.x?安装FFmpeg才能正常推流,是否现在安装FFmpeg?(yes/no):" Choose
    if [ "$Choose" = "yes" ]; then
        yum -y install wget || error_exit "Failed to install wget."
        wget --no-check-certificate https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.0.3-64bit-static.tar.xz || error_exit "Failed to download FFmpeg."
        tar -xJf ffmpeg-4.0.3-64bit-static.tar.xz
        cd ffmpeg-4.0.3-64bit-static
        mv ffmpeg /usr/bin && mv ffprobe /usr/bin && mv qt-faststart /usr/bin && mv ffmpeg-10bit /usr/bin
        echo -e "${green}FFmpeg installation completed.${font}"
    elif [ "$Choose" = "no" ]; then
        echo -e "${yellow}你选择不安装FFmpeg，请确定你的机器内已经自行安装过FFmpeg，否则程序无法正常工作！${font}"
        sleep 2
    else
        error_exit "Invalid choice. Please enter 'yes' or 'no'."
    fi
}

# 开始推流
start_streaming(){
    read -p "输入你的推流地址和推流码(rtmp协议):" rtmp

    # 判断用户输入的地址是否合法
    if [[ "$rtmp" =~ "rtmp://" ]]; then
        echo -e "${green}推流地址输入正确，程序将进行下一步操作.${font}"
        sleep 2
    else
        error_exit "你输入的地址不合法，请重新运行程序并输入！"
    fi 

    # 定义视频存放目录
    read -p "输入你的视频存放目录 (格式仅支持mp4，并且要绝对路径，例如/opt/video):" folder

    # 设置最大线程数
    max_threads=10
    read -p "请输入线程数 (1-$max_threads，默认为1):" threads
    threads=${threads:-1}

    if (( threads < 1 || threads > max_threads )); then
        error_exit "线程数超出有效范围 (1-$max_threads)"
    fi

    # 判断是否需要添加水印
    read -p "是否需要为视频添加水印？水印位置默认在右上方，需要较好CPU支持(yes/no):" watermark
    if [ "$watermark" = "yes" ]; then
        read -p "输入你的水印图片存放绝对路径, 例如/opt/image/watermark.jpg (格式支持jpg/png/bmp):" image
        echo -e "${yellow}添加水印完成，程序将开始推流.${font}"
        # 循环
        while true; do
            cd "$folder" || error_exit "Folder not found: $folder"
            for video in *.mp4; do
                ffmpeg -re -i "$video" -i "$image" -filter_complex overlay=W-w-5:5 -c:v libx264 -c:a aac -b:a 192k -tune zerolatency -preset ultrafast -threads "$threads" -strict -2 -f flv "$rtmp" >> "$log_file" 2>&1
            done
        done
    elif [ "$watermark" = "no" ]; then
        echo -e "${yellow}你选择不添加水印，程序将开始推流.${font}"
        # 循环
        while true; do
            cd "$folder" || error_exit "Folder not found: $folder"
            for video in *.mp4; do
                ffmpeg -re -i "$video" -c:v copy -c:a aac -b:a 192k -tune zerolatency -preset ultrafast -threads "$threads" -strict -2 -f flv "$rtmp" >> "$log_file" 2>&1
            done
        done
    else
        error_exit "Invalid choice. Please enter 'yes' or 'no'."
    fi
}

# 停止推流
stop_streaming(){
    screen -S stream -X quit
    killall ffmpeg
}

# 开始菜单设置
echo -e "${yellow}CentOS7 X86_64 FFmpeg无人值守循环推流 For LALA.IM${font}"
echo -e "${red}请确定此脚本目前是在screen窗口内运行的！${font}"
echo -e "${green}1.安装FFmpeg (机器要安装FFmpeg才能正常推流)${font}"
echo -e "${green}2.开始无人值守循环推流${font}"
echo -e "${green}3.停止推流${font}"

start_menu(){
    read -p "请输入数字(1-3)，选择你要进行的操作:" num
    case "$num" in
        1)
        ffmpeg_install
        ;;
        2)
        start_streaming
        ;;
        3)
        stop_streaming
        ;;
        *)
        echo -e "${red}请输入正确的数字 (1-3)${font}"
        ;;
    esac
}

# 运行开始菜单
start_menu
