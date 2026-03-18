#!/bin/bash

# =========================================================
# A Ramadi.sh Script By Ramadi
# Version     : v2026-03-18 (With I/O Warning System)
# =========================================================

# Colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' 

clear
echo -e "${CYAN}----------------------- A Ramadi.sh Script By Ramadi -----------------------${NC}"

# 1. Dependency Check
if ! command -v speedtest-cli &> /dev/null || ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}Installing dependencies...${NC}"
    sudo apt update && sudo apt install speedtest-cli curl -y > /dev/null 2>&1
fi

# 2. System Info gathering
CPU_MODEL=$(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^[ \t]*//')
CPU_CORES=$(grep -c 'processor' /proc/cpuinfo)
CPU_FREQ=$(grep 'cpu MHz' /proc/cpuinfo | head -1 | awk '{print $4}')
RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
RAM_USED=$(free -h | awk '/Mem:/ {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
UPTIME=$(uptime -p | sed 's/up //')
OS=$(hostnamectl | grep "Operating System" | cut -d':' -f2 | sed 's/^[ \t]*//')
ARCH=$(uname -m)
KERNEL=$(uname -r)
TCP_CTRL=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
VIRT=$(systemd-detect-virt)
ORG=$(curl -s https://ipinfo.io/org)
LOC=$(curl -s https://ipinfo.io/city)
REG=$(curl -s https://ipinfo.io/region)

echo -e "${YELLOW}CPU Model            :${NC} $CPU_MODEL"
echo -e "${YELLOW}CPU Cores            :${NC} $CPU_CORES @ $CPU_FREQ MHz"
echo -e "${YELLOW}Total Disk           :${NC} $DISK_TOTAL ($DISK_USED Used)"
echo -e "${YELLOW}Total RAM            :${NC} $RAM_TOTAL ($RAM_USED Used)"
echo -e "${YELLOW}System Uptime        :${NC} $UPTIME"
echo -e "${YELLOW}OS                   :${NC} $OS"
echo -e "${YELLOW}Arch                 :${NC} $ARCH"
echo -e "${YELLOW}Kernel               :${NC} $KERNEL"
echo -e "${YELLOW}TCP Congestion Ctrl  :${NC} $TCP_CTRL"
echo -e "${YELLOW}Virtualization       :${NC} $VIRT"
echo -e "${YELLOW}Organization         :${NC} $ORG"
echo -e "${YELLOW}Location             :${NC} $LOC"
echo -e "${YELLOW}Region               :${NC} $REG"
echo -e "${CYAN}----------------------------------------------------------------------------${NC}"

# Fungsi untuk cek warna I/O (Threshold: 200 MB/s)
check_io_color() {
    local speed_val=$(echo $1 | awk '{print $1}')
    local unit=$(echo $1 | awk '{print $2}')
    
    # Jika unitnya MB/s dan angkanya di bawah 200, atau jika unitnya KB/s (pasti lambat)
    if [[ "$unit" == "MB/s" ]]; then
        if (( $(echo "$speed_val < 200" | bc -l) )); then
            echo -e "${RED}$1 (Slow)${NC}"
        else
            echo -e "${GREEN}$1${NC}"
        fi
    elif [[ "$unit" == "GB/s" ]]; then
        echo -e "${GREEN}$1 (Fast)${NC}"
    else
        echo -e "${RED}$1 (Very Slow)${NC}"
    fi
}

# 3. I/O Speed Test (Two Runs)
echo -ne "${YELLOW}I/O Speed(1st run)    :${NC} "
io1=$(dd if=/dev/zero of=test_ramadi bs=64k count=16384 conv=fdatasync 2>&1 | awk -F, '/copied/ {print $NF}' | sed 's/^[ \t]*//')
check_io_color "$io1"

echo -ne "${YELLOW}I/O Speed(2nd run)    :${NC} "
io2=$(dd if=/dev/zero of=test_ramadi bs=64k count=16384 conv=fdatasync 2>&1 | awk -F, '/copied/ {print $NF}' | sed 's/^[ \t]*//')
check_io_color "$io2"
rm -f test_ramadi

# 4. Network Speed Test
echo -e "${CYAN}----------------------------------------------------------------------------${NC}"
echo -e "${YELLOW}Node Name             Upload Speed      Download Speed      Latency${NC}"
ST_OUT=$(speedtest-cli --simple)
PING=$(echo "$ST_OUT" | awk '/Ping:/ {print $2 " " $3}')
DOWN=$(echo "$ST_OUT" | awk '/Download:/ {print $2 " " $3}')
UP=$(echo "$ST_OUT" | awk '/Upload:/ {print $2 " " $3}')

printf "${GREEN}%-22s%-18s%-20s%-10s${NC}\n" "Speedtest.net" "$UP" "$DOWN" "$PING"
echo -e "${CYAN}----------------------------------------------------------------------------${NC}"
echo -e "${GREEN}       Benchmark Complete! Regards, Ramadi.             ${NC}"
echo -e "${CYAN}----------------------------------------------------------------------------${NC}"
