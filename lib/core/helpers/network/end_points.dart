class EndPoints {
  static const String baseUrl = "https://dev-megaplag.tadafuq.ae";

  //! End Points
  //! Auth End Points
  static const String login = "/api/login";
  static const String register = "/api/register";
  static const String forgetPassword = "/api/password/forget";
  static const String changePassword = "/api/password/change";
  static const String refreshToken = "/api/refresh";
  static const String onBoarding = "/api/content?type=tip";
  static const String logout = "/api/logout";
  static const String sendOtp = "/api/otp/send";
  static const String verifyOtp = "/api/otp/verify";
  static const String brands = "/api/brands";
  static const String connectors = "/api/connectors";
  static String models(int id) => "/api/brands/$id/models";

  static const String getSavedCards = "/api/customer/cards/saved";
  static const String getTopUpTransactions = "/api/payments/transactions/topup";
  static const String getWalletBalance = "/api/customer/wallet";
  static const String getPayUrl = "/api/payments/generatePaymentIframe";
  static const String rfidCards = "/api/customer/rfid";
  static const String addVehicle = "/api/customer/vehicleSetUp";
  static const String getVehicles = "/api/customer/vehicles";
  static const String getMapStations =
      "/api/stations/map/nearby?lat=31.6214&lng=-55.0531&radius=5000";

  static const String getStations = "/api/stations/list";
}
