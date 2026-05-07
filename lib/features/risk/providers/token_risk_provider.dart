import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/interceptors/auth_interceptor.dart';
import '../data/risk_api.dart';
import '../data/models/risk_score.dart';

part 'token_risk_provider.g.dart';

@riverpod
Future<RiskScore> tokenRisk(Ref ref, String symbol) async {
  ref.watch(authInvalidatedProvider);
  final result = await ref.read(riskApiProvider).getTokenRisk(symbol);
  return result.fold(
    onOk: (r) => r,
    onErr: (e) => throw e,
  );
}
