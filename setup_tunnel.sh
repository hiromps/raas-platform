#!/bin/bash
# =============================================================
# Cloudflare Tunnel Setup Script for RaaS Platform
# smartgram.jp → ws-scrcpy (ADB screen mirroring)
#
# このスクリプトはws-scrcpyが動作するLinuxサーバー上で実行してください。
# 前提: ubuntu/debian系 ARM64 (aarch64)
# =============================================================

set -e

TUNNEL_NAME="raas-scrcpy"
HOSTNAME="smartgram.jp"
WS_SCRCPY_PORT="${WS_SCRCPY_PORT:-8000}"

echo "=========================================="
echo "  RaaS Cloudflare Tunnel Setup"
echo "  Domain: ${HOSTNAME}"
echo "  Port:   ${WS_SCRCPY_PORT}"
echo "=========================================="

# --- Step 1: Install cloudflared ---
if ! command -v cloudflared &>/dev/null; then
    echo "[1/5] Installing cloudflared..."
    ARCH=$(dpkg --print-architecture 2>/dev/null || echo "arm64")
    curl -L --output /tmp/cloudflared.deb "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH}.deb"
    sudo dpkg -i /tmp/cloudflared.deb
    rm /tmp/cloudflared.deb
    echo "  ✅ cloudflared installed: $(cloudflared --version)"
else
    echo "[1/5] cloudflared already installed: $(cloudflared --version)"
fi

# --- Step 2: Authenticate with Cloudflare ---
echo ""
echo "[2/5] Authenticating with Cloudflare..."
echo "  ブラウザが開くので、Cloudflareアカウントにログインしてドメインを選択してください。"
cloudflared tunnel login

# --- Step 3: Create tunnel ---
echo ""
echo "[3/5] Creating tunnel: ${TUNNEL_NAME}..."
EXISTING=$(cloudflared tunnel list | grep "${TUNNEL_NAME}" || true)
if [ -n "$EXISTING" ]; then
    echo "  ⚠️  トンネル '${TUNNEL_NAME}' は既に存在します。スキップします。"
    TUNNEL_ID=$(echo "$EXISTING" | awk '{print $1}')
else
    cloudflared tunnel create "${TUNNEL_NAME}"
    TUNNEL_ID=$(cloudflared tunnel list | grep "${TUNNEL_NAME}" | awk '{print $1}')
fi
echo "  Tunnel ID: ${TUNNEL_ID}"

# --- Step 4: Route DNS ---
echo ""
echo "[4/5] Setting DNS route: ${HOSTNAME} → ${TUNNEL_NAME}..."
cloudflared tunnel route dns "${TUNNEL_NAME}" "${HOSTNAME}" || echo "  ⚠️  DNS route may already exist."

# --- Step 5: Create config ---
echo ""
echo "[5/5] Creating config file..."
CRED_FILE="$HOME/.cloudflared/${TUNNEL_ID}.json"
CONFIG_FILE="$HOME/.cloudflared/config.yml"

cat > "${CONFIG_FILE}" << EOF
tunnel: ${TUNNEL_ID}
credentials-file: ${CRED_FILE}

ingress:
  - hostname: ${HOSTNAME}
    service: http://localhost:${WS_SCRCPY_PORT}
    originRequest:
      noTLSVerify: true
  - service: http_status:404
EOF

echo "  ✅ Config written to: ${CONFIG_FILE}"
echo ""
echo "=========================================="
echo "  セットアップ完了！"
echo ""
echo "  トンネルを起動するには:"
echo "    cloudflared tunnel run ${TUNNEL_NAME}"
echo ""
echo "  systemdサービスとして登録するには:"
echo "    sudo cloudflared service install"
echo "    sudo systemctl enable cloudflared"
echo "    sudo systemctl start cloudflared"
echo ""
echo "  ws-scrcpyのポートが${WS_SCRCPY_PORT}でない場合:"
echo "    WS_SCRCPY_PORT=<port> bash setup_tunnel.sh"
echo "=========================================="
