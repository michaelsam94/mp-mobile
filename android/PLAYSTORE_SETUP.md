# Play Store Publishing Setup Guide

This guide will help you set up the keystore and generate an app bundle for Google Play Store.

## Step 1: Create the Keystore

### Option A: Using the provided script (Recommended)

1. Navigate to the android directory:
   ```bash
   cd android
   ```

2. Run the keystore creation script:
   ```bash
   ./create-keystore.sh
   ```

3. Follow the prompts:
   - Enter a **strong keystore password** (save this securely!)
   - Enter a **key password** (can be the same as keystore password)
   - Enter your name and organization details

### Option B: Manual creation

Run this command from the `android` directory:

```bash
keytool -genkey -v \
    -keystore keystore/mega-plug-keystore.jks \
    -alias mega-plug-key \
    -keyalg RSA \
    -keysize 2048 \
    -validity 9125 \
    -storetype JKS
```

**Important:** 
- The keystore file will be created at `android/keystore/mega-plug-keystore.jks`
- Keep this file and passwords secure! You'll need them for all future app updates.
- If you lose the keystore, you cannot update your app on Play Store.

## Step 2: Configure key.properties

1. Open `android/key.properties` file

2. Replace the placeholder values with your actual passwords:
   ```properties
   storePassword=YOUR_ACTUAL_KEYSTORE_PASSWORD
   keyPassword=YOUR_ACTUAL_KEY_PASSWORD
   keyAlias=mega-plug-key
   storeFile=../keystore/mega-plug-keystore.jks
   ```

3. **Important:** Add `key.properties` to `.gitignore` to keep your passwords secure:
   ```bash
   echo "android/key.properties" >> .gitignore
   echo "android/keystore/" >> .gitignore
   ```

## Step 3: Build the App Bundle

From the project root directory, run:

```bash
flutter build appbundle --release
```

The app bundle will be generated at:
```
build/app/outputs/bundle/release/app-release.aab
```

## Step 4: Upload to Play Store

1. Go to [Google Play Console](https://play.google.com/console)
2. Create a new app or select your existing app
3. Go to **Production** → **Create new release**
4. Upload the `app-release.aab` file
5. Fill in the release notes and submit for review

## Troubleshooting

### Error: "key.properties not found"
- Make sure you've created the `key.properties` file in the `android` directory
- Check that the file path is correct

### Error: "Keystore file not found"
- Verify the keystore file exists at `android/keystore/mega-plug-keystore.jks`
- Check the `storeFile` path in `key.properties` is correct

### Error: "Wrong password"
- Double-check your passwords in `key.properties`
- Make sure there are no extra spaces or special characters

## Security Best Practices

1. **Never commit** `key.properties` or `keystore/` directory to version control
2. **Backup** your keystore file in multiple secure locations
3. **Document** your passwords in a secure password manager
4. **Use** different passwords for keystore and key if possible

## Notes

- The keystore is valid for 25 years (9125 days)
- You can use the same keystore for all future app updates
- If you need to change the keystore, you'll need to create a new app listing on Play Store
