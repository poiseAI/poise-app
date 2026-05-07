abstract final class Routes {
  // Auth
  static const welcome = '/auth/welcome';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const riskAppetite = '/onboarding/risk-appetite';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';

  // Main shell tabs
  static const home = '/app/home';
  static const trade = '/app/trade';
  static const ai = '/app/ai';
  static const notifications = '/app/notifications';
  static const orders = '/app/orders';
  static const profile = '/app/profile';

  // Full-screen overlays (no bottom nav)
  static const positionExit = '/app/position/:id/exit';
  static const positionExitOtp = '/app/position/:id/exit/otp';
  static const positionTpsl = '/app/position/:id/tpsl';
  static const tradePreview = '/app/trade/preview';

  // Helpers
  static String positionExitPath(String id) => '/app/position/$id/exit';
  static String positionExitOtpPath(String id) => '/app/position/$id/exit/otp';
  static String positionTpslPath(String id) => '/app/position/$id/tpsl';
}
