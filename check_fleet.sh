#!/bin/bash

# RaaS Fleet Status Checker
# Gets battery levels for all connected devices (iOS & Android)

# iPhone 151 (iOS)
echo "--- iPhone 151 (100.126.108.117) ---"
ssh mobile@100.126.108.117 "grep -oE '[0-9]+' /var/mobile/Library/BatteryLife/Archives/$(ssh mobile@100.126.108.117 'ls -t /var/mobile/Library/BatteryLife/Archives/ | head -n 1') | head -n 1" 2>/dev/null || echo "Could not fetch battery via SSH (iOS path may vary)"
# Alternative for iOS battery (requires additional tools, let's keep it simple for now)

# Android Devices
echo "--- Android 1 (100.104.203.40) ---"
adb -s 100.104.203.40:38601 shell "dumpsys battery | grep level"

echo "--- Android 2 (100.86.154.59) ---"
adb -s 100.86.154.59:41469 shell "dumpsys battery | grep level"
