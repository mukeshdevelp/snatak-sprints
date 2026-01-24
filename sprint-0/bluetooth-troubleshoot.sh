#!/bin/bash

# Bluetooth Troubleshooting Script for Rockerz 255
# This script helps diagnose and connect to Bluetooth devices

echo "=== Bluetooth Troubleshooting for Rockerz 255 ==="
echo ""

# Check Bluetooth service
echo "1. Checking Bluetooth service status..."
if systemctl is-active --quiet bluetooth; then
    echo "   ✓ Bluetooth service is running"
else
    echo "   ✗ Bluetooth service is not running"
    echo "   Attempting to start..."
    sudo systemctl start bluetooth
fi

# Check if Bluetooth is powered on
echo ""
echo "2. Checking Bluetooth adapter power..."
bluetoothctl show | grep -q "Powered: yes"
if [ $? -eq 0 ]; then
    echo "   ✓ Bluetooth adapter is powered on"
else
    echo "   ✗ Bluetooth adapter is off"
    echo "   Powering on..."
    bluetoothctl power on
fi

# Make adapter discoverable
echo ""
echo "3. Making PC discoverable..."
bluetoothctl discoverable on
echo "   ✓ PC is now discoverable"

# Start scanning
echo ""
echo "4. Starting device scan..."
echo "   Please ensure your Rockerz 255 is:"
echo "   - Turned ON"
echo "   - In PAIRING MODE (LED should be flashing)"
echo "   - Not connected to any other device"
echo ""
echo "   Scanning for 15 seconds..."
bluetoothctl scan on &
SCAN_PID=$!
sleep 15
kill $SCAN_PID 2>/dev/null
bluetoothctl scan off

# List discovered devices
echo ""
echo "5. Discovered devices:"
bluetoothctl devices

# Check for Rockerz 255
echo ""
echo "6. Searching for Rockerz 255..."
ROCKERZ_MAC=$(bluetoothctl devices | grep -i "rock" | awk '{print $2}')
if [ -n "$ROCKERZ_MAC" ]; then
    echo "   ✓ Found Rockerz device at: $ROCKERZ_MAC"
    echo ""
    echo "   Attempting to pair..."
    bluetoothctl pair $ROCKERZ_MAC
    sleep 2
    echo ""
    echo "   Attempting to connect..."
    bluetoothctl connect $ROCKERZ_MAC
    sleep 2
    echo ""
    echo "   Device info:"
    bluetoothctl info $ROCKERZ_MAC
else
    echo "   ✗ Rockerz 255 not found in scan"
    echo ""
    echo "   Troubleshooting steps:"
    echo "   1. Turn OFF the Rockerz 255 completely"
    echo "   2. Turn it back ON"
    echo "   3. Hold the power/pairing button until LED flashes (usually 5-10 seconds)"
    echo "   4. Make sure it's not connected to any phone/tablet"
    echo "   5. Keep the device within 1 meter of your PC"
    echo "   6. Run this script again"
fi

echo ""
echo "=== Troubleshooting Complete ==="
