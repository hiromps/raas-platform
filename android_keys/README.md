# ADB Keys

This directory is used to store ADB keys for device authentication.

## Security Warning

**DO NOT COMMIT PRIVATE KEYS TO THIS REPOSITORY.**

The `adbkey` file is a private key and is excluded from git via `.gitignore`.
If you need to use custom ADB keys, place your `adbkey` and `adbkey.pub` files in this directory locally.

To generate new ADB keys, you can use the `adb` tool:
```bash
adb keygen adbkey
```
Then move the generated files here if needed.
