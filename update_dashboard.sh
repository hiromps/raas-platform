#!/bin/bash
# RaaS Dashboard Data Collector
# 各端末からスクリーンショットを取得してダッシュボードを更新する

BASE_DIR="/home/hiropi4/.openclaw/workspace-dev-partner/projects/raas/dashboard/public/screenshots"
mkdir -p "$BASE_DIR"

# iPhone 151 (iOS) - AutoTouch APIを使ってスクショ保存
# ※一旦はSSH経由の簡易コマンド
echo "[*] Capturing iPhone 151..."
ssh mobile@100.126.108.117 "screencapture /var/mobile/tmp_screen.png" 2>/dev/null
scp mobile@100.126.108.117:/var/mobile/tmp_screen.png "$BASE_DIR/iphone151.png" 2>/dev/null

# Android 1
echo "[*] Capturing Android 1..."
adb -s 100.104.203.40:37743 shell screencap -p /sdcard/screen.png
adb -s 100.104.203.40:37743 pull /sdcard/screen.png "$BASE_DIR/android1.png"

# Android 2
echo "[*] Capturing Android 2..."
adb -s 100.86.154.59:41469 shell screencap -p /sdcard/screen.png
adb -s 100.86.154.59:41469 pull /sdcard/screen.png "$BASE_DIR/android2.png"

echo "[!] Done. Dashboard updated."
