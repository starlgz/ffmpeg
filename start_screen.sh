#!/bin/bash

# ANSI颜色代码
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # 恢复默认颜色

install_screen() {
    if ! command -v screen &> /dev/null; then
        echo -e "${YELLOW}Screen未安装，正在安装...${NC}"
        sudo apt-get update
        sudo apt-get install -y screen
    fi
}

show_menu() {
    clear
    echo -e "${GREEN}=== GNU Screen 功能菜单 ===${NC}"
    echo -e "1. 查看会话列表"
    echo -e "2. 创建新会话"
    echo -e "3. 暂停/恢复会话"
    echo -e "4. 停止所有会话"
    echo -e "5. 删除所有会话"
    echo -e "0. 退出脚本"
}

list_sessions() {
    screen -list
}

create_new_session() {
    echo -e "${YELLOW}请输入新会话的名称：${NC}"
    read session_name
    screen -S "$session_name"
}

toggle_pause_resume() {
    screen -S "$STY" -X eval "pause"
}

stop_all_sessions() {
    screen -list | grep -oP '^\s*\d+\.[^[:space:]]+' | awk '{print $1}' | xargs -I {} screen -S {} -X quit
    echo -e "${GREEN}所有会话已停止。${NC}"
}

delete_all_sessions() {
    screen -list | grep -oP '^\s*\d+\.[^[:space:]]+' | awk '{print $1}' | xargs -I {} screen -S {} -X quit
    echo -e "${GREEN}所有会话已删除。${NC}"
}

exit_script() {
    echo -e "${GREEN}谢谢使用，再见！${NC}"
    exit 0
}

main() {
    install_screen
    while true; do
        show_menu
        read -p "请输入选项数字： " choice

        case $choice in
            1) list_sessions ;;
            2) create_new_session ;;
            3) toggle_pause_resume ;;
            4) stop_all_sessions ;;
            5) delete_all_sessions ;;
            0) exit_script ;;
            *) echo -e "${GREEN}无效选项，请重新输入。${NC}" ;;
        esac

        read -p "按下 Enter 键继续..." enter_key
    done
}

echo -e "${GREEN}GNU Screen 菜单脚本 (作者: starlgz)${NC}"
main
