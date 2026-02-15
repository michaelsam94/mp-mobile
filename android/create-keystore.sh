#!/bin/bash

# Script to create Android keystore for Mega Plug app
# Run this script from the android directory

KEYSTORE_DIR="keystore"
KEYSTORE_FILE="$KEYSTORE_DIR/mega-plug-keystore.jks"
KEY_ALIAS="mega-plug-key"
VALIDITY_YEARS=25

# Find Java from Android Studio or Flutter
JAVA_BIN=""
if [ -f "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java" ]; then
    JAVA_BIN="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java"
elif [ -n "$JAVA_HOME" ]; then
    JAVA_BIN="$JAVA_HOME/bin/java"
elif command -v java &> /dev/null; then
    JAVA_BIN=$(which java)
else
    echo "Error: Java not found. Please install Java or set JAVA_HOME."
    exit 1
fi

KEYTOOL_BIN="${JAVA_BIN%/java}/keytool"

if [ ! -f "$KEYTOOL_BIN" ]; then
    echo "Error: keytool not found at $KEYTOOL_BIN"
    exit 1
fi

# Create keystore directory if it doesn't exist
mkdir -p "$KEYSTORE_DIR"

# Check if keystore already exists
if [ -f "$KEYSTORE_FILE" ]; then
    echo "Keystore already exists at $KEYSTORE_FILE"
    echo "If you want to create a new one, please delete the existing keystore first."
    exit 1
fi

echo "Creating Android keystore for Mega Plug app..."
echo "Using Java: $JAVA_BIN"
echo "You will be prompted to enter:"
echo "  - Keystore password (remember this!)"
echo "  - Key password (can be same as keystore password)"
echo "  - Your name and organization details"
echo ""

"$KEYTOOL_BIN" -genkey -v \
    -keystore "$KEYSTORE_FILE" \
    -alias "$KEY_ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity $((VALIDITY_YEARS * 365)) \
    -storetype JKS

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Keystore created successfully at: $KEYSTORE_FILE"
    echo ""
    echo "IMPORTANT: Update android/key.properties with your passwords:"
    echo "  storePassword=YOUR_KEYSTORE_PASSWORD"
    echo "  keyPassword=YOUR_KEY_PASSWORD"
    echo ""
    echo "Also, make sure to backup your keystore file securely!"
    echo "If you lose it, you won't be able to update your app on Play Store."
else
    echo "Failed to create keystore. Please check the error messages above."
    exit 1
fi
