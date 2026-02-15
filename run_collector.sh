#!/bin/bash
BASE_DIR="/home/hiropi4/raas-platform/dashboard/public/screenshots"
mkdir -p "$BASE_DIR"

echo "[*] RaaS Collector RESTARTED. Monitoring 3 Android devices..."

while true; do
    # Android 1 (100.104.203.40) - グルメ部隊
    # ポートが37711か確認しつつ取得
    adb -s 100.104.203.40:37711 exec-out screencap -p > "$BASE_DIR/android1.png" 2>/dev/null
    
    # Android 2 (100.86.154.59) - メイン/2台目
    adb -s 100.86.154.59:38843 exec-out screencap -p > "$BASE_DIR/android2.png" 2>/dev/null

    # Android 3 (USB接続 9ACAY1CX2C)
    adb -s 9ACAY1CX2C exec-out screencap -p > "$BASE_DIR/android3.png" 2>/dev/null

    sleep 2
done
