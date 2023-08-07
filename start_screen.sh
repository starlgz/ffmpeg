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
    echo -e "${YELLOW}1. 创建新会话\t\t2. 查看会话列表${NC}"
    echo -e "${YELLOW}3. 切换到会话\t\t4. 分割窗口${NC}"
    echo -e "${YELLOW}5. 暂停/恢复会话\t6. 滚动窗口内容${NC}"
    echo -e "${YELLOW}7. 重命名窗口\t\t8. 后台运行会话${NC}"
    echo -e "${YELLOW}9. 共享会话\t\t10. 编辑Screen配置文件${NC}"
    echo -e "${YELLOW}11. 显示帮助\t\t12. 显示Screen版本${NC}"
    echo -e "${YELLOW}13. 关闭当前会话\t14. 关闭所有会话${NC}"
    echo -e "${YELLOW}15. 切换到下一个窗口\t16. 切换到上一个窗口${NC}"
    echo -e "${YELLOW}17. 关闭当前窗口\t18. 重置窗口计数${NC}"
    echo -e "${YELLOW}19. 创建新窗口并切换\t20. 调整窗口大小${NC}"
    echo -e "${YELLOW}21. 保存当前布局\t22. 加载已保存布局${NC}"
    echo -e "${YELLOW}23. 将窗口内容导出到文件\t24. 从文件导入窗口内容${NC}"
    echo -e "${YELLOW}25. 停止所有会话\t\t0. 退出${NC}"
}

# 以下是原来的功能函数，不再重复列出...

stop_all_sessions() {
    screen -ls | grep -oP '^\d+\.[^[:space:]]+' | awk '{print $1}' | xargs -I {} screen -S {} -X quit
    echo -e "${GREEN}所有会话已停止。${NC}"
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
            0) echo -e "${GREEN}谢谢使用，再见！${NC}" && break ;;
            *) echo -e "${GREEN}无效选项，请重新输入。${NC}" ;;
        esac

        read -p "按下 Enter 键继续..." enter_key
    done
}

main
