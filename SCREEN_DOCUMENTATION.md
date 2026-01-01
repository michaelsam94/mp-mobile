# Screen Documentation - Mega Plus Mobile App

## Table of Contents
1. [App Structure Overview](#app-structure-overview)
2. [Authentication Screens](#authentication-screens)
3. [Main Navigation Screens](#main-navigation-screens)
4. [Map & Station Screens](#map--station-screens)
5. [Vehicle Management Screens](#vehicle-management-screens)
6. [Wallet Screens](#wallet-screens)
7. [Profile Screens](#profile-screens)
8. [History & Charging Screens](#history--charging-screens)
9. [Other Screens](#other-screens)

---

## App Structure Overview

### Navigation Flow
```
SplashScreen
  ├─> OnboardingScreen (First time only)
  │   └─> LoginScreen
  ├─> LoginScreen (If not logged in)
  │   ├─> SignUpScreen
  │   │   └─> OTPVerificationScreen
  │   │       └─> CompleteProfileScreen
  │   │           └─> PersonalizeProfileScreen
  │   │               └─> VehicleSetupScreen
  │   │                   └─> MainScreen
  │   └─> MainScreen (Guest mode)
  └─> MainScreen (If logged in)
      ├─> MapScreen (Tab 0)
      ├─> WalletScreen (Tab 1)
      ├─> CurrentVehicleChargingScreen (Center FAB)
      ├─> HistoryScreen (Tab 3)
      └─> ProfileScreen (Tab 4)
```

### State Management
- **BLoC/Cubit Pattern**: All screens use BLoC/Cubit for state management
- **Global Providers**: Defined in `app_root.dart`
- **Local Providers**: Created per screen when needed

---

## Authentication Screens

### 1. SplashScreen
**Path:** `lib/presentation/start/splash_screen.dart`

**Purpose:** Initial screen that determines app flow based on user state

**Features:**
- Displays app logo
- Shows loading indicator
- Checks authentication status
- Routes to appropriate screen:
  - **Case 1**: Not logged in → Onboarding (if first time) or Login
  - **Case 2**: Token expired → Attempts refresh, then Login or MainScreen
  - **Case 3**: Logged in → MainScreen

**State Management:** None (stateless)

**Navigation:**
- `OnboardingScreen` (first install)
- `LoginScreen` (not logged in or after logout)
- `MainScreen` (logged in)

---

### 2. OnboardingScreen
**Path:** `lib/presentation/onboarding/onboarding_screen.dart`

**Purpose:** Introduces app features to first-time users

**Features:**
- Displays onboarding tips from API
- Image carousel with network images
- Page indicators (animated dots)
- "Next" / "Get Started" button
- Marks onboarding as completed when finished
- Only shows on first app install

**State Management:**
- `OnBoardingCubit` - Manages tips data and current index

**UI Components:**
- Image display with error handling
- Title and description text
- Animated page indicators
- Primary action button

**Navigation:**
- `LoginScreen` (after completion)

---

### 3. LoginScreen
**Path:** `lib/presentation/auth/login/login_screen.dart`

**Purpose:** User authentication

**Features:**
- **Phone/Email Login**: Accepts both phone number and email
- **Password Field**: With show/hide toggle
- **Remember Me**: Checkbox to remember user
- **Forget Password**: Link to password recovery
- **Continue as Guest**: Allows guest access
- **Sign Up Link**: Navigate to registration
- **Form Validation**: 
  - Email format validation
  - Password minimum 6 characters
- **Device Token**: Sends Firebase token (or "device_token" string if unavailable)
- **Loading State**: Shows loading indicator during login
- **Error Handling**: Displays error messages

**State Management:**
- `LoginCubit` - Handles login logic and state

**UI Components:**
- Text input fields with validation
- Password visibility toggle
- Remember me checkbox
- Primary and secondary buttons
- Social login options (commented out)

**Navigation:**
- `ForgetPasswordScreen` (forgot password)
- `SignUpScreen` (sign up link)
- `MainScreen` (successful login or guest)

---

### 4. SignUpScreen
**Path:** `lib/presentation/auth/signup/sign_up_screen.dart`

**Purpose:** New user registration - Step 1

**Features:**
- **Phone Number Input**: With country code selector
- **Country Code Selection**: Bottom sheet for country selection
- **OTP Verification**: Sends OTP to entered phone number
- **Form Validation**: Phone number validation
- **Device Token**: Sends Firebase token (or "device_token" string if unavailable)
- **Loading State**: Shows loading during OTP send
- **Error Handling**: Displays error messages

**State Management:**
- `SignUpCubit` - Manages signup flow and OTP sending

**UI Components:**
- Country code selector
- Phone number input field
- Primary action button
- Back navigation

**Navigation:**
- `OTPVerificationScreen` (after OTP sent)

---

### 5. OTPVerificationScreen
**Path:** `lib/presentation/auth/otp/otp_screen.dart`

**Purpose:** Verify OTP code sent to user's phone

**Features:**
- **OTP Input**: 6-digit code input
- **Auto-focus**: Automatically moves to next field
- **Resend OTP**: With countdown timer
- **Verification**: Validates OTP with backend
- **Loading State**: Shows loading during verification
- **Error Handling**: Displays error messages

**State Management:**
- `SignUpCubit` - Handles OTP verification

**UI Components:**
- 6-digit OTP input fields
- Resend button with timer
- Primary verification button

**Navigation:**
- `CompleteProfileScreen` (after successful verification in signup flow)
- `SetNewPasswordScreen` (after verification in forgot password flow)

---

### 6. CompleteProfileScreen
**Path:** `lib/presentation/auth/completeProfile/complete_profile_screen.dart`

**Purpose:** Complete user profile after OTP verification

**Features:**
- **Profile Image**: Optional image upload
- **Email Input**: Email address field
- **Full Name Input**: User's full name
- **Password Input**: With show/hide toggle
- **Image Picker**: Camera or gallery selection
- **Form Validation**: All fields validated
- **Device Token**: Sends Firebase token (or "device_token" string if unavailable)
- **Loading State**: Shows loading during account creation
- **Error Handling**: Displays error messages

**State Management:**
- `SignUpCubit` - Handles account creation

**UI Components:**
- Image picker button
- Text input fields
- Password visibility toggle
- Primary action button

**Navigation:**
- `PersonalizeProfileScreen` (after account creation)

---

### 7. PersonalizeProfileScreen
**Path:** `lib/presentation/auth/personalizeProfile/personalize_profile_screen.dart`

**Purpose:** Personalize user profile with preferences

**Features:**
- Profile customization options
- Navigation to vehicle setup

**Navigation:**
- `VehicleSetupScreen` (after personalization)

---

### 8. ForgetPasswordScreen
**Path:** `lib/presentation/auth/forgetPassword/forget_password_screen.dart`

**Purpose:** Initiate password recovery process

**Features:**
- **Phone Number Input**: With country code
- **OTP Request**: Sends OTP for password reset
- **Form Validation**: Phone number validation
- **Loading State**: Shows loading during OTP send
- **Error Handling**: Displays error messages

**State Management:**
- `SignUpCubit` - Handles password recovery flow

**Navigation:**
- `OTPVerificationScreen` (after OTP sent)

---

### 9. SetNewPasswordScreen
**Path:** `lib/presentation/auth/resetPassword/set_new_password_screen.dart`

**Purpose:** Set new password after OTP verification

**Features:**
- **New Password Input**: With show/hide toggle
- **Confirm Password Input**: With validation
- **Password Strength**: Validation rules
- **Form Validation**: Password match validation
- **Loading State**: Shows loading during password reset
- **Error Handling**: Displays error messages

**State Management:**
- `SignUpCubit` - Handles password reset

**Navigation:**
- `LoginScreen` (after successful password reset)

---

## Main Navigation Screens

### 10. MainScreen
**Path:** `lib/presentation/main/main_screen.dart`

**Purpose:** Main navigation hub with bottom navigation bar

**Features:**
- **Bottom Navigation Bar**: 5 tabs
  - Map (Index 0)
  - Wallet (Index 1)
  - Charge Button (Center FAB - Index 2)
  - History (Index 3)
  - Profile (Index 4)
- **IndexedStack**: Maintains state of all screens
- **Guest Mode Protection**: Shows guest bottom sheet for protected screens
- **Charge Button**: 
  - Validates user login
  - Checks for vehicles
  - Navigates to current vehicle charging
- **WebSocket Connection**: Initializes on screen load
- **Data Loading**: Loads vehicles and RFID cards on init

**State Management:**
- `WebSocketCubit` - WebSocket connection
- `ProfileCubit` - Profile data
- `VehiclesCubit` - Vehicle data

**UI Components:**
- Bottom navigation bar with icons
- Center floating action button (green, flash icon)
- IndexedStack for screen persistence

**Navigation:**
- `CurrentVehicleChargingScreen` (charge button)
- `MyVehiclesScreen` (if no vehicles)
- `GuestBottomSheet` (for guest users)

**Child Screens:**
- `MapScreen`
- `WalletScreen`
- `HistoryScreen`
- `ProfileScreen`

---

## Map & Station Screens

### 11. MapScreen
**Path:** `lib/presentation/map/map_screen.dart`

**Purpose:** Display charging stations on interactive map

**Features:**
- **Google Maps Integration**: Interactive map view
- **Station Markers**: Custom markers with status icons
  - Available (green)
  - Unavailable (gray)
  - In Use (orange)
- **User Location**: Shows current location with "Locate Me" button
- **Search Bar**: Navigate to search screen
- **Notifications Icon**: Access notifications (requires login)
- **Status Legend**: Collapsible card showing station statuses
- **Marker Tapping**: Shows station details bottom sheet
- **Camera Controls**: Auto-zoom and pan on map interaction
- **Loading State**: Shimmer loading while fetching stations
- **Error Handling**: Error state with retry button

**State Management:**
- `MapCubit` - Manages map state, markers, and station data
- `StationDetailsCubit` - Station details data

**UI Components:**
- Google Maps widget
- Search bar (disabled, navigates to search)
- Notifications icon
- Status legend card (collapsible)
- Locate me floating action button
- Shimmer loading widgets

**Navigation:**
- `SearchScreen` (search bar tap)
- `NotificationsScreen` (notifications icon)
- `StationDetailsBottomSheet` (marker tap)

**Data Flow:**
- Loads stations on init
- Updates markers based on station status
- Fetches station details when marker tapped

---

### 12. SearchScreen
**Path:** `lib/presentation/map/search_screen.dart`

**Purpose:** Search and filter charging stations

**Features:**
- **Search Bar**: Real-time search with debounce (300ms)
- **Filter Options**: 
  - Favorite filter (star icon)
  - Status filters (Available, Unavailable, In Use)
  - AC/DC filter
- **Station List**: Scrollable list of matching stations
- **Station Cards**: Display station info with:
  - Station name and location
  - Status badge
  - AC/DC compatibility
  - Distance from user
  - Favorite star icon
- **Empty State**: Message when no stations found
- **Loading State**: Shimmer loading while searching
- **Favorite Toggle**: Add/remove favorites (requires login)
- **Station Selection**: Navigate to station details

**State Management:**
- `SearchCubit` - Manages search state and filtering
- `MapCubit` - Provides cached station data

**UI Components:**
- Search text field
- Filter chips
- Station list cards
- Favorite toggle button
- Shimmer loading widgets

**Navigation:**
- `StationDetailsBottomSheet` (station card tap)

**Search Logic:**
- Searches station names, cities, addresses
- Debounced input (300ms delay)
- Filters by status, AC/DC compatibility
- Sorts by distance or relevance

---

### 13. StationDetailsBottomSheet
**Path:** `lib/presentation/map/station_details_bottom_sheet.dart`

**Purpose:** Display detailed information about a charging station

**Features:**
- **Station Information**:
  - Station name and address
  - Status badge (dynamic color coding)
  - AC/DC compatibility indicator
  - Distance from user
- **Image Carousel**: Station media images (if available)
- **Connectors List**: Scrollable list of available connectors
  - Connector type (AC/DC)
  - Power output
  - Availability status
  - Drag-to-close functionality
- **Action Buttons**:
  - Call station (if phone available)
  - Navigate to station (if coordinates available)
- **Favorite Toggle**: Add/remove from favorites (requires login)
- **Loading State**: Shimmer loading while fetching details
- **Error Handling**: Error state display

**State Management:**
- `StationDetailsCubit` - Manages station details data

**UI Components:**
- Bottom sheet with drag handle
- Image carousel
- Status badge
- Connector cards
- Action buttons
- Shimmer loading widgets

**Navigation:**
- Phone dialer (call button)
- Maps app (navigation button)
- `ChargerScreen` (start charging - if logged in)

**Data Flow:**
- Fetches station details on open
- Updates favorite status
- Syncs with cached station lists

---

### 14. ChargerScreen
**Path:** `lib/presentation/map/charger_screen.dart`

**Purpose:** Real-time charging session monitoring

**Features:**
- **Real-time Data**: WebSocket connection for live updates
- **Charging Metrics**:
  - Current percentage
  - Power consumption (kW)
  - Output power
  - Energy delivered (kWh)
  - Duration
  - Cost
- **Station Status**: Dynamic status badge
- **AC/DC Indicator**: Shows connector type
- **Stop Charging**: Button to end session
- **PDF Download**: Download charging report
- **Session History**: View completed session details
- **Loading State**: Shimmer loading for metrics
- **Notifications**: Real-time notifications for session updates
- **Back Navigation**: Refreshes vehicle charging screen

**State Management:**
- `WebSocketCubit` - Real-time charging data
- `ChargingCubit` - Charging session control

**UI Components:**
- Progress indicator (circular)
- Metric cards
- Status badge
- Stop button
- Download PDF button
- Shimmer loading widgets

**Navigation:**
- `CurrentVehicleChargingScreen` (back button)
- PDF viewer (download button)

**WebSocket Events:**
- Session updates (percentage, power, energy)
- Session stopped
- Notifications

---

### 15. QRCodeScannerScreen
**Path:** `lib/presentation/map/qr_code_scanner_screen.dart`

**Purpose:** Scan QR code to start charging session

**Features:**
- **QR Code Scanner**: Camera-based QR code scanning
- **QR Code Validation**: Validates scanned code format
- **Session Start**: Initiates charging session with scanned code
- **Loading State**: Shows loading during session start
- **Error Handling**: Displays error messages
- **Camera Permissions**: Handles camera permission requests

**State Management:**
- `ChargingCubit` - Handles session start

**UI Components:**
- Camera preview
- Scanning overlay
- Loading indicator

**Navigation:**
- `StartSessionScreen` (after QR scan)
- `ChargerScreen` (after session start)

---

### 16. StartSessionScreen
**Path:** `lib/presentation/map/start_session_screen.dart`

**Purpose:** Configure and start charging session

**Features:**
- **Vehicle Selection**: Dropdown to select vehicle
- **Connector Selection**: Choose connector type
- **Session Configuration**: Set charging parameters
- **Start Session**: Button to begin charging
- **Loading State**: Shows loading during session start
- **Error Handling**: 
  - 402 status: Insufficient balance → Navigate to top-up
  - Other errors: Display error message
- **Form Validation**: Validates all inputs

**State Management:**
- `ChargingCubit` - Handles session start
- `VehiclesCubit` - Vehicle list

**UI Components:**
- Vehicle dropdown
- Connector selection
- Primary action button
- Loading indicator

**Navigation:**
- `TopUpScreen` (if balance insufficient)
- `ChargerScreen` (after session start)

---

## Vehicle Management Screens

### 17. MyVehiclesScreen
**Path:** `lib/presentation/vehicles/my_vehicles_screen.dart`

**Purpose:** Display and manage user's vehicles

**Features:**
- **Vehicle List**: Scrollable list of user's vehicles
- **Vehicle Cards**: Display vehicle information:
  - Vehicle image
  - Brand and model name
  - Connector type badge
- **Add Vehicle**: Floating action button
- **Edit Vehicle**: Tap card to edit
- **Delete Vehicle**: Delete button with confirmation dialog
- **Empty State**: Message when no vehicles
- **Loading State**: Shimmer loading while fetching

**State Management:**
- `VehiclesCubit` - Manages vehicle data

**UI Components:**
- Vehicle cards
- Floating action button
- Delete confirmation dialog
- Shimmer loading widgets

**Navigation:**
- `VehicleSetupScreen` (add/edit vehicle)

---

### 18. VehicleSetupScreen
**Path:** `lib/presentation/vehicles/vehicle_setup_screen.dart`

**Purpose:** Add or edit vehicle information

**Features:**
- **Brand Selection**: Navigate to brand selection
- **Model Selection**: Choose vehicle model
- **Connector Type**: Select connector type
- **Vehicle Image**: Optional image upload
- **Form Validation**: Validates all fields
- **Save Vehicle**: Create or update vehicle
- **Loading State**: Shows loading during save
- **Error Handling**: Displays error messages

**State Management:**
- `VehiclesCubit` - Handles vehicle creation/update

**UI Components:**
- Brand/model selectors
- Connector type selector
- Image picker
- Primary action button

**Navigation:**
- `SelectBrandScreen` (brand selection)
- `MyVehiclesScreen` (after save)
- `MainScreen` (after save in signup flow)

---

### 19. SelectBrandScreen
**Path:** `lib/presentation/vehicles/select_brand_screen.dart`

**Purpose:** Select vehicle brand and model

**Features:**
- **Brand List**: List of available brands
- **Model List**: Models for selected brand
- **Search**: Search brands/models
- **Selection**: Select brand and model
- **Loading State**: Shows loading while fetching

**State Management:**
- `VehiclesCubit` - Manages brand/model data

**Navigation:**
- `VehicleSetupScreen` (after selection)

---

### 20. VehicleDetailsScreen
**Path:** `lib/presentation/vehicles/vehicle_details_screen.dart`

**Purpose:** View detailed vehicle information

**Features:**
- Vehicle details display
- Edit and delete options

**Navigation:**
- `VehicleSetupScreen` (edit)

---

### 21. CurrentVehicleChargingScreen
**Path:** `lib/presentation/vehicles/current_vehicle_charging_screen.dart`

**Purpose:** View and manage current vehicle charging sessions

**Features:**
- **Vehicle List**: List of vehicles with charging status
- **Charging Status**: Shows which vehicles are currently charging
- **Start Charging**: Button to start new session
- **View Session**: Tap to view active charging session
- **QR Scanner**: Option to scan QR code
- **Empty State**: Message when no vehicles charging
- **Loading State**: Shimmer loading while fetching
- **Pull to Refresh**: Refresh charging data
- **Session Navigation**: Navigate to charger screen for active sessions

**State Management:**
- `CurrentVehicleChargingCubit` - Manages vehicle charging data

**UI Components:**
- Vehicle charging cards
- Start charging button
- QR scanner button
- Shimmer loading widgets
- Refresh indicator

**Navigation:**
- `QRCodeScannerScreen` (scan QR)
- `ChargerScreen` (view active session)
- `StartSessionScreen` (start charging)

---

## Wallet Screens

### 22. WalletScreen
**Path:** `lib/presentation/wallet/wallet_screen.dart`

**Purpose:** Display wallet balance and transactions

**Features:**
- **Wallet Card**: 
  - User greeting
  - Balance display (with currency)
  - Top-up button
  - Manage cards button
- **Transactions List**: 
  - Transaction history
  - Transaction type (Top up, etc.)
  - Amount and currency
  - Date/time
- **Pull to Refresh**: Refresh wallet data
- **Loading State**: Shimmer loading while fetching
- **Empty State**: Message when no transactions

**State Management:**
- `WalletCubit` - Manages wallet data and transactions

**UI Components:**
- Wallet card with background image
- Transaction list items
- Top-up button
- Manage cards button
- Shimmer loading widgets

**Navigation:**
- `TopUpScreen` (top-up button)
- `ManageCardsScreen` (manage cards button)

---

### 23. TopUpScreen
**Path:** `lib/presentation/wallet/top_up_screen.dart`

**Purpose:** Add funds to wallet

**Features:**
- **Amount Input**: Enter top-up amount
- **Payment Method**: Select payment card
- **Top-up Button**: Process payment
- **Loading State**: Shows loading during payment
- **Error Handling**: Displays error messages
- **Success Handling**: Navigate after successful top-up

**State Management:**
- `WalletCubit` - Handles top-up process

**Navigation:**
- `PayUrlScreen` (payment processing)
- `WalletScreen` (after success)

---

### 24. ManageCardsScreen
**Path:** `lib/presentation/wallet/manage_cards_screen.dart`

**Purpose:** Manage saved payment cards

**Features:**
- **Cards List**: Display saved cards
- **Add Card**: Button to add new card
- **Delete Card**: Remove card option
- **Card Details**: Show card information (masked)
- **Loading State**: Shows loading while fetching

**State Management:**
- `WalletCubit` - Manages card data

**Navigation:**
- `AddCardScreen` (add card)
- `DetailsCardScreen` (view card details)

---

### 25. AddCardScreen
**Path:** `lib/presentation/wallet/add_card_screen.dart`

**Purpose:** Add new payment card

**Features:**
- **Card Number Input**: Card number field
- **Expiry Date**: Month/year input
- **CVV**: Security code input
- **Cardholder Name**: Name on card
- **Form Validation**: Validates card details
- **Save Card**: Add card to account
- **Loading State**: Shows loading during save
- **Error Handling**: Displays error messages

**State Management:**
- `WalletCubit` - Handles card addition

**Navigation:**
- `ManageCardsScreen` (after save)

---

### 26. DetailsCardScreen
**Path:** `lib/presentation/wallet/details_card_sreen.dart`

**Purpose:** View card details

**Features:**
- Card information display
- Edit and delete options

**Navigation:**
- `ManageCardsScreen` (back)

---

### 27. PayUrlScreen
**Path:** `lib/presentation/wallet/pay_url_screen.dart`

**Purpose:** Process payment via web view

**Features:**
- **Web View**: Payment gateway integration
- **Payment Processing**: Handle payment flow
- **Success/Error Handling**: Process payment results
- **Loading State**: Shows loading during payment

**Navigation:**
- `WalletScreen` (after payment)

---

## Profile Screens

### 28. ProfileScreen
**Path:** `lib/presentation/profile/profile_screen.dart`

**Purpose:** User profile management hub

**Features:**
- **Profile Card**:
  - Profile image (network or asset)
  - Full name
  - Email
  - Phone number
  - Edit button
- **Statistics**:
  - Total charges count
  - Points (currently 0)
- **Menu Items**:
  - RFID Cards
  - Settings
  - Support/Complain
  - Terms and Conditions
  - Logout
- **Logout Confirmation**: Bottom sheet confirmation
- **Version Display**: App version number
- **Loading State**: Shows loading during logout

**State Management:**
- `ProfileCubit` - Manages profile data and logout

**UI Components:**
- Profile card with image
- Statistics cards
- Menu list items
- Logout confirmation bottom sheet

**Navigation:**
- `EditProfileScreen` (edit button)
- `RFIDCardsScreen` (RFID cards)
- `SettingsScreen` (settings)
- `SupportScreen` (support)
- `TermsConditionsScreen` (terms)
- `LoginScreen` (after logout)

---

### 29. EditProfileScreen
**Path:** `lib/presentation/profile/edit_profile_screen.dart`

**Purpose:** Edit user profile information

**Features:**
- **Profile Image**: Upload new profile image
- **Full Name**: Edit name
- **Email**: Edit email (if allowed)
- **Phone Number**: View phone (read-only)
- **Save Changes**: Update profile
- **Image Picker**: Camera or gallery
- **Form Validation**: Validates inputs
- **Loading State**: Shows loading during update
- **Error Handling**: Displays error messages

**State Management:**
- `ProfileCubit` - Handles profile update

**Navigation:**
- `ProfileScreen` (after save)

---

### 30. RFIDCardsScreen
**Path:** `lib/presentation/profile/rfid_cards_screen.dart`

**Purpose:** Manage RFID cards for charging

**Features:**
- **RFID Cards List**: Display saved RFID cards
- **Add RFID Card**: Floating action button
- **Delete Card**: Remove RFID card
- **Card Details**: Show card information
- **Loading State**: Shows loading while fetching
- **Empty State**: Message when no cards

**State Management:**
- `ProfileCubit` - Manages RFID card data

**Navigation:**
- `RFIDQRScannerScreen` (add card)

---

### 31. RFIDQRScannerScreen
**Path:** `lib/presentation/profile/rfid_qr_scanner_screen.dart`

**Purpose:** Scan QR code to add RFID card

**Features:**
- **QR Code Scanner**: Camera-based scanning
- **Card Registration**: Register scanned card
- **Loading State**: Shows loading during registration
- **Error Handling**: Displays error messages

**State Management:**
- `ProfileCubit` - Handles RFID card addition

**Navigation:**
- `RFIDCardsScreen` (after registration)

---

### 32. SettingsScreen
**Path:** `lib/presentation/profile/settings_screen.dart`

**Purpose:** App settings and preferences

**Features:**
- Settings options display
- App configuration
- User preferences

**State Management:**
- `ProfileCubit` - Manages settings

---

### 33. SupportScreen
**Path:** `lib/presentation/profile/support_screen.dart`

**Purpose:** Contact support or submit complaints

**Features:**
- Support contact information
- Complaint submission form
- Help resources

**State Management:**
- `ProfileCubit` - Handles support requests

---

### 34. TermsConditionsScreen
**Path:** `lib/presentation/profile/terms_conditions_screen.dart`

**Purpose:** Display terms and conditions

**Features:**
- Terms and conditions content
- Scrollable text
- Accept/Decline options (if applicable)

---

### 35. ChangePasswordScreen
**Path:** `lib/presentation/profile/change_password_screen.dart`

**Purpose:** Change user password

**Features:**
- **Current Password**: Input current password
- **New Password**: Input new password
- **Confirm Password**: Confirm new password
- **Form Validation**: Validates all fields
- **Save Changes**: Update password
- **Loading State**: Shows loading during update
- **Error Handling**: Displays error messages

**State Management:**
- `ProfileCubit` - Handles password change

**Navigation:**
- `ProfileScreen` (after save)

---

### 36. DeleteAccountPasswordScreen
**Path:** `lib/presentation/profile/delete_account_password_screen.dart`

**Purpose:** Verify password before account deletion

**Features:**
- Password input
- Account deletion confirmation
- Loading state
- Error handling

**State Management:**
- `ProfileCubit` - Handles account deletion

---

### 37. DeleteAccountReasonScreen
**Path:** `lib/presentation/profile/delete_account_reason_screen.dart`

**Purpose:** Collect reason for account deletion

**Features:**
- Reason selection
- Additional comments
- Submit deletion request
- Loading state

**State Management:**
- `ProfileCubit` - Handles deletion reason

---

## History & Charging Screens

### 38. HistoryScreen
**Path:** `lib/presentation/history/history_screen.dart`

**Purpose:** View charging session history

**Features:**
- **Statistics Grid**: 
  - Total Energy (kWh)
  - Total Cost
  - Total Time
  - Total Sessions
- **Filters**: 
  - All sessions
  - Active sessions
  - Completed sessions
- **Sort Options**:
  - Newest
  - Oldest
  - Highest Energy
  - Lowest Energy
- **Sessions List**: 
  - Session cards with:
    - Total cost
    - Status badge (Active/Completed)
    - Date and time
    - Duration
    - Energy (kWh)
    - Station name and location
  - Tap to view session details
- **Download PDF**: Download charging history report
- **Pull to Refresh**: Refresh history data
- **Loading State**: Shimmer loading while fetching
- **Empty State**: Message when no sessions
- **Session Navigation**: Navigate to charger screen for active/completed sessions

**State Management:**
- `HistoryCubit` - Manages charging history data

**UI Components:**
- Statistics grid cards
- Filter dropdown
- Sort button
- Session cards
- Download PDF button
- Shimmer loading widgets

**Navigation:**
- `ChargerScreen` (session card tap)

**Data Flow:**
- Loads history on init
- Filters and sorts sessions
- Refreshes when returning from charger screen
- Downloads PDF report

---

## Other Screens

### 39. NotificationsScreen
**Path:** `lib/presentation/notifications/notifications_screen.dart`

**Purpose:** Display app notifications

**Features:**
- Notifications list
- Notification details
- Mark as read
- Clear notifications

**State Management:**
- Notification state management

---

### 40. NavigationScreen
**Path:** `lib/presentation/map/navigation_screen.dart`

**Purpose:** Navigate to station location

**Features:**
- Maps integration
- Turn-by-turn directions
- Navigation controls

---

## Common UI Components

### Shimmer Loading
- Used across all screens during data loading
- Provides smooth loading experience
- Customizable size and shape

### Error Handling
- Consistent error message display
- Retry functionality
- User-friendly error messages

### Empty States
- Informative messages when no data
- Call-to-action buttons
- Consistent design

### Bottom Sheets
- Station details
- Logout confirmation
- Sort options
- Filter options

### Dialogs
- Delete confirmations
- Error alerts
- Success messages

---

## State Management Architecture

### Global Providers (app_root.dart)
- `SearchCubit`
- `MapCubit`
- `StationDetailsCubit`
- `SignUpCubit`
- `ProfileCubit`
- `VehiclesCubit`
- `CurrentVehicleChargingCubit`
- `WalletCubit`
- `ChargingCubit`
- `WebSocketCubit`

### Local Providers
- `LoginCubit` (LoginScreen)
- `OnBoardingCubit` (OnboardingScreen)
- `HistoryCubit` (HistoryScreen)

---

## Navigation Patterns

### Navigation Methods
- `context.goTo()` - Push new route
- `context.goOff()` - Replace current route
- `context.goOffAll()` - Clear stack and navigate
- `Navigator.push()` - Standard navigation
- `Navigator.pushAndRemoveUntil()` - Clear stack to specific route

### Route Protection
- Guest mode checks
- Authentication validation
- Vehicle validation for charging

---

## Data Flow

### API Integration
- REST APIs for CRUD operations
- WebSocket for real-time updates
- Token-based authentication
- Error handling and retry logic

### Caching
- Station data caching
- User data caching
- Favorite status synchronization

### Real-time Updates
- WebSocket connection for charging sessions
- Live metric updates
- Session status changes
- Notifications

---

## Key Features Summary

### Authentication
- Phone/Email login
- OTP verification
- Password recovery
- Guest mode
- Device token management

### Station Discovery
- Interactive map
- Search functionality
- Filtering and sorting
- Favorite stations
- Station details

### Charging
- QR code scanning
- Session management
- Real-time monitoring
- Stop charging
- PDF reports

### Vehicle Management
- Add/Edit/Delete vehicles
- Brand and model selection
- Connector type selection

### Wallet
- Balance display
- Top-up functionality
- Payment card management
- Transaction history

### Profile
- Profile management
- RFID card management
- Settings
- Support
- Account deletion

---

**Document Generated:** January 1, 2026  
**Last Updated:** January 1, 2026

