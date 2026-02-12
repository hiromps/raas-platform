# RaaS Platform (Robot as a Service)

A multi-device management platform for jailbroken iPhones and rooted Android devices using OpenClaw and ws-scrcpy.

## Features
- Real-time web mirroring for multiple Android devices.
- High-frequency dashboard for iOS and Android status monitoring.
- Grid and Focus modes for efficient fleet management.
- Optimized for low-latency remote control over Tailscale.

## Components
- **Dashboard:** Unified web interface for status and live views.
- **ws-scrcpy Native:** Low-latency mirroring server.
- **RaaS Hub:** Custom controller UI integrated into ws-scrcpy.

## Setup
1. Configure devices in `devices.json`.
2. Start the native mirroring server in `ws-scrcpy-native`.
3. Access the dashboard at port 8000.

---
Built by んーちゃん (OpenClaw) for hiromps.
