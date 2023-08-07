#!/bin/bash

install_screen() {
    if ! command -v screen &> /dev/null; then
        echo "Screen未安装，正在安装..."
        sudo apt-get update
        sudo apt-get install -y screen
    fi
}

show_menu() {
    clear
    echo "=== GNU Screen 功能菜单 ==="
    echo "1. 创建新会话"
    echo "2. 查看会话列表"
    echo "3. 切换到会话"
    echo "4. 分割窗口"
    echo "5. 暂停/恢复会话"
    echo "6. 滚动窗口内容"
    echo "7. 重命名窗口"
    echo "8. 后台运行会话"
    echo "9. 共享会话"
    echo "10. 编辑Screen配置文件"
    echo "11. 显示帮助"
    echo "12. 显示Screen版本"
    echo "13. 关闭当前会话"
    echo "14. 关闭所有会话"
    echo "15. 切换到下一个窗口"
    echo "16. 切换到上一个窗口"
    echo "17. 关闭当前窗口"
    echo "18. 重置窗口计数"
    echo "19. 创建新窗口并切换"
    echo "20. 调整窗口大小"
    echo "21. 保存当前布局"
    echo "22. 加载已保存布局"
    echo "23. 将窗口内容导出到文件"
    echo "24. 从文件导入窗口内容"
    echo "25. 停止所有会话"
    echo "0. 退出"
}

create_new_session() {
    echo "请输入新会话的名称："
    read session_name
    screen -S "$session_name"
}

list_sessions() {
    screen -ls
}

switch_to_session() {
    echo "请输入要切换的会话名称："
    read session_name
    screen -r "$session_name"
}

split_window() {
    screen -S "$STY" -X split
}

toggle_pause_resume() {
    screen -S "$STY" -X eval "pause"
}

scroll_window() {
    screen -S "$STY" -X eval "scrollback 1000"
}

rename_window() {
    echo "请输入要重命名的窗口号："
    read window_num
    echo "请输入新的窗口名称："
    read window_name
    screen -S "$STY" -X eval "number $window_num rename $window_name"
}

background_run() {
    screen -S "$STY" -X detach
}

share_session() {
    echo "请输入要共享的会话名称："
    read session_name
    screen -S "$session_name" -X multiuser on
    screen -S "$session_name" -X acladd "$(whoami)"
}

edit_config_file() {
    vim ~/.screenrc
}

show_help() {
    echo "GNU Screen 功能菜单帮助："
    echo "在屏幕菜单中选择相应的功能编号，然后按Enter键执行该功能。"
    echo "使用Ctrl+a作为默认前缀键，结合其他键实现快速执行Screen的各种命令。"
    echo "要退出屏幕会话，请选择0并按Enter键。"
}

show_version() {
    screen -v
}

close_current_session() {
    screen -X quit
}

close_all_sessions() {
    screen -ls | grep -oP '^\d+\.[^[:space:]]+' | awk '{print $1}' | xargs -I {} screen -S {} -X quit
}

switch_to_next_window() {
    screen -X select next
}

switch_to_prev_window() {
    screen -X select prev
}

close_current_window() {
    screen -X kill
}

reset_window_count() {
    screen -X reset
}

create_new_window() {
    screen -X screen
}

resize_window() {
    echo "请输入新窗口的行数："
    read rows
    echo "请输入新窗口的列数："
    read cols
    screen -X resize "$rows" "$cols"
}

save_layout() {
    screen -X layout save
}

load_layout() {
    screen -X layout load
}

export_window_content() {
    echo "请输入要导出内容的窗口号："
    read window_num
    echo "请输入导出内容的目标文件："
    read file_name
    screen -S "$STY" -X hardcopy "$file_name" "$window_num"
}

import_window_content() {
    echo "请输入要导入内容的窗口号："
    read window_num
    echo "请输入包含要导入内容的文件："
    read file_name
    screen -S "$STY" -X readbuf "$window_num" "$file_name"
}

stop_all_sessions() {
    screen -ls | grep -oP '^\d+\.[^[:space:]]+' | awk '{print $1}' | xargs -I {} screen -S {} -X quit
}

main() {
    install_screen
    while true; do
        show_menu
        read -p "请输入选项数字： " choice

        case $choice in
            1) create_new_session ;;
            2) list_sessions ;;
            3) switch_to_session ;;
            4) split_window ;;
            5) toggle_pause_resume ;;
            6) scroll_window ;;
            7) rename_window ;;
            8) background_run ;;
            9) share_session ;;
            10) edit_config_file ;;
            11) show_help ;;
            12) show_version ;;
            13) close_current_session ;;
            14) close_all_sessions ;;
            15) switch_to_next_window ;;
            16) switch_to_prev_window ;;
            17) close_current_window ;;
            18) reset_window_count ;;
            19) create_new_window ;;
            20) resize_window ;;
            21) save_layout ;;
            22) load_layout ;;
            23) export_window_content ;;
            24) import_window_content ;;
            25) stop_all_sessions ;;
            0) echo "谢谢使用，再见！" && break ;;
            *) echo "无效选项，请重新输入。" ;;
        esac

        read -p "按下 Enter 键继续..." enter_key
    done
}

main
