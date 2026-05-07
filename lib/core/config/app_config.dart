abstract final class AppConfig {
  static const String baseUrl = 'https://poiseai.brainpad.me/api/v1';
  static const String wsUrl = 'wss://poiseai.brainpad.me/api/v1/ws';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // JWT proactive refresh window (refresh 5 min before expiry)
  static const Duration tokenRefreshLeadTime = Duration(minutes: 5);

  // WebSocket reconnect bounds
  static const Duration wsReconnectInitial = Duration(seconds: 1);
  static const Duration wsReconnectMax = Duration(seconds: 60);

  // Pagination
  static const int defaultPageSize = 20;

  // AI chat
  static const String aiChatPath = '/ai/chat';
  static const String aiSessionsPath = '/ai/sessions';
}
