class EndPoints {
  static const String baseUrl = "https://dev-megaplag.tadafuq.ae";

  //! End Points
  //! Auth End Points
  static const String login = "/api/login";
  static const String register = "/api/register";
  static const String forgetPassword = "/api/password/forget";
  static const String changePassword = "/api/profile/password/change";
  static const String resetPassword = "/api/password/change";
  static const String refreshToken = "/api/refresh";
  static const String onBoarding = "/api/content?type=tip";
  static const String logout = "/api/logout";
  static const String sendOtp = "/api/otp/send";
  static const String verifyOtp = "/api/otp/verify";
  static const String brands = "/api/brands";
  static const String connectors = "/api/connectors";
  static String models(int id) => "/api/brands/$id/models";

  static String deactivateSavedCards(int id) =>
      "/api/customer/cards/$id/deactivate";
  static String setDefaultSavedCards(int id) =>
      "/api/customer/cards/$id/setDefault";
  static const String deleteSavedCards = "/api/customer/cards/";
  static const String getSavedCards = "/api/customer/cards/saved";
  static const String getTopUpTransactions = "/api/payments/transactions/topup";
  static const String getWalletBalance = "/api/customer/wallet";
  static const String getPayUrl = "/api/payments/generatePaymentIframe";
  static const String rfidCards = "/api/customer/rfid";
  static const String addVehicle = "/api/customer/vehicleSetUp";
  static const String getVehicles = "/api/customer/vehicles";
  static String updateVehicle(int id) => "/api/customer/vehicles/$id";
  static String deleteVehicle(int id) => "/api/customer/vehicles/$id";
  static String getMapStations(double lat, double long) =>
      "/api/stations/map/nearby?lat=$lat&lng=$long&radius=5000";

  static const String getStations = "/api/stations/list";
  static String getStationDetails(int id) => "/api/stations/$id/details";

  static const String startCharging = "/api/charging/start";
  static const String stopCharging = "/api/charging/stop";
  static const String chargingHistory = '/api/charging/history';
  static const String chargingPdf = '/api/charging/chargingPdf?list=1';
  static String chargingPdfBySessionId(int sessionId) => '/api/charging/chargingPdf?list=0&id=$sessionId';
  static const String currentCharging = '/api/customer/vehicles/charging';
  static String currentChargingWithSession(int sessionId) => '/api/charging/$sessionId/current';
  static const String updateProfile = "/api/profile";
  static const String getSettings = "/api/settings";
}
