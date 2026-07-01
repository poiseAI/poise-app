abstract final class Routes {
  // Auth
  static const welcome = '/auth/welcome';
  static const welcomeBack = '/auth/welcome?from=back';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const verifyEmail = '/auth/verify-email';
  static const verifyEmailSuccess = '/onboarding/verify-email-success';
  static const riskAppetite = '/onboarding/risk-appetite';
  static const baselineSync = '/app/exchange/baseline-sync';
  static const legacyBaselineSync = '/onboarding/baseline-sync';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';

  // Main shell tabs
  static const home = '/app/home';
  static const trade = '/app/trade';
  static const ai = '/app/ai';
  static const notifications = '/app/notifications';
  static const orders = '/app/orders';
  static const profile = '/app/profile';
  static const security = '/app/profile/security';
  static const notificationSettings = '/app/profile/notification-settings';
  static const dataPrivacy = '/app/profile/data-privacy';
  static const exchangeConnections = '/app/profile/exchange-connections';
  static const billing = '/app/profile/billing';
  static const billingSuccess = '/billing/success';

  // Full-screen overlays (no bottom nav)
  static const positionExit = '/app/position/:id/exit';
  static const positionExitOtp = '/app/position/:id/exit/otp';
  static const tradeValidation = '/app/trade/validation';

  // Helpers
  static String positionExitPath(String id) => '/app/position/$id/exit';
  static String positionExitOtpPath(String id) => '/app/position/$id/exit/otp';
}
