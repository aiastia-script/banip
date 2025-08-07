#!/bin/bash
# 强化版IP黑名单脚本（ipset方案）

# ================ 配置区域 ================
IP_LIST="/etc/fail2ban/ip.blacklist"
IPSET_NAME="fail2ban_bl"
HASH_TYPE="hash:net"
IPTABLES_CHAIN="INPUT"
# ========================================

# 颜色定义
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
NC='\033[0m'

# 检查root权限
[[ "$(id -u)" != "0" ]] && {
    echo -e "${RED}错误：此脚本需要root权限执行！${NC}"
    echo "请使用 sudo $0"
    exit 1
}

# 检查文件是否存在
[[ ! -f "$IP_LIST" ]] && {
    echo -e "${RED}错误：IP列表文件 $IP_LIST 不存在！${NC}"
    exit 1
}

# 初始化ipset集合
init_ipset() {
    echo -e "${BLUE}初始化ipset集合...${NC}"
    
    if ! ipset list -n | grep -q "^${IPSET_NAME}$"; then
        ipset create ${IPSET_NAME} ${HASH_TYPE} maxelem 1000000 timeout 0
        echo -e "${GREEN}创建新集合: ${IPSET_NAME}${NC}"
    else
        ipset flush ${IPSET_NAME}
        echo -e "${YELLOW}清空现有集合: ${IPSET_NAME}${NC}"
    fi
}

# 配置防火墙规则
setup_firewall() {
    echo -e "${BLUE}配置防火墙规则...${NC}"
    
    if ! iptables -C ${IPTABLES_CHAIN} -m set --match-set ${IPSET_NAME} src -j DROP 2>/dev/null; then
        iptables -I ${IPTABLES_CHAIN} 1 -m set --match-set ${IPSET_NAME} src -j DROP
        echo -e "${GREEN}已添加防火墙规则${NC}"
    fi
}

# 批量导入IP（高性能版）
import_ips() {
    echo -e "${BLUE}开始导入IP地址...${NC}"
    local temp_file=$(mktemp)
    
    # 预处理文件（去注释、去空行、去重、验证格式）
    grep -Ev '^#|^$' "${IP_LIST}" | while read -r ip; do
        if [[ "$ip" =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\/(3[0-2]|[12]?[0-9]))?$ ]]; then
            echo "$ip"
        else
            echo -e "${RED}忽略无效IP: $ip${NC}" >&2
        fi
    done | sort -u > "${temp_file}"
    
    # 批量导入ipset（注意此处EOF必须顶格写！）
    ipset restore -! <<EOF
$(awk '{print "add '${IPSET_NAME}' " $1}' "${temp_file}")
EOF
    
    counter=$(wc -l < "${temp_file}")
    rm -f "${temp_file}"
    
    echo -e "\n${GREEN}导入完成！共处理 ${counter} 个有效IP${NC}"
}

# 持久化配置（多系统兼容）
persist_config() {
    echo -e "${BLUE}保存配置...${NC}"
    
    # 通用保存
    mkdir -p /etc/iptables
    ipset save > /etc/iptables/ipset.rules
    iptables-save > /etc/iptables/rules.v4
    
    # Debian/Ubuntu
    if systemctl is-active --quiet netfilter-persistent; then
        systemctl restart netfilter-persistent
    fi
    
    # CentOS/RHEL
    if command -v firewall-cmd &>/dev/null; then
        firewall-cmd --reload
    fi
    
    echo -e "${GREEN}配置已永久保存${NC}"
}

# 主流程
main() {
    echo -e "\n${BLUE}==== IP黑名单管理工具 ====${NC}"
    echo -e "黑名单文件: ${IP_LIST}"
    echo -e "ipset集合: ${IPSET_NAME}"
    echo -e "--------------------------------"
    
    init_ipset
    setup_firewall
    import_ips
    
    read -p $'\n是否永久保存配置? [y/N] ' -n 1 -r
    [[ $REPLY =~ ^[Yy]$ ]] && persist_config
    
    echo -e "\n${GREEN}当前状态:${NC}"
    ipset list ${IPSET_NAME} | head -n 10
    echo -e "${YELLOW}（显示前10条记录，完整列表请用 ipset list ${IPSET_NAME}）${NC}"
}

main
