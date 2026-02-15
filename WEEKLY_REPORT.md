# Weekly Development Report
**Period:** January 18, 2026 - January 22, 2026 (Previous Week)

---

## Summary
- **Total Commits:** 4
- **Contributors:** 2 (michael samuel, asmaaabozied)
- **Files Changed:** 20+ files
- **Focus Areas:** Onboarding flow, Wallet screen improvements, Profile screen updates

---

## Commits Overview

### 1. **feat: always show onboarding when user is not logged in**
   - **Commit:** `f5eb63a`
   - **Author:** michael samuel
   - **Date:** January 22, 2026
   - **Description:** Modified splash screen logic to always show onboarding screen when user is not logged in, regardless of previous completion status.
   - **Files Changed:**
     - `lib/presentation/start/splash_screen.dart` (22 insertions, 39 deletions)
   - **Impact:** Improved user experience by ensuring onboarding is shown every time a user logs out or opens the app without being logged in.

---

### 2. **feat: show onboarding on first install and after logout, fix wallet button height**
   - **Commit:** `c3982a2`
   - **Author:** michael samuel
   - **Date:** January 22, 2026
   - **Description:** 
     - Updated onboarding logic to show on first install and after user logout
     - Fixed wallet screen "Add Credit" button height to match "Manage Cards" button
     - Updated logout flow to reset onboarding flag and navigate to splash screen
   - **Files Changed:**
     - `lib/core/helpers/cache/cache_helper.dart` - Modified logout to reset onboarding flag
     - `lib/core/helpers/network/dio_helper.dart` - Updated unauthorized handling to navigate to splash
     - `lib/presentation/profile/profile_screen.dart` - Changed logout navigation to splash screen
     - `lib/presentation/start/splash_screen.dart` - Updated onboarding display logic
     - `lib/presentation/wallet/wallet_screen.dart` - Fixed button height consistency
     - `lib/presentation/map/station_details_bottom_sheet.dart` - Minor updates
     - `lib/presentation/profile/models/settings_response_model.dart` - Model updates
     - Multiple icon assets updated (dc.png, dc_available.png, dc_inuse.png, etc.)
   - **Impact:** Enhanced onboarding user flow and improved UI consistency in wallet screen.

---

### 3. **Update wallet screen: add credit button color, manage cards button styling, and transaction display improvements**
   - **Commit:** `50cafca`
   - **Author:** michael samuel
   - **Date:** January 20, 2026
   - **Description:** 
     - Added credit button color styling
     - Improved manage cards button styling
     - Enhanced transaction display
   - **Files Changed:**
     - `lib/presentation/wallet/wallet_screen.dart` (23 insertions, 16 deletions)
     - `lib/presentation/profile/models/settings_response_model.dart` - Model updates
     - Added new image assets: `chargin_session.png`, `top_up.png`
   - **Impact:** Better visual design and user experience in wallet functionality.

---

### 4. **Update profile and wallet screens: move edit button, add bottom padding, adjust wallet padding**
   - **Commit:** `3aa1589`
   - **Author:** asmaaabozied
   - **Date:** January 18, 2026
   - **Description:** 
     - Moved edit button in profile screen
     - Added bottom padding adjustments
     - Adjusted wallet screen padding
   - **Files Changed:**
     - `lib/presentation/profile/profile_screen.dart` (86 insertions, 86 deletions)
     - `lib/presentation/wallet/wallet_screen.dart` - Padding adjustments
     - `lib/presentation/profile/models/settings_response_model.dart` - Model updates
     - `WEEKLY_REPORT.md` - Documentation updates
   - **Impact:** Improved UI layout and spacing in profile and wallet screens.

---

## Key Features & Improvements

### Onboarding Flow
- ✅ Onboarding now shows on first app install
- ✅ Onboarding displays after user logout
- ✅ Onboarding always shows when user is not logged in
- ✅ Improved user experience for new and returning users

### Wallet Screen
- ✅ Fixed button height consistency (Add Credit & Manage Cards)
- ✅ Enhanced button styling and colors
- ✅ Improved transaction display
- ✅ Better padding and layout adjustments

### Profile Screen
- ✅ Repositioned edit button for better UX
- ✅ Improved padding and spacing
- ✅ Enhanced visual layout

### Technical Improvements
- ✅ Updated logout flow to properly reset onboarding state
- ✅ Improved navigation flow after logout
- ✅ Enhanced error handling for unauthorized access
- ✅ Updated icon assets for better visual consistency

---

## Statistics

### Code Changes
- **Total Files Modified:** 20+ files
- **Lines Added:** ~200+ lines
- **Lines Removed:** ~200+ lines
- **Net Change:** Balanced refactoring and feature additions

### Areas of Focus
1. **User Onboarding** - Major improvements to onboarding flow
2. **Wallet Functionality** - UI/UX enhancements
3. **Profile Management** - Layout and styling improvements
4. **Navigation Flow** - Improved routing after logout

---

## Next Steps / Recommendations

1. **Testing:** Consider adding automated tests for onboarding flow
2. **Documentation:** Update user guides if onboarding behavior changes affect user experience
3. **Analytics:** Track onboarding completion rates to measure impact
4. **Feedback:** Gather user feedback on new onboarding flow

---

## Contributors

- **michael samuel** - 3 commits (Onboarding flow, Wallet improvements)
- **asmaaabozied** - 1 commit (Profile and Wallet UI updates)

---

*Report generated on: January 22, 2026*
