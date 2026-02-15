# Weekly Development Documentation
**Period:** Last Sunday (December 28, 2025) to Today (January 1, 2026)

## Overview
This document summarizes all development work completed during the past week, including new features, bug fixes, improvements, and technical enhancements.

---

## 🔥 Major Features Implemented

### 1. Firebase Messaging & Push Notifications
**Date:** December 29, 2025  
**Contributor:** asmaaabozied

- **Firebase Core & Messaging Integration**
  - Configured Firebase Core and Messaging services
  - Added `firebase_core` and `firebase_messaging` dependencies
  - Set up notification handlers for foreground, background, and terminated app states
  - Implemented Firebase token logging for debugging

- **Local Notifications Support**
  - Integrated `flutter_local_notifications` for foreground notifications
  - Enabled core library desugaring for Android compatibility
  - Added notification permissions to Android manifest
  - Created platform-specific notification implementations (Android/iOS)

- **iOS Push Notifications**
  - Added `Runner.entitlements` with `aps-environment` for push notifications
  - Properly configured `GoogleService-Info.plist` in Xcode project
  - Set up `CODE_SIGN_ENTITLEMENTS` in all build configurations
  - Fixed iOS Firebase initialization in `AppDelegate.swift` to prevent white screen crashes
  - Made Firebase initialization conditional to prevent crashes when `GoogleService-Info.plist` is missing

- **Device Token Handling**
  - Updated login and signup flows to always send `device_token`
    - If Firebase token is unavailable, sends the string `"device_token"` as fallback
  - Enhanced Firebase token logging in `main.dart`

**Files Modified:**
- `android/app/build.gradle.kts`
- `android/app/src/main/AndroidManifest.xml`
- `android/settings.gradle.kts`
- `ios/Runner/AppDelegate.swift`
- `ios/Runner/Runner.entitlements`
- `ios/Runner.xcodeproj/project.pbxproj`
- `lib/main.dart`
- `pubspec.yaml`

---

### 2. Current Vehicle Charging Screen
**Date:** December 28-30, 2025  
**Contributor:** asmaaabozied

- **New Screen Implementation**
  - Created `CurrentVehicleChargingScreen` with full UI and state management
  - Implemented `CurrentVehicleChargingCubit` and state management
  - Added `VehicleChargingResponseModel` to handle API responses

- **API Integration**
  - Integrated current vehicle charging API endpoint
  - Added support for `vehicle_id` in start charging flow
  - Updated stop charging to include `connector_id`
  - Handled empty array `[]` for `charging_session` field in API response
  - Changed `chargerId` from `int` to `String` to match API (serial number)

- **Charging Functionality**
  - Display current charging state and session information
  - Start/stop charging functionality with proper API calls
  - Real-time charging data display
  - Added refresh after returning from QR scanner

- **UI Enhancements**
  - Added vehicle image with green circle indicator
  - Updated charge button navigation to current vehicle charging screen
  - Improved scrolling with `AlwaysScrollableScrollPhysics`
  - Added pull-to-refresh functionality

**Files Created/Modified:**
- `lib/presentation/vehicles/current_vehicle_charging_screen.dart`
- `lib/presentation/vehicles/cubit/current_vehicle_charging_cubit.dart`
- `lib/presentation/vehicles/cubit/current_vehicle_charging_state.dart`
- `lib/presentation/vehicles/models/vehicle_charging_response_model.dart`
- `lib/core/services/charging_api_service.dart`
- `lib/core/services/charging_cubit/charging_cubit.dart`

---

### 3. Favorite Stations Functionality
**Date:** December 30, 2025  
**Contributor:** asmaaabozied, Eslam Fareed

- **Favorite API Integration**
  - Added favorite/unfavorite API calls
  - Implemented favorite status synchronization across cached lists
  - Added authentication token headers to station APIs when user is logged in

- **UI Updates**
  - Added star icons to indicate favorite status
  - Enabled favorite filter in search functionality
  - Updated station details to show favorite status
  - Hide favorite button in station details screen (UI decision)

- **Data Synchronization**
  - Update cached station lists when favorites are toggled in search or station details
  - Maintain favorite status consistency across map, search, and station details screens

**Files Modified:**
- `lib/presentation/map/map_cubit/map_cubit.dart`
- `lib/presentation/map/search_cubit/search_cubit.dart`
- `lib/presentation/map/search_screen.dart`
- `lib/presentation/map/station_details_bottom_sheet.dart`
- `lib/presentation/map/station_details_cubit/station_details_cubit.dart`
- `lib/presentation/map/models/map_station_response_model.dart`
- `lib/presentation/map/models/station_response_model.dart`

---

### 4. Station Details UI Improvements
**Date:** December 30-31, 2025  
**Contributor:** asmaaabozied

- **UI Enhancements**
  - Replaced click-to-charge button with status badge
  - Made connectors section scrollable with drag-to-close functionality
  - Replaced rounded icons with marker icons in station details
  - Added image carousel for station `media_url` array
  - Improved overall visual consistency

- **Status Badge**
  - Dynamic station status badge with color coding
  - Real-time status updates based on API response
  - Support for multiple status states (available, in use, unavailable, etc.)

**Files Modified:**
- `lib/presentation/map/station_details_bottom_sheet.dart`
- `lib/presentation/map/station_details_cubit/station_details_cubit.dart`

---

## 🐛 Bug Fixes & Improvements

### 1. Charger Screen Data Issues
**Date:** December 29-31, 2025  
**Contributor:** asmaaabozied, Eslam Fareed

- **Fixed Cached Meter Data Issue**
  - Added `clearMeterData()` method to `WebSocketCubit`
  - Clear meter data when starting new charging session
  - Show shimmer loading until new meter values arrive via WebSocket
  - Keep meter data when stopping session to allow viewing final values and PDF download

- **Fixed Old Data Display**
  - Prevent showing first vehicle data when starting second vehicle session
  - Clear old meter data when starting new charging session
  - Improved data refresh mechanism

- **UI Improvements**
  - Improved scrolling with `AlwaysScrollableScrollPhysics`
  - Added refresh after returning from QR scanner in vehicle charging screen
  - Enhanced data binding for current session API response

**Files Modified:**
- `lib/core/services/websocket_cubit/websocket_cubit.dart`
- `lib/presentation/map/charger_screen.dart`
- `lib/presentation/map/start_session_screen.dart`
- `lib/presentation/vehicles/current_vehicle_charging_screen.dart`

---

### 2. Station Marker Icons & Status
**Date:** December 31, 2025  
**Contributor:** asmaaabozied

- **Icon Logic Updates**
  - Updated marker icons to use `ac_compatible` and `status` from API
  - Added `acCompatible` field to `StationResponseModel`
  - Use `use.png` icon for AC stations in use instead of `ac.png`
  - Normalize status values (`inuse`/`in_use`) to match icon cache keys
  - Fallback to checking guns if `ac_compatible` is not available

- **Status Display**
  - Dynamic station status badge with color coding
  - AC/DC icon selection based on `ac_compatible` field
  - Updated icon logic in map, search, station details, and charger screen

**Files Modified:**
- `lib/presentation/map/charger_screen.dart`
- `lib/presentation/map/map_cubit/map_cubit.dart`
- `lib/presentation/map/models/map_station_response_model.dart`
- `lib/presentation/map/models/station_response_model.dart`
- `lib/presentation/map/search_cubit/search_cubit.dart`
- `lib/presentation/map/station_details_bottom_sheet.dart`

---

### 3. Onboarding Flow Fixes
**Date:** December 31, 2025  
**Contributor:** asmaaabozied

- **Onboarding Logic**
  - Added `onboardingCompleted` flag to track if onboarding has been shown
  - Show onboarding only on first app install (when flag is false)
  - Navigate to login screen after logout instead of showing onboarding
  - Mark onboarding as completed when user finishes onboarding
  - Preserve onboarding flag across logouts

**Files Modified:**
- `lib/core/helpers/cache/cache_helper.dart`
- `lib/core/helpers/cache/cache_keys.dart`
- `lib/presentation/onboarding/onboarding_screen.dart`
- `lib/presentation/profile/profile_screen.dart`
- `lib/presentation/start/splash_screen.dart`

---

### 4. Authentication & API Improvements
**Date:** December 30-31, 2025  
**Contributor:** Eslam Fareed, michael

- **Login Fixes**
  - Fixed phone or email login functionality
  - Updated device token handling in login and signup flows
  - Always send `device_token` field (sends `"device_token"` string if Firebase token unavailable)

- **API Error Handling**
  - Handle 401 responses: logout immediately on token expiration
  - Handle 402 status code: navigate to top-up screen when balance is insufficient
  - Improved error handling in network layer

**Files Modified:**
- `lib/presentation/auth/login/cubit/login_cubit.dart`
- `lib/presentation/auth/login/login_screen.dart`
- `lib/presentation/auth/signup/cubit/sign_up_cubit.dart`
- `lib/core/helpers/network/dio_helper.dart`
- `lib/core/services/charging_cubit/charging_cubit.dart`

---

### 5. Vehicle Management
**Date:** December 28-30, 2025  
**Contributor:** asmaaabozied, Eslam Fareed

- **Vehicle Functionality**
  - Added vehicle validation for charge button
  - Implemented edit/delete vehicle functionality
  - Fixed vehicle add request fields
  - Updated sign-up flow: navigate to home screen after adding vehicle

- **UI Improvements**
  - Updated vehicle/RFID screens with FAB buttons
  - Improved vehicle setup screen
  - Enhanced vehicle details display

**Files Modified:**
- `lib/presentation/vehicles/my_vehicles_screen.dart`
- `lib/presentation/vehicles/vehicle_setup_screen.dart`
- `lib/presentation/vehicles/cubit/vehicles_cubit.dart`
- `lib/presentation/auth/personalizeProfile/personalize_profile_screen.dart`

---

### 6. History & Notifications
**Date:** December 31, 2025  
**Contributor:** Eslam Fareed

- **History Screen**
  - Refresh data when returning from ChargerScreen
  - Prevent duplicate notifications
  - Improved data refresh mechanism

**Files Modified:**
- `lib/presentation/history/history_screen.dart`
- `lib/presentation/map/charger_screen.dart`

---

## 🔧 Technical Improvements

### 1. Build Configuration
**Date:** December 30-31, 2025  
**Contributor:** asmaaabozied, michael

- **Android Configuration**
  - Added Google Services plugin
  - Enabled core library desugaring for `flutter_local_notifications`
  - Updated build.gradle configurations
  - Fixed build errors and missing dependencies

- **iOS Configuration**
  - Added `NSLocationAlwaysAndWhenInUseUsageDescription` to Info.plist
  - Fixed Xcode project configuration
  - Updated Podfile.lock
  - Added proper entitlements configuration

- **Project Updates**
  - Updated `pubspec.yaml` with new dependencies
  - Updated `pubspec.lock`
  - Fixed project structure

**Files Modified:**
- `android/app/build.gradle.kts`
- `android/settings.gradle.kts`
- `ios/Runner/Info.plist`
- `ios/Podfile.lock`
- `ios/Runner.xcodeproj/project.pbxproj`
- `pubspec.yaml`
- `pubspec.lock`

---

### 2. WebSocket & Real-time Data
**Date:** December 29-30, 2025  
**Contributor:** asmaaabozied

- **WebSocket Improvements**
  - Updated stop charging to use charger serial number
  - Use `charger_id_prefix` as `connector_id` when available
  - Store charger serial number and prefix in `WebSocketCubit` from loaded sessions
  - Enhanced session update model with new fields

- **API Response Binding**
  - Added support for new API response structure with data wrapper
  - Map new fields: `current_percentage`, `power_consumtion`, `output`, `station_status`, `ac_compatible`
  - Maintain backward compatibility with old API format

**Files Modified:**
- `lib/core/services/websocket_cubit/websocket_cubit.dart`
- `lib/core/services/models/session_update_model.dart`
- `lib/presentation/vehicles/models/vehicle_charging_response_model.dart`

---

### 3. Code Quality & Formatting
**Date:** December 30, 2025  
**Contributor:** asmaaabozied

- Added trailing newlines to files
- Improved code formatting
- Enhanced error handling
- Added debug logging for troubleshooting

---

## 📱 UI/UX Enhancements

### 1. Wallet Screen
**Date:** December 28, 2025  
**Contributor:** asmaaabozied

- Added pull-to-refresh functionality
- Improved user experience with refresh indicators

**Files Modified:**
- `lib/presentation/wallet/wallet_screen.dart`

---

### 2. Charging History
**Date:** December 28, 2025  
**Contributor:** asmaaabozied

- Improved charging history display
- Enhanced history screen functionality

**Files Modified:**
- `lib/presentation/history/history_screen.dart`
- `lib/presentation/history/cubit/history_cubit.dart`

---

## 📊 Statistics

### Commits Summary
- **Total Commits:** 50+ commits
- **Contributors:** 
  - asmaaabozied (majority of commits)
  - Eslam Fareed
  - michael

### Files Changed
- **New Files Created:** ~15 files
- **Files Modified:** ~80+ files
- **Lines Added:** ~2000+ lines
- **Lines Removed:** ~500+ lines

### Key Areas of Work
1. Firebase & Notifications: 8 commits
2. Vehicle Charging: 12 commits
3. Station Features: 10 commits
4. Bug Fixes: 15 commits
5. Build & Configuration: 5 commits

---

## 🔄 Integration Points

### API Endpoints Added/Modified
- Current vehicle charging endpoint
- Favorite/unfavorite station endpoints
- Station details with authentication
- Start/stop charging with vehicle_id support

### Third-party Services
- Firebase Core & Messaging
- Firebase Cloud Messaging (FCM)
- Local Notifications
- WebSocket for real-time charging data

---

## 🚀 Deployment Notes

### Dependencies Added
- `firebase_core`
- `firebase_messaging`
- `flutter_local_notifications`
- `open_file`
- `path_provider`

### Platform-Specific Changes
- **Android:** Google Services plugin, notification permissions, desugaring
- **iOS:** Push notification entitlements, Firebase initialization, location permissions

### Configuration Files Updated
- `pubspec.yaml`
- `android/app/build.gradle.kts`
- `android/settings.gradle.kts`
- `ios/Runner/Info.plist`
- `ios/Runner/Runner.entitlements`
- `ios/Runner.xcodeproj/project.pbxproj`

---

## 📝 Notes

- All changes have been tested and committed to the `alpha` branch
- Firebase configuration requires proper `GoogleService-Info.plist` and `google-services.json` files
- Device token handling now gracefully falls back to string `"device_token"` if Firebase token is unavailable
- Onboarding flow now properly tracks completion state
- Favorite functionality is fully integrated with authentication
- Real-time charging data is now properly cleared and refreshed

---

## 🔜 Next Steps (Recommendations)

1. **Testing**
   - Comprehensive testing of Firebase notifications on both platforms
   - Test favorite functionality with different user states
   - Verify charging flow end-to-end

2. **Documentation**
   - API documentation updates
   - User guide for new features

3. **Performance**
   - Monitor WebSocket performance
   - Optimize station list caching

4. **Security**
   - Review authentication token handling
   - Ensure proper error handling for expired tokens

---

**Document Generated:** January 1, 2026  
**Last Updated:** January 1, 2026

