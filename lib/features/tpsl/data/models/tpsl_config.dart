// Models for Take-Profit / Stop-Loss configuration.
// Plain Dart classes (no freezed) — no build_runner needed.

class TpSlConfig {
  TpSlConfig({this.tpLevels = const [], this.slConfig});

  factory TpSlConfig.fromJson(Map<String, dynamic> json) => TpSlConfig(
        tpLevels: ((json['tp_levels'] as List<dynamic>?) ?? [])
            .whereType<Map<String, dynamic>>()
            .map(TpLevel.fromJson)
            .toList(),
        slConfig: json['sl_config'] != null
            ? SlConfig.fromJson(json['sl_config'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'tp_levels': tpLevels.map((l) => l.toJson()).toList(),
        if (slConfig != null) 'sl_config': slConfig!.toJson(),
      };

  final List<TpLevel> tpLevels;
  final SlConfig? slConfig;
}

class TpLevel {
  TpLevel({
    required this.positionId,
    required this.level,
    this.targetType = 'price',
    required this.targetValue,
    this.closePercent = 100.0,
  });

  factory TpLevel.fromJson(Map<String, dynamic> json) => TpLevel(
        positionId: json['position_id'] as String? ?? '',
        level: json['level'] as int? ?? 1,
        targetType: json['target_type'] as String? ?? 'price',
        targetValue: (json['target_value'] as num?)?.toDouble() ?? 0.0,
        closePercent: (json['close_percent'] as num?)?.toDouble() ?? 100.0,
      );

  Map<String, dynamic> toJson() => {
        'position_id': positionId,
        'level': level,
        'target_type': targetType,
        'target_value': targetValue,
        'close_percent': closePercent,
      };

  final String positionId;
  final int level;
  final String targetType; // 'price' | 'percent_pnl' | 'usd_pnl'
  final double targetValue;
  final double closePercent; // % of position to close at this level

  TpLevel copyWith({
    String? positionId,
    int? level,
    String? targetType,
    double? targetValue,
    double? closePercent,
  }) =>
      TpLevel(
        positionId: positionId ?? this.positionId,
        level: level ?? this.level,
        targetType: targetType ?? this.targetType,
        targetValue: targetValue ?? this.targetValue,
        closePercent: closePercent ?? this.closePercent,
      );
}

class SlConfig {
  SlConfig({
    required this.positionId,
    this.type = 'price',
    this.value = 0.0,
    this.price = 0.0,
    this.isTrailing = false,
    this.trailingValue,
  });

  factory SlConfig.fromJson(Map<String, dynamic> json) => SlConfig(
        positionId: json['position_id'] as String? ?? '',
        type: json['type'] as String? ?? 'price',
        value: (json['value'] as num?)?.toDouble() ?? 0.0,
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        isTrailing: json['is_trailing'] as bool? ?? false,
        trailingValue: (json['trailing_value'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'position_id': positionId,
        'type': type,
        'value': value,
        'price': price,
        'is_trailing': isTrailing,
        if (trailingValue != null) 'trailing_value': trailingValue,
      };

  final String positionId;
  final String type; // 'price' | 'percent_entry' | 'usd_loss'
  final double value;
  final double price;
  final bool isTrailing;
  final double? trailingValue;

  SlConfig copyWith({
    String? positionId,
    String? type,
    double? value,
    double? price,
    bool? isTrailing,
    double? trailingValue,
  }) =>
      SlConfig(
        positionId: positionId ?? this.positionId,
        type: type ?? this.type,
        value: value ?? this.value,
        price: price ?? this.price,
        isTrailing: isTrailing ?? this.isTrailing,
        trailingValue: trailingValue ?? this.trailingValue,
      );
}
