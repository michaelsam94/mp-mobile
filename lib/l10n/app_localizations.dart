import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'MegaPlug'**
  String get appName;

  /// No description provided for @poweredByTadafuq.
  ///
  /// In en, this message translates to:
  /// **'powered by Tadafuq'**
  String get poweredByTadafuq;

  /// No description provided for @noOnboardingData.
  ///
  /// In en, this message translates to:
  /// **'No onboarding data available'**
  String get noOnboardingData;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mega Plug charging journey.'**
  String get welcomeSubtitle;

  /// No description provided for @phoneEmail.
  ///
  /// In en, this message translates to:
  /// **'Phone / E-mail'**
  String get phoneEmail;

  /// No description provided for @phoneEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Phone or e-mail'**
  String get phoneEmailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'xxxxxxxxxxx'**
  String get passwordHint;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @loginSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Login Successfully'**
  String get loginSuccessfully;

  /// No description provided for @pleaseEnterPhoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone or email'**
  String get pleaseEnterPhoneOrEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter valid number'**
  String get enterValidNumber;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinChars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinChars;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeProfile;

  /// No description provided for @profileDataProtected.
  ///
  /// In en, this message translates to:
  /// **'Only you have access to your personal data, it\'s fully protected.'**
  String get profileDataProtected;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameHint;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get emailHint;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @passwordMustBe6Digits.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 digits'**
  String get passwordMustBe6Digits;

  /// No description provided for @createdAccountSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Created Account Successfully'**
  String get createdAccountSuccessfully;

  /// No description provided for @personalizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize your charging with your vehicle info'**
  String get personalizeTitle;

  /// No description provided for @personalizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adding your car ensures accurate charging station recommendations.'**
  String get personalizeSubtitle;

  /// No description provided for @addLater.
  ///
  /// In en, this message translates to:
  /// **'Add Later'**
  String get addLater;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @createStrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password to secure your account.'**
  String get createStrongPassword;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPassword;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @enterValidPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid password'**
  String get enterValidPassword;

  /// No description provided for @pleaseEnterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Confirm Password'**
  String get pleaseEnterConfirmPassword;

  /// No description provided for @pleaseEnterValidConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid Confirm password'**
  String get pleaseEnterValidConfirmPassword;

  /// No description provided for @passwordNotSame.
  ///
  /// In en, this message translates to:
  /// **'Password not same as confirm password'**
  String get passwordNotSame;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password Changed Successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get letsGetStarted;

  /// No description provided for @guestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please create an account or log in to continue'**
  String get guestSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAccount;

  /// No description provided for @pleaseAddVehicle.
  ///
  /// In en, this message translates to:
  /// **'Please add vehicle'**
  String get pleaseAddVehicle;

  /// No description provided for @searchYourModel.
  ///
  /// In en, this message translates to:
  /// **'Search your Model'**
  String get searchYourModel;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @inUse.
  ///
  /// In en, this message translates to:
  /// **'In Use'**
  String get inUse;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @charged.
  ///
  /// In en, this message translates to:
  /// **'Charged'**
  String get charged;

  /// No description provided for @charging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get charging;

  /// No description provided for @powerConsumption.
  ///
  /// In en, this message translates to:
  /// **'Power Consumption'**
  String get powerConsumption;

  /// No description provided for @costConsumption.
  ///
  /// In en, this message translates to:
  /// **'Cost consumption'**
  String get costConsumption;

  /// No description provided for @chargingTime.
  ///
  /// In en, this message translates to:
  /// **'Charging time'**
  String get chargingTime;

  /// No description provided for @outputPower.
  ///
  /// In en, this message translates to:
  /// **'Output power from gun'**
  String get outputPower;

  /// No description provided for @downloadReport.
  ///
  /// In en, this message translates to:
  /// **'Download Report (PDF)'**
  String get downloadReport;

  /// No description provided for @pdfDownloadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PDF downloaded successfully'**
  String get pdfDownloadedSuccessfully;

  /// No description provided for @pdfUrlNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'PDF URL not available'**
  String get pdfUrlNotAvailable;

  /// No description provided for @failedToDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to download PDF'**
  String get failedToDownloadPdf;

  /// No description provided for @stopChargingTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop Charging?'**
  String get stopChargingTitle;

  /// No description provided for @areYouSureStopCharging.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop charging?'**
  String get areYouSureStopCharging;

  /// No description provided for @networkIssue.
  ///
  /// In en, this message translates to:
  /// **'Network Issue'**
  String get networkIssue;

  /// No description provided for @connectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection lost. Please check your internet connection and try again.'**
  String get connectionLost;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @stationDetails.
  ///
  /// In en, this message translates to:
  /// **'Station Details'**
  String get stationDetails;

  /// No description provided for @opens24Hours.
  ///
  /// In en, this message translates to:
  /// **'Opens 24 hours'**
  String get opens24Hours;

  /// No description provided for @connectorsTypes.
  ///
  /// In en, this message translates to:
  /// **'Connectors Types'**
  String get connectorsTypes;

  /// No description provided for @noConnectorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No connectors available'**
  String get noConnectorsAvailable;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @couldNotOpenGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not open Google Maps'**
  String get couldNotOpenGoogleMaps;

  /// No description provided for @priceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Price not available'**
  String get priceNotAvailable;

  /// No description provided for @totalCharges.
  ///
  /// In en, this message translates to:
  /// **'Total Charges'**
  String get totalCharges;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @rfidCards.
  ///
  /// In en, this message translates to:
  /// **'RFID Cards'**
  String get rfidCards;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @supportComplain.
  ///
  /// In en, this message translates to:
  /// **'Support/complain'**
  String get supportComplain;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsConditions;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @areYouSureLogOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogOut;

  /// No description provided for @editText.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editText;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @myVehicle.
  ///
  /// In en, this message translates to:
  /// **'My Vehicle'**
  String get myVehicle;

  /// No description provided for @loyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get loyaltyPoints;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @selectYourBirthday.
  ///
  /// In en, this message translates to:
  /// **'Select your birthday'**
  String get selectYourBirthday;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @pleaseSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get pleaseSelectGender;

  /// No description provided for @pleaseSelectBirthday.
  ///
  /// In en, this message translates to:
  /// **'Please select your birthday'**
  String get pleaseSelectBirthday;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @enterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter old password'**
  String get enterOldPassword;

  /// No description provided for @pleaseEnterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your old password'**
  String get pleaseEnterOldPassword;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccessfully2.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully2;

  /// No description provided for @failedToChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get failedToChangePassword;

  /// No description provided for @changePasswordBtn.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordBtn;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @noRFIDCardsAdded.
  ///
  /// In en, this message translates to:
  /// **'No RFID Cards Added Please Add One'**
  String get noRFIDCardsAdded;

  /// No description provided for @addRFIDCard.
  ///
  /// In en, this message translates to:
  /// **'Add RFID Card'**
  String get addRFIDCard;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// No description provided for @scanQRCodeInfo.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code on your RFID card for instant registration'**
  String get scanQRCodeInfo;

  /// No description provided for @enterYourRFIDCards.
  ///
  /// In en, this message translates to:
  /// **'Enter your RFID Cards'**
  String get enterYourRFIDCards;

  /// No description provided for @pleaseEnterRFIDNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your RFID card number'**
  String get pleaseEnterRFIDNumber;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @rfidCardAdded.
  ///
  /// In en, this message translates to:
  /// **'RFID card added successfully'**
  String get rfidCardAdded;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Your account ?'**
  String get deleteYourAccount;

  /// No description provided for @deleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Can you please share to us what was not working? We are fixing bugs as soon as we spot them. If something slipped through our fingers, we\'d be so grateful to be aware of it and fix it.'**
  String get deleteAccountDesc;

  /// No description provided for @explanationOptional.
  ///
  /// In en, this message translates to:
  /// **'Your explanation is entirely optional...'**
  String get explanationOptional;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your Password'**
  String get enterYourPassword;

  /// No description provided for @deleteAccountPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Confirm your identity by entering your password. You can\'t recover your account once it\'s deleted.'**
  String get deleteAccountPasswordDesc;

  /// No description provided for @areYouSureDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get areYouSureDeleteAccount;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted Successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @addCredit.
  ///
  /// In en, this message translates to:
  /// **'Add Credit'**
  String get addCredit;

  /// No description provided for @manageCards.
  ///
  /// In en, this message translates to:
  /// **'Manage Cards'**
  String get manageCards;

  /// No description provided for @creditAdded.
  ///
  /// In en, this message translates to:
  /// **'Credit Added'**
  String get creditAdded;

  /// No description provided for @chargingSession.
  ///
  /// In en, this message translates to:
  /// **'Charging Session'**
  String get chargingSession;

  /// No description provided for @topUpBalance.
  ///
  /// In en, this message translates to:
  /// **'Top-up Balance'**
  String get topUpBalance;

  /// No description provided for @selectAmount.
  ///
  /// In en, this message translates to:
  /// **'Select Amount'**
  String get selectAmount;

  /// No description provided for @customAmount.
  ///
  /// In en, this message translates to:
  /// **'Custom Amount'**
  String get customAmount;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @newCard.
  ///
  /// In en, this message translates to:
  /// **'New Card'**
  String get newCard;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful!'**
  String get paymentSuccessful;

  /// No description provided for @defaultText.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultText;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotificationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No notifications available'**
  String get noNotificationsAvailable;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @myVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehicles;

  /// No description provided for @vehicleDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Vehicle deleted successfully'**
  String get vehicleDeletedSuccessfully;

  /// No description provided for @deleteVehicle.
  ///
  /// In en, this message translates to:
  /// **'Delete Vehicle'**
  String get deleteVehicle;

  /// No description provided for @areYouSureDeleteVehicle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle? This action cannot be undone.'**
  String get areYouSureDeleteVehicle;

  /// No description provided for @noVehiclesFound.
  ///
  /// In en, this message translates to:
  /// **'No Vehicles Found, Please add your first vehicle'**
  String get noVehiclesFound;

  /// No description provided for @addYourCarDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Your Car Details'**
  String get addYourCarDetails;

  /// No description provided for @vehicleRegistrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your vehicle\'s license plate number to complete registration.'**
  String get vehicleRegistrationSubtitle;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @selectVehicleBrand.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle Brand'**
  String get selectVehicleBrand;

  /// No description provided for @pleaseSelectBrand.
  ///
  /// In en, this message translates to:
  /// **'Please select a brand'**
  String get pleaseSelectBrand;

  /// No description provided for @plateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get plateNumber;

  /// No description provided for @enterPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your plate number here'**
  String get enterPlateNumber;

  /// No description provided for @pleaseEnterPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your plate number'**
  String get pleaseEnterPlateNumber;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearLabel;

  /// No description provided for @enterYear.
  ///
  /// In en, this message translates to:
  /// **'Enter year (e.g., 2023)'**
  String get enterYear;

  /// No description provided for @pleaseEnterYear.
  ///
  /// In en, this message translates to:
  /// **'Please enter year'**
  String get pleaseEnterYear;

  /// No description provided for @pleaseEnterValidYear.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid year'**
  String get pleaseEnterValidYear;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @enterColor.
  ///
  /// In en, this message translates to:
  /// **'Enter color (e.g., Red)'**
  String get enterColor;

  /// No description provided for @pleaseEnterColor.
  ///
  /// In en, this message translates to:
  /// **'Please enter color'**
  String get pleaseEnterColor;

  /// No description provided for @takePictureVehicle.
  ///
  /// In en, this message translates to:
  /// **'Take picture of vehicle licence'**
  String get takePictureVehicle;

  /// No description provided for @earn100Points.
  ///
  /// In en, this message translates to:
  /// **'( Earn 100 loyalty point )'**
  String get earn100Points;

  /// No description provided for @modelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelLabel;

  /// No description provided for @selectVehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle Model'**
  String get selectVehicleModel;

  /// No description provided for @pleaseSelectModel.
  ///
  /// In en, this message translates to:
  /// **'Please select a model'**
  String get pleaseSelectModel;

  /// No description provided for @connectors.
  ///
  /// In en, this message translates to:
  /// **'Connectors'**
  String get connectors;

  /// No description provided for @selectConnectors.
  ///
  /// In en, this message translates to:
  /// **'Select Connectors'**
  String get selectConnectors;

  /// No description provided for @pleaseSelectConnector.
  ///
  /// In en, this message translates to:
  /// **'Please select a connector'**
  String get pleaseSelectConnector;

  /// No description provided for @updateVehicle.
  ///
  /// In en, this message translates to:
  /// **'Update Vehicle'**
  String get updateVehicle;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// No description provided for @vehicleUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Vehicle updated successfully'**
  String get vehicleUpdatedSuccessfully;

  /// No description provided for @vehicleAdded.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Added'**
  String get vehicleAdded;

  /// No description provided for @yourEvIsSetUp.
  ///
  /// In en, this message translates to:
  /// **'Your EV is now set up'**
  String get yourEvIsSetUp;

  /// No description provided for @congratsEarned.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You\'ve earned'**
  String get congratsEarned;

  /// No description provided for @forAddingPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'for adding your plate number'**
  String get forAddingPlateNumber;

  /// Sign up screen greeting
  ///
  /// In en, this message translates to:
  /// **'Hello there'**
  String get signUpTitle;

  /// Sign up screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we\'ll send you an OTP code to verify your account.'**
  String get signUpSubtitle;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Mobile Number'**
  String get enterMobileNumber;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as a guest'**
  String get continueAsGuest;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP Sent Successfully'**
  String get otpSentSuccess;

  /// No description provided for @otpVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP Verified Successfully'**
  String get otpVerifiedSuccess;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP code verification'**
  String get otpVerificationTitle;

  /// No description provided for @otpSentToPhone.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 5-digit code to your mobile\nnumber +20 XXXXX X{lastDigits}'**
  String otpSentToPhone(String lastDigits);

  /// No description provided for @otpSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 5-digit code to your email\n{maskedEmail}'**
  String otpSentToEmail(String maskedEmail);

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'You can resend code in '**
  String get resendCodeIn;

  /// No description provided for @resendCodeNow.
  ///
  /// In en, this message translates to:
  /// **'You can resend code '**
  String get resendCodeNow;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we will send you an OTP code to reset your password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get orText;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @connectVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect your'**
  String get connectVehicleTitle;

  /// No description provided for @connectVehicleHighlight.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get connectVehicleHighlight;

  /// No description provided for @connectVehicleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Insert the charging cable into your vehicle and press '**
  String get connectVehicleSubtitle;

  /// No description provided for @startCharging.
  ///
  /// In en, this message translates to:
  /// **'Start Charging'**
  String get startCharging;

  /// No description provided for @connectVehicleSubtitleEnd.
  ///
  /// In en, this message translates to:
  /// **' to continue.'**
  String get connectVehicleSubtitleEnd;

  /// No description provided for @connectorTip.
  ///
  /// In en, this message translates to:
  /// **'Make sure the connector is fully secured.'**
  String get connectorTip;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @noRfidError.
  ///
  /// In en, this message translates to:
  /// **'No default RFID card found. Please add an RFID card.'**
  String get noRfidError;

  /// No description provided for @findCodeToScan.
  ///
  /// In en, this message translates to:
  /// **'Find a code to scan'**
  String get findCodeToScan;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOccurred;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get noInternetConnection;

  /// No description provided for @stopCharging.
  ///
  /// In en, this message translates to:
  /// **'Stop Charging'**
  String get stopCharging;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @chargingHistory.
  ///
  /// In en, this message translates to:
  /// **'Charging History'**
  String get chargingHistory;

  /// No description provided for @totalEnergy.
  ///
  /// In en, this message translates to:
  /// **'Total Energy'**
  String get totalEnergy;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessions;

  /// No description provided for @noSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No sessions found'**
  String get noSessionsFound;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// No description provided for @highestEnergy.
  ///
  /// In en, this message translates to:
  /// **'Highest Energy'**
  String get highestEnergy;

  /// No description provided for @lowestEnergy.
  ///
  /// In en, this message translates to:
  /// **'Lowest Energy'**
  String get lowestEnergy;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @searchStationsHint.
  ///
  /// In en, this message translates to:
  /// **'Search stations, cities, addresses...'**
  String get searchStationsHint;

  /// No description provided for @noStationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No stations available'**
  String get noStationsAvailable;

  /// No description provided for @noStationsFound.
  ///
  /// In en, this message translates to:
  /// **'No stations found for \"{query}\"'**
  String noStationsFound(String query);

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @failedToUpdateFavorite.
  ///
  /// In en, this message translates to:
  /// **'Failed to update favorite, please try again later'**
  String get failedToUpdateFavorite;

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String kmAway(String distance);

  /// No description provided for @gunsCount.
  ///
  /// In en, this message translates to:
  /// **'Guns: {count}'**
  String gunsCount(String count);

  /// No description provided for @availableGunsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Guns: '**
  String get availableGunsLabel;

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter By'**
  String get filterBy;

  /// No description provided for @stationStatus.
  ///
  /// In en, this message translates to:
  /// **'Station Status'**
  String get stationStatus;

  /// No description provided for @connectorType.
  ///
  /// In en, this message translates to:
  /// **'Connector Type'**
  String get connectorType;

  /// No description provided for @favouriteStations.
  ///
  /// In en, this message translates to:
  /// **'Favourite Stations'**
  String get favouriteStations;

  /// No description provided for @favouriteOnly.
  ///
  /// In en, this message translates to:
  /// **'Favourite Only'**
  String get favouriteOnly;

  /// No description provided for @minimumPower.
  ///
  /// In en, this message translates to:
  /// **'Minimum Power'**
  String get minimumPower;

  /// No description provided for @selectMinimumPower.
  ///
  /// In en, this message translates to:
  /// **'Select minimum power'**
  String get selectMinimumPower;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get resetAll;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @deactivated.
  ///
  /// In en, this message translates to:
  /// **'Deactivated'**
  String get deactivated;

  /// No description provided for @cardDetails.
  ///
  /// In en, this message translates to:
  /// **'Card Details'**
  String get cardDetails;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @setAsDefaultCard.
  ///
  /// In en, this message translates to:
  /// **'Set as Default Card'**
  String get setAsDefaultCard;

  /// No description provided for @deleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete Card'**
  String get deleteCard;

  /// No description provided for @areYouSureDeleteCard.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this card?'**
  String get areYouSureDeleteCard;

  /// No description provided for @cantDeleteCard.
  ///
  /// In en, this message translates to:
  /// **'Can\'t delete this card, please try again'**
  String get cantDeleteCard;

  /// No description provided for @cantDeactivateCard.
  ///
  /// In en, this message translates to:
  /// **'Can\'t deactivate this card, please try again'**
  String get cantDeactivateCard;

  /// No description provided for @cantSetDefaultCard.
  ///
  /// In en, this message translates to:
  /// **'Can\'t set default for this card, please try again'**
  String get cantSetDefaultCard;

  /// No description provided for @failedToLoadSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings'**
  String get failedToLoadSettings;

  /// No description provided for @noSupportInfoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No support information available'**
  String get noSupportInfoAvailable;

  /// No description provided for @noRfidCardFound.
  ///
  /// In en, this message translates to:
  /// **'No RFID Card found'**
  String get noRfidCardFound;

  /// No description provided for @codeIsInvalid.
  ///
  /// In en, this message translates to:
  /// **'Code is invalid'**
  String get codeIsInvalid;

  /// No description provided for @invalidQrCodeFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code format'**
  String get invalidQrCodeFormat;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @currentVehicleCharging.
  ///
  /// In en, this message translates to:
  /// **'Current Vehicle Charging'**
  String get currentVehicleCharging;

  /// No description provided for @chargingStoppedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Charging stopped successfully'**
  String get chargingStoppedSuccessfully;

  /// No description provided for @sessionIdNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Session ID not available'**
  String get sessionIdNotAvailable;

  /// No description provided for @missingChargingSessionData.
  ///
  /// In en, this message translates to:
  /// **'Missing charging session data'**
  String get missingChargingSessionData;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @complain.
  ///
  /// In en, this message translates to:
  /// **'Complain'**
  String get complain;

  /// No description provided for @complaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaint Title'**
  String get complaintTitle;

  /// No description provided for @complaintDescription.
  ///
  /// In en, this message translates to:
  /// **'Description of the complaint'**
  String get complaintDescription;

  /// No description provided for @sendComplain.
  ///
  /// In en, this message translates to:
  /// **'Send Complain'**
  String get sendComplain;

  /// No description provided for @supportAndComplain.
  ///
  /// In en, this message translates to:
  /// **'Support and complain'**
  String get supportAndComplain;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @noTermsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No terms and conditions available'**
  String get noTermsAvailable;

  /// No description provided for @myVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'My Vehicle'**
  String get myVehicleTitle;

  /// No description provided for @licensePlate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// No description provided for @vehicleSpecifications.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Specifications'**
  String get vehicleSpecifications;

  /// No description provided for @plateNumber2.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get plateNumber2;

  /// No description provided for @scanRfidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan RFID Card QR Code'**
  String get scanRfidQrCode;

  /// No description provided for @cardholderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder name'**
  String get cardholderName;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @setAsDefaultCard2.
  ///
  /// In en, this message translates to:
  /// **'Set as default card'**
  String get setAsDefaultCard2;

  /// No description provided for @saveCard.
  ///
  /// In en, this message translates to:
  /// **'Save Card'**
  String get saveCard;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
