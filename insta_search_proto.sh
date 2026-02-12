#!/bin/bash
# Instagramサーチプロトタイプ (Android1用)
# 1. Instagramを起動
# 2. 検索タブへ移動
# 3. 指定キーワードで検索
# 4. スクリーンショットを撮影して解析へ回す

SERIAL="100.104.203.40:38601"
KEYWORD="関西グルメ"

echo "[*] Launching Instagram on $SERIAL"
adb -s $SERIAL shell am start -n com.instagram.android/com.instagram.mainactivity.MainActivity

sleep 5

# 検索アイコンをタップ (座標は一般的なAndroid端末の目安、後で調整が必要)
# 下部タブの左から2番目あたり
echo "[*] Tapping Search Tab"
adb -s $SERIAL shell input tap 300 2200 

sleep 2

# 検索バーをタップして入力
echo "[*] Searching for $KEYWORD"
adb -s $SERIAL shell input tap 500 150 # 検索窓
sleep 1
adb -s $SERIAL shell input text "$KEYWORD"
adb -s $SERIAL shell input keyevent 66 # Enter

sleep 5

echo "[*] Capturing result"
adb -s $SERIAL shell screencap -p /sdcard/search_result.png
adb -s $SERIAL pull /sdcard/search_result.png ./projects/raas/search_result_android1.png
