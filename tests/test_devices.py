import json
import os
import ipaddress
import pytest

def get_devices_path():
    """Returns the absolute path to devices.json."""
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base_dir, 'devices.json')

def is_valid_ip(ip):
    """Validates IPv4 or IPv6 address."""
    try:
        ipaddress.ip_address(ip)
        return True
    except ValueError:
        return False

def test_devices_json_exists():
    filepath = get_devices_path()
    assert os.path.exists(filepath), f"{filepath} does not exist"

def test_devices_json_schema():
    filepath = get_devices_path()

    with open(filepath, 'r') as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError as e:
            pytest.fail(f"devices.json is not a valid JSON: {e}")

    assert "devices" in data, "Missing 'devices' key in devices.json"
    assert isinstance(data["devices"], list), "'devices' should be a list"

    required_fields = ["id", "name", "os", "ip", "type"]
    device_ids = []

    for i, device in enumerate(data["devices"]):
        # Check required fields
        for field in required_fields:
            assert field in device, f"Device at index {i} is missing required field '{field}'"
            assert isinstance(device[field], str), f"Field '{field}' in device at index {i} should be a string"

        # Check OS
        assert device["os"] in ["ios", "android"], f"Invalid os '{device['os']}' at index {i}. Must be 'ios' or 'android'."

        # Check IP
        assert is_valid_ip(device["ip"]), f"Invalid IP address format: '{device['ip']}' at index {i}"

        # Collect IDs for uniqueness check
        device_ids.append(device["id"])

        # Optional fields check (if present, they should be strings)
        if "user" in device:
            assert isinstance(device["user"], str), f"'user' field at index {i} should be a string"
        if "port" in device:
            assert isinstance(device["port"], str), f"'port' field at index {i} should be a string"

    # Check for unique IDs
    assert len(device_ids) == len(set(device_ids)), f"Duplicate device IDs found: {device_ids}"
