#!/bin/bash
# RaaS Dashboard Data Collector (High Frequency)
# 各端末からスクリーンショットを取得してダッシュボードを更新する

BASE_DIR="/home/hiropi4/.openclaw/workspace-dev-partner/projects/raas/dashboard/public/screenshots"
mkdir -p "$BASE_DIR"

# ループで高速更新を試みる (3秒おき)
for i in {1..10}
do
    # iPhone 151 (AutoTouch API経由)
    (curl -s "http://100.126.108.117:8080/control/start_playing?path=oneshot_screenshot.lua" > /dev/null && \
     sleep 1 && \
     scp -q mobile@100.126.108.117:/var/mobile/at_screen.png "$BASE_DIR/iphone151.png") &
    
    # Android 1 (ADB) - Port updated to 37743
    adb -s 100.104.203.40:37743 shell screencap -p /sdcard/screen.png && adb -s 100.104.203.40:37743 pull /sdcard/screen.png "$BASE_DIR/android1.png" &

    # Android 2 (ADB) - Port 41469
    adb -s 100.86.154.59:41469 shell screencap -p /sdcard/screen.png && adb -s 100.86.154.59:41469 pull /sdcard/screen.png "$BASE_DIR/android2.png" &
    
    wait
    sleep 3
done
