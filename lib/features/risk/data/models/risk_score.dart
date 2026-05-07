import 'package:freezed_annotation/freezed_annotation.dart';

part 'risk_score.freezed.dart';
part 'risk_score.g.dart';

@freezed
abstract class RiskScore with _$RiskScore {
  const factory RiskScore({
    required String symbol,
    @JsonKey(name: 'risk_score') required double score,
    @JsonKey(name: 'risk_level') @Default('medium') String level,
    @Default([]) List<String> factors,
    @JsonKey(name: 'fetched_at') @Default('') String updatedAt,
  }) = _RiskScore;

  factory RiskScore.fromJson(Map<String, dynamic> json) =>
      _$RiskScoreFromJson(json);
}

@freezed
abstract class PortfolioRisk with _$PortfolioRisk {
  const factory PortfolioRisk({
    @JsonKey(name: 'user_id') @Default('') String userId,
    @Default([]) List<RiskScore> positions,
  }) = _PortfolioRisk;

  factory PortfolioRisk.fromJson(Map<String, dynamic> json) =>
      _$PortfolioRiskFromJson(json);
}
