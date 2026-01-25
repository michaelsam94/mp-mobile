# How to Get Your Android App Hash for SMS Autofill

## What is App Hash?

The **app hash** is an **11-character string** that uniquely identifies your app. It's derived from your app's signing certificate (keystore). Android's SMS Retriever API uses it to verify that an incoming SMS is intended for your app.

## Why Do You Need It?

For Android SMS autofill to work, your backend must append this 11-character hash to the end of every OTP SMS message.

**Example SMS format:**
```
Your OTP is 12345
FA+9qCX9VSu
```
(Where `FA+9qCX9VSu` is your app hash - exactly 11 characters)

## How to Get Your App Hash

### Method 1: Using Java Keytool (Windows)

1. **For Debug Build** (current setup):
   
   Open PowerShell or Command Prompt and run:
   ```powershell
   keytool -list -v -keystore $env:USERPROFILE\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
   
   Look for the line that says `SHA256:` and copy the first 11 characters (without colons).
   
   Example output:
   ```
   SHA256: FA:9q:CX:9V:Su:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF
   ```
   
   Your hash would be: `FA+9qCX9VSu` (first 11 characters, remove colons, use + instead of : if needed)

2. **For Release Build** (when you have a release keystore):
   ```powershell
   keytool -list -v -keystore C:\path\to\your\release.keystore -alias your_alias
   ```
   
   Then extract the first 11 characters from SHA256.

### Method 2: Using Flutter Package (Easiest - Recommended)

You can use the `sms_autofill` package to get it programmatically. Add this code temporarily to your OTP screen:

```dart
import 'package:sms_autofill/sms_autofill.dart';

// In your initState or somewhere
try {
  final hash = await SmsAutoFill().getAppSignature();
  print('Your App Hash: $hash');
  print('Share this with your backend team!');
} catch (e) {
  print('Error getting hash: $e');
}
```

**Note:** This method might not work on all devices. If it doesn't, use Method 1.

### Method 3: Manual Calculation

1. Get your app's SHA-256 fingerprint:
   ```powershell
   keytool -list -v -keystore $env:USERPROFILE\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

2. Copy the SHA-256 value (looks like: `AA:BB:CC:DD:...`)

3. Take the first 11 characters and remove colons:
   - Example: `FA:9q:CX:9V:Su` → `FA+9qCX9VSu`
   - Or: `FA:9q:CX:9V:Su:AB` → `FA+9qCX9VSu` (first 11 chars)

## Important Notes:

1. **Different Hashes for Debug vs Release**: 
   - Debug builds use the debug keystore → one hash
   - Release builds use your release keystore → different hash
   - You need to provide BOTH hashes to your backend team

2. **Hash Changes**: 
   - The hash changes if you change your signing certificate
   - If you update your keystore, you'll need a new hash

3. **Backend Requirements**:
   - Your backend must append the hash to EVERY OTP SMS
   - The hash must be exactly 11 characters
   - The SMS must be ≤ 140 bytes total

## Quick Test:

Once you have the hash, test it by sending yourself an SMS in this format:
```
Your OTP is 12345
YOUR_11_CHAR_HASH
```

If SMS autofill works, you'll see the OTP automatically filled in your app!

