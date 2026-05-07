import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../websocket/ws_message.dart';
import '../websocket/ws_service.dart';

class WsStatusBanner extends ConsumerStatefulWidget {
  const WsStatusBanner({super.key});

  @override
  ConsumerState<WsStatusBanner> createState() => _WsStatusBannerState();
}

class _WsStatusBannerState extends ConsumerState<WsStatusBanner> {
  _BannerState _state = _BannerState.hidden;
  int _countdown = 0;
  Timer? _countdownTimer;
  Timer? _hideTimer;
  StreamSubscription<WsMessage>? _wsSub;
  bool _hasShownDisconnect = false;

  @override
  void initState() {
    super.initState();
    _wsSub = ref.read(wsServiceProvider).stream.listen(_onMessage);
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    _countdownTimer?.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _onMessage(WsMessage msg) {
    switch (msg) {
      case WsConnected():
        _showConnected();
      case WsDisconnected():
        _showDisconnected();
      default:
        break;
    }
  }

  void _showConnected() {
    if (!_hasShownDisconnect) return;
    _hasShownDisconnect = false;
    _countdownTimer?.cancel();
    _hideTimer?.cancel();
    setState(() => _state = _BannerState.connected);
    _hideTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _state = _BannerState.hidden);
    });
  }

  void _showDisconnected() {
    if (_state == _BannerState.disconnected ||
        _state == _BannerState.reconnecting) {
      return;
    }
    _hasShownDisconnect = true;
    _hideTimer?.cancel();
    _startCountdown(ref.read(wsServiceProvider).backoffSeconds);
    setState(() => _state = _BannerState.disconnected);
  }

  void _startCountdown(int seconds) {
    _countdown = seconds;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 0) {
        t.cancel();
        if (mounted) setState(() => _state = _BannerState.reconnecting);
      } else {
        if (mounted) setState(() => _countdown--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state == _BannerState.hidden) return const SizedBox.shrink();

    final (bg, text, icon) = switch (_state) {
      _BannerState.connected => (
          AppColors.profitGreen,
          'Connected',
          Icons.wifi_rounded,
        ),
      _BannerState.disconnected => (
          AppColors.warningAmber,
          'Connection lost · Reconnecting in ${_countdown}s',
          Icons.wifi_off_rounded,
        ),
      _BannerState.reconnecting => (
          AppColors.warningAmber,
          'Reconnecting…',
          Icons.wifi_tethering_rounded,
        ),
      _BannerState.hidden => (
          AppColors.profitGreen,
          '',
          Icons.wifi_rounded,
        ),
    };

    return Material(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                text,
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_state == _BannerState.reconnecting) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate(key: ValueKey(_state)).slideY(
        begin: -1, end: 0, duration: 300.ms, curve: Curves.easeOutCubic);
  }
}

enum _BannerState { hidden, connected, disconnected, reconnecting }
