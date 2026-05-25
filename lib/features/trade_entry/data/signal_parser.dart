class TradeSignalParse {
  const TradeSignalParse({
    required this.raw,
    this.symbol,
    this.baseAsset,
    this.quoteAsset,
    this.side,
    this.entryPrice,
    this.stopLoss,
    this.takeProfits = const [],
    this.leverage,
    this.marginAmount,
    this.collateralMode,
    this.warnings = const [],
    this.confidence = 0,
  });

  final String raw;
  final String? symbol;
  final String? baseAsset;
  final String? quoteAsset;
  final String? side;
  final double? entryPrice;
  final double? stopLoss;
  final List<double> takeProfits;
  final double? leverage;
  final double? marginAmount;
  final String? collateralMode;
  final List<String> warnings;
  final double confidence;

  bool get hasContent =>
      symbol != null ||
      side != null ||
      entryPrice != null ||
      stopLoss != null ||
      takeProfits.isNotEmpty ||
      leverage != null ||
      marginAmount != null ||
      collateralMode != null;

  bool get isActionable =>
      symbol != null &&
      side != null &&
      stopLoss != null &&
      takeProfits.isNotEmpty;

  List<String> get missingFields {
    final missing = <String>[];
    if (symbol == null) missing.add('trading pair');
    if (side == null) missing.add('direction');
    if (entryPrice == null) missing.add('entry');
    if (stopLoss == null) missing.add('stop loss');
    if (takeProfits.isEmpty) missing.add('take profit');
    return missing;
  }
}

TradeSignalParse parseTradeSignal(String input) {
  final raw = input.trim();
  if (raw.isEmpty) return const TradeSignalParse(raw: '');

  final normalized = _normalize(raw);
  final symbol = _parseSymbol(normalized);
  final takeProfits = _parseTakeProfits(normalized);
  final side = _parseSide(normalized, symbol?.symbol, takeProfits);
  final entry = _parseEntry(normalized);
  final stop = _parseStopLoss(normalized);
  final leverage = _parseLeverage(normalized);
  final marginAmount = _parseMarginAmount(normalized);
  final collateralMode = _parseCollateralMode(normalized);
  final warnings = <String>[
    if (entry == null)
      'No entry price found. Poise will use market price unless you add one.',
    if (leverage != null && leverage > 20)
      'High leverage detected. Review liquidation and stop-loss distance.',
    if (takeProfits.length > 3)
      'More than three take-profit levels found. Poise will apply the first two.',
  ];

  return TradeSignalParse(
    raw: raw,
    symbol: symbol?.symbol,
    baseAsset: symbol?.base,
    quoteAsset: symbol?.quote,
    side: side,
    entryPrice: entry,
    stopLoss: stop,
    takeProfits: takeProfits,
    leverage: leverage,
    marginAmount: marginAmount,
    collateralMode: collateralMode,
    warnings: warnings,
    confidence: _confidence(
      symbol: symbol?.symbol,
      side: side,
      entry: entry,
      stop: stop,
      takeProfits: takeProfits,
      leverage: leverage,
      marginAmount: marginAmount,
    ),
  );
}

String _normalize(String input) {
  return input
      .toUpperCase()
      .replaceAll('\r', '\n')
      .replaceAll(RegExp(r'[\u2013\u2014\u2212]'), '-')
      .replaceAll(RegExp(r'[ \t]+'), ' ');
}

({String symbol, String base, String quote})? _parseSymbol(String input) {
  final match = RegExp(
    r'\b([A-Z]{2,12})\s*[/\-_]?\s*(USDT|USDC|USD)\b',
  ).firstMatch(input);
  if (match == null) return null;
  final base = match.group(1)!;
  final quote = match.group(2)!;
  return (symbol: '$base$quote', base: base, quote: quote);
}

String? _parseSide(
  String input,
  String? symbol,
  List<double> takeProfits,
) {
  if (RegExp(r'\b(LONG|BUY|BULLISH)\b').hasMatch(input)) return 'long';
  if (RegExp(r'\b(SHORT|SELL|BEARISH)\b').hasMatch(input)) return 'short';

  final entry = _parseEntry(input);
  final stop = _parseStopLoss(input);
  final firstTp = takeProfits.isEmpty ? null : takeProfits.first;
  if (entry != null && stop != null && firstTp != null) {
    if (stop < entry && firstTp > entry) return 'long';
    if (stop > entry && firstTp < entry) return 'short';
  }
  return null;
}

double? _parseEntry(String input) {
  final labeled = _firstNumberAfter(
    input,
    [
      r'ENTRY(?:\s+ZONE|\s+PRICE)?',
      r'ENTRIES',
      r'ENTER',
      r'EP',
    ],
  );
  if (labeled != null) return labeled;

  final at = RegExp(r'@\s*\$?\s*([0-9][0-9,]*(?:\.\d+)?)').firstMatch(input);
  return _numberFromMatch(at);
}

double? _parseStopLoss(String input) {
  return _firstNumberAfter(
    input,
    [
      r'STOP\s*LOSS',
      r'STOP',
      r'SL',
      r'S/L',
    ],
  );
}

List<double> _parseTakeProfits(String input) {
  final values = <double>[];

  for (final match in RegExp(
    r'\b(?:'
    r'TP\s+\d{1,2}\s*[:=@\-]|'
    r'TP\d{0,2}\s*[:=@\-]?|'
    r'TAKE\s*PROFIT\s+\d{1,2}\s*[:=@\-]|'
    r'TAKE\s*PROFIT\d{0,2}\s*[:=@\-]?|'
    r'TARGET\s*[:=@\-]?|'
    r'TGT\s*[:=@\-]?'
    r')\s*\$?\s*([0-9][0-9,]*(?:\.\d+)?)',
  ).allMatches(input)) {
    final parsed = _toDouble(match.group(1));
    if (parsed != null) values.add(parsed);
  }

  for (final match in RegExp(
    r'\b(?:TARGETS|TAKE\s*PROFITS)\s*[:=@\-]?\s*([0-9][0-9,.\s/$-]+)',
  ).allMatches(input)) {
    final segment = match.group(1) ?? '';
    for (final number in _numbers(segment)) {
      values.add(number);
    }
  }

  final seen = <String>{};
  return values.where((value) {
    final key = value.toStringAsFixed(value >= 1 ? 4 : 8);
    return seen.add(key);
  }).toList();
}

double? _parseLeverage(String input) {
  final xMatch = RegExp(
    r'\b(?:LEV(?:ERAGE)?\s*[:=@\-]?\s*)?([1-9]\d{0,2})\s*X\b',
  ).firstMatch(input);
  final fromX = _numberFromMatch(xMatch);
  if (fromX != null) return fromX;

  return _firstNumberAfter(input, [r'LEV(?:ERAGE)?']);
}

double? _parseMarginAmount(String input) {
  final match = RegExp(
    r'\b(?:MARGIN|AMOUNT|SIZE|CAPITAL)\s*[:=@\-]?\s*\$?\s*([0-9][0-9,]*(?:\.\d+)?)\s*(?:USDT|USDC|USD)?\b',
  ).firstMatch(input);
  return _numberFromMatch(match);
}

String? _parseCollateralMode(String input) {
  if (RegExp(r'\bISOLATED\b').hasMatch(input)) return 'isolated';
  if (RegExp(r'\bCROSS\b').hasMatch(input)) return 'cross';
  return null;
}

double? _firstNumberAfter(String input, List<String> labels) {
  for (final label in labels) {
    final match = RegExp(
      '$label\\s*[:=@\\-]?\\s*\\\$?\\s*([0-9][0-9,]*(?:\\.\\d+)?)',
    ).firstMatch(input);
    final parsed = _numberFromMatch(match);
    if (parsed != null) return parsed;
  }
  return null;
}

Iterable<double> _numbers(String input) sync* {
  for (final match
      in RegExp(r'\$?\s*([0-9][0-9,]*(?:\.\d+)?)').allMatches(input)) {
    final value = _numberFromMatch(match);
    if (value != null) yield value;
  }
}

double? _numberFromMatch(RegExpMatch? match) {
  if (match == null || match.groupCount < 1) return null;
  return _toDouble(match.group(1));
}

double? _toDouble(String? raw) {
  if (raw == null) return null;
  return double.tryParse(raw.replaceAll(',', '').trim());
}

double _confidence({
  required String? symbol,
  required String? side,
  required double? entry,
  required double? stop,
  required List<double> takeProfits,
  required double? leverage,
  required double? marginAmount,
}) {
  var score = 0.0;
  if (symbol != null) score += 0.25;
  if (side != null) score += 0.15;
  if (entry != null) score += 0.15;
  if (stop != null) score += 0.15;
  if (takeProfits.isNotEmpty) score += 0.15;
  if (leverage != null) score += 0.1;
  if (marginAmount != null) score += 0.05;
  return score.clamp(0, 1);
}
