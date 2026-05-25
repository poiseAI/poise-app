// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trade_form_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TradeFormState {
  TradingSymbol? get symbol;
  OrderType get orderType;
  OrderSide get side;
  CollateralMode get collateralMode;
  AmountInputMode get amountInputMode;
  double get quantity;
  double? get limitPrice;
  MarginMode get marginMode;
  double get marginValue;
  double get availableBalance;
  String get balanceCurrency;
  double get leverage;
  double? get takeProfit1;
  double? get takeProfit2;
  double? get slPrice;
  bool get autoStopLossProgression;
  RiskScore? get riskScore;
  TradePreflight? get preflight;
  TradeValidationResult? get validation;
  bool get isLoadingPreflight;
  bool get isValidating;
  bool get isSubmitting;
  String? get preflightError;
  String? get validationError;
  String? get submitError;
  Order? get lastOrder;
  bool get symbolTouched;
  bool get orderTypeTouched;
  bool get amountTouched;
  bool get collateralModeTouched;
  bool get leverageTouched;
  bool get directionTouched;
  bool get exitPlanTouched;
  String get signalText;
  TradeSignalParse? get parsedSignal;
  bool get isApplyingSignal;
  String? get signalError;

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TradeFormStateCopyWith<TradeFormState> get copyWith =>
      _$TradeFormStateCopyWithImpl<TradeFormState>(
          this as TradeFormState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TradeFormState &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.collateralMode, collateralMode) ||
                other.collateralMode == collateralMode) &&
            (identical(other.amountInputMode, amountInputMode) ||
                other.amountInputMode == amountInputMode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.limitPrice, limitPrice) ||
                other.limitPrice == limitPrice) &&
            (identical(other.marginMode, marginMode) ||
                other.marginMode == marginMode) &&
            (identical(other.marginValue, marginValue) ||
                other.marginValue == marginValue) &&
            (identical(other.availableBalance, availableBalance) ||
                other.availableBalance == availableBalance) &&
            (identical(other.balanceCurrency, balanceCurrency) ||
                other.balanceCurrency == balanceCurrency) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            (identical(other.takeProfit1, takeProfit1) ||
                other.takeProfit1 == takeProfit1) &&
            (identical(other.takeProfit2, takeProfit2) ||
                other.takeProfit2 == takeProfit2) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(
                    other.autoStopLossProgression, autoStopLossProgression) ||
                other.autoStopLossProgression == autoStopLossProgression) &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.preflight, preflight) ||
                other.preflight == preflight) &&
            (identical(other.validation, validation) ||
                other.validation == validation) &&
            (identical(other.isLoadingPreflight, isLoadingPreflight) ||
                other.isLoadingPreflight == isLoadingPreflight) &&
            (identical(other.isValidating, isValidating) ||
                other.isValidating == isValidating) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.preflightError, preflightError) ||
                other.preflightError == preflightError) &&
            (identical(other.validationError, validationError) ||
                other.validationError == validationError) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError) &&
            (identical(other.lastOrder, lastOrder) ||
                other.lastOrder == lastOrder) &&
            (identical(other.symbolTouched, symbolTouched) ||
                other.symbolTouched == symbolTouched) &&
            (identical(other.orderTypeTouched, orderTypeTouched) ||
                other.orderTypeTouched == orderTypeTouched) &&
            (identical(other.amountTouched, amountTouched) ||
                other.amountTouched == amountTouched) &&
            (identical(other.collateralModeTouched, collateralModeTouched) ||
                other.collateralModeTouched == collateralModeTouched) &&
            (identical(other.leverageTouched, leverageTouched) ||
                other.leverageTouched == leverageTouched) &&
            (identical(other.directionTouched, directionTouched) ||
                other.directionTouched == directionTouched) &&
            (identical(other.exitPlanTouched, exitPlanTouched) ||
                other.exitPlanTouched == exitPlanTouched) &&
            (identical(other.signalText, signalText) ||
                other.signalText == signalText) &&
            (identical(other.parsedSignal, parsedSignal) ||
                other.parsedSignal == parsedSignal) &&
            (identical(other.isApplyingSignal, isApplyingSignal) ||
                other.isApplyingSignal == isApplyingSignal) &&
            (identical(other.signalError, signalError) ||
                other.signalError == signalError));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        symbol,
        orderType,
        side,
        collateralMode,
        amountInputMode,
        quantity,
        limitPrice,
        marginMode,
        marginValue,
        availableBalance,
        balanceCurrency,
        leverage,
        takeProfit1,
        takeProfit2,
        slPrice,
        autoStopLossProgression,
        riskScore,
        preflight,
        validation,
        isLoadingPreflight,
        isValidating,
        isSubmitting,
        preflightError,
        validationError,
        submitError,
        lastOrder,
        symbolTouched,
        orderTypeTouched,
        amountTouched,
        collateralModeTouched,
        leverageTouched,
        directionTouched,
        exitPlanTouched,
        signalText,
        parsedSignal,
        isApplyingSignal,
        signalError
      ]);

  @override
  String toString() {
    return 'TradeFormState(symbol: $symbol, orderType: $orderType, side: $side, collateralMode: $collateralMode, amountInputMode: $amountInputMode, quantity: $quantity, limitPrice: $limitPrice, marginMode: $marginMode, marginValue: $marginValue, availableBalance: $availableBalance, balanceCurrency: $balanceCurrency, leverage: $leverage, takeProfit1: $takeProfit1, takeProfit2: $takeProfit2, slPrice: $slPrice, autoStopLossProgression: $autoStopLossProgression, riskScore: $riskScore, preflight: $preflight, validation: $validation, isLoadingPreflight: $isLoadingPreflight, isValidating: $isValidating, isSubmitting: $isSubmitting, preflightError: $preflightError, validationError: $validationError, submitError: $submitError, lastOrder: $lastOrder, symbolTouched: $symbolTouched, orderTypeTouched: $orderTypeTouched, amountTouched: $amountTouched, collateralModeTouched: $collateralModeTouched, leverageTouched: $leverageTouched, directionTouched: $directionTouched, exitPlanTouched: $exitPlanTouched, signalText: $signalText, parsedSignal: $parsedSignal, isApplyingSignal: $isApplyingSignal, signalError: $signalError)';
  }
}

/// @nodoc
abstract mixin class $TradeFormStateCopyWith<$Res> {
  factory $TradeFormStateCopyWith(
          TradeFormState value, $Res Function(TradeFormState) _then) =
      _$TradeFormStateCopyWithImpl;
  @useResult
  $Res call(
      {TradingSymbol? symbol,
      OrderType orderType,
      OrderSide side,
      CollateralMode collateralMode,
      AmountInputMode amountInputMode,
      double quantity,
      double? limitPrice,
      MarginMode marginMode,
      double marginValue,
      double availableBalance,
      String balanceCurrency,
      double leverage,
      double? takeProfit1,
      double? takeProfit2,
      double? slPrice,
      bool autoStopLossProgression,
      RiskScore? riskScore,
      TradePreflight? preflight,
      TradeValidationResult? validation,
      bool isLoadingPreflight,
      bool isValidating,
      bool isSubmitting,
      String? preflightError,
      String? validationError,
      String? submitError,
      Order? lastOrder,
      bool symbolTouched,
      bool orderTypeTouched,
      bool amountTouched,
      bool collateralModeTouched,
      bool leverageTouched,
      bool directionTouched,
      bool exitPlanTouched,
      String signalText,
      TradeSignalParse? parsedSignal,
      bool isApplyingSignal,
      String? signalError});

  $TradingSymbolCopyWith<$Res>? get symbol;
  $RiskScoreCopyWith<$Res>? get riskScore;
  $OrderCopyWith<$Res>? get lastOrder;
}

/// @nodoc
class _$TradeFormStateCopyWithImpl<$Res>
    implements $TradeFormStateCopyWith<$Res> {
  _$TradeFormStateCopyWithImpl(this._self, this._then);

  final TradeFormState _self;
  final $Res Function(TradeFormState) _then;

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = freezed,
    Object? orderType = null,
    Object? side = null,
    Object? collateralMode = null,
    Object? amountInputMode = null,
    Object? quantity = null,
    Object? limitPrice = freezed,
    Object? marginMode = null,
    Object? marginValue = null,
    Object? availableBalance = null,
    Object? balanceCurrency = null,
    Object? leverage = null,
    Object? takeProfit1 = freezed,
    Object? takeProfit2 = freezed,
    Object? slPrice = freezed,
    Object? autoStopLossProgression = null,
    Object? riskScore = freezed,
    Object? preflight = freezed,
    Object? validation = freezed,
    Object? isLoadingPreflight = null,
    Object? isValidating = null,
    Object? isSubmitting = null,
    Object? preflightError = freezed,
    Object? validationError = freezed,
    Object? submitError = freezed,
    Object? lastOrder = freezed,
    Object? symbolTouched = null,
    Object? orderTypeTouched = null,
    Object? amountTouched = null,
    Object? collateralModeTouched = null,
    Object? leverageTouched = null,
    Object? directionTouched = null,
    Object? exitPlanTouched = null,
    Object? signalText = null,
    Object? parsedSignal = freezed,
    Object? isApplyingSignal = null,
    Object? signalError = freezed,
  }) {
    return _then(_self.copyWith(
      symbol: freezed == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as TradingSymbol?,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as OrderType,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as OrderSide,
      collateralMode: null == collateralMode
          ? _self.collateralMode
          : collateralMode // ignore: cast_nullable_to_non_nullable
              as CollateralMode,
      amountInputMode: null == amountInputMode
          ? _self.amountInputMode
          : amountInputMode // ignore: cast_nullable_to_non_nullable
              as AmountInputMode,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      limitPrice: freezed == limitPrice
          ? _self.limitPrice
          : limitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      marginMode: null == marginMode
          ? _self.marginMode
          : marginMode // ignore: cast_nullable_to_non_nullable
              as MarginMode,
      marginValue: null == marginValue
          ? _self.marginValue
          : marginValue // ignore: cast_nullable_to_non_nullable
              as double,
      availableBalance: null == availableBalance
          ? _self.availableBalance
          : availableBalance // ignore: cast_nullable_to_non_nullable
              as double,
      balanceCurrency: null == balanceCurrency
          ? _self.balanceCurrency
          : balanceCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      leverage: null == leverage
          ? _self.leverage
          : leverage // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfit1: freezed == takeProfit1
          ? _self.takeProfit1
          : takeProfit1 // ignore: cast_nullable_to_non_nullable
              as double?,
      takeProfit2: freezed == takeProfit2
          ? _self.takeProfit2
          : takeProfit2 // ignore: cast_nullable_to_non_nullable
              as double?,
      slPrice: freezed == slPrice
          ? _self.slPrice
          : slPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      autoStopLossProgression: null == autoStopLossProgression
          ? _self.autoStopLossProgression
          : autoStopLossProgression // ignore: cast_nullable_to_non_nullable
              as bool,
      riskScore: freezed == riskScore
          ? _self.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as RiskScore?,
      preflight: freezed == preflight
          ? _self.preflight
          : preflight // ignore: cast_nullable_to_non_nullable
              as TradePreflight?,
      validation: freezed == validation
          ? _self.validation
          : validation // ignore: cast_nullable_to_non_nullable
              as TradeValidationResult?,
      isLoadingPreflight: null == isLoadingPreflight
          ? _self.isLoadingPreflight
          : isLoadingPreflight // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidating: null == isValidating
          ? _self.isValidating
          : isValidating // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      preflightError: freezed == preflightError
          ? _self.preflightError
          : preflightError // ignore: cast_nullable_to_non_nullable
              as String?,
      validationError: freezed == validationError
          ? _self.validationError
          : validationError // ignore: cast_nullable_to_non_nullable
              as String?,
      submitError: freezed == submitError
          ? _self.submitError
          : submitError // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOrder: freezed == lastOrder
          ? _self.lastOrder
          : lastOrder // ignore: cast_nullable_to_non_nullable
              as Order?,
      symbolTouched: null == symbolTouched
          ? _self.symbolTouched
          : symbolTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      orderTypeTouched: null == orderTypeTouched
          ? _self.orderTypeTouched
          : orderTypeTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      amountTouched: null == amountTouched
          ? _self.amountTouched
          : amountTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      collateralModeTouched: null == collateralModeTouched
          ? _self.collateralModeTouched
          : collateralModeTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      leverageTouched: null == leverageTouched
          ? _self.leverageTouched
          : leverageTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      directionTouched: null == directionTouched
          ? _self.directionTouched
          : directionTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      exitPlanTouched: null == exitPlanTouched
          ? _self.exitPlanTouched
          : exitPlanTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      signalText: null == signalText
          ? _self.signalText
          : signalText // ignore: cast_nullable_to_non_nullable
              as String,
      parsedSignal: freezed == parsedSignal
          ? _self.parsedSignal
          : parsedSignal // ignore: cast_nullable_to_non_nullable
              as TradeSignalParse?,
      isApplyingSignal: null == isApplyingSignal
          ? _self.isApplyingSignal
          : isApplyingSignal // ignore: cast_nullable_to_non_nullable
              as bool,
      signalError: freezed == signalError
          ? _self.signalError
          : signalError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TradingSymbolCopyWith<$Res>? get symbol {
    if (_self.symbol == null) {
      return null;
    }

    return $TradingSymbolCopyWith<$Res>(_self.symbol!, (value) {
      return _then(_self.copyWith(symbol: value));
    });
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RiskScoreCopyWith<$Res>? get riskScore {
    if (_self.riskScore == null) {
      return null;
    }

    return $RiskScoreCopyWith<$Res>(_self.riskScore!, (value) {
      return _then(_self.copyWith(riskScore: value));
    });
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderCopyWith<$Res>? get lastOrder {
    if (_self.lastOrder == null) {
      return null;
    }

    return $OrderCopyWith<$Res>(_self.lastOrder!, (value) {
      return _then(_self.copyWith(lastOrder: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TradeFormState].
extension TradeFormStatePatterns on TradeFormState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TradeFormState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TradeFormState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TradeFormState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradeFormState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TradeFormState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradeFormState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            TradingSymbol? symbol,
            OrderType orderType,
            OrderSide side,
            CollateralMode collateralMode,
            AmountInputMode amountInputMode,
            double quantity,
            double? limitPrice,
            MarginMode marginMode,
            double marginValue,
            double availableBalance,
            String balanceCurrency,
            double leverage,
            double? takeProfit1,
            double? takeProfit2,
            double? slPrice,
            bool autoStopLossProgression,
            RiskScore? riskScore,
            TradePreflight? preflight,
            TradeValidationResult? validation,
            bool isLoadingPreflight,
            bool isValidating,
            bool isSubmitting,
            String? preflightError,
            String? validationError,
            String? submitError,
            Order? lastOrder,
            bool symbolTouched,
            bool orderTypeTouched,
            bool amountTouched,
            bool collateralModeTouched,
            bool leverageTouched,
            bool directionTouched,
            bool exitPlanTouched,
            String signalText,
            TradeSignalParse? parsedSignal,
            bool isApplyingSignal,
            String? signalError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TradeFormState() when $default != null:
        return $default(
            _that.symbol,
            _that.orderType,
            _that.side,
            _that.collateralMode,
            _that.amountInputMode,
            _that.quantity,
            _that.limitPrice,
            _that.marginMode,
            _that.marginValue,
            _that.availableBalance,
            _that.balanceCurrency,
            _that.leverage,
            _that.takeProfit1,
            _that.takeProfit2,
            _that.slPrice,
            _that.autoStopLossProgression,
            _that.riskScore,
            _that.preflight,
            _that.validation,
            _that.isLoadingPreflight,
            _that.isValidating,
            _that.isSubmitting,
            _that.preflightError,
            _that.validationError,
            _that.submitError,
            _that.lastOrder,
            _that.symbolTouched,
            _that.orderTypeTouched,
            _that.amountTouched,
            _that.collateralModeTouched,
            _that.leverageTouched,
            _that.directionTouched,
            _that.exitPlanTouched,
            _that.signalText,
            _that.parsedSignal,
            _that.isApplyingSignal,
            _that.signalError);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            TradingSymbol? symbol,
            OrderType orderType,
            OrderSide side,
            CollateralMode collateralMode,
            AmountInputMode amountInputMode,
            double quantity,
            double? limitPrice,
            MarginMode marginMode,
            double marginValue,
            double availableBalance,
            String balanceCurrency,
            double leverage,
            double? takeProfit1,
            double? takeProfit2,
            double? slPrice,
            bool autoStopLossProgression,
            RiskScore? riskScore,
            TradePreflight? preflight,
            TradeValidationResult? validation,
            bool isLoadingPreflight,
            bool isValidating,
            bool isSubmitting,
            String? preflightError,
            String? validationError,
            String? submitError,
            Order? lastOrder,
            bool symbolTouched,
            bool orderTypeTouched,
            bool amountTouched,
            bool collateralModeTouched,
            bool leverageTouched,
            bool directionTouched,
            bool exitPlanTouched,
            String signalText,
            TradeSignalParse? parsedSignal,
            bool isApplyingSignal,
            String? signalError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradeFormState():
        return $default(
            _that.symbol,
            _that.orderType,
            _that.side,
            _that.collateralMode,
            _that.amountInputMode,
            _that.quantity,
            _that.limitPrice,
            _that.marginMode,
            _that.marginValue,
            _that.availableBalance,
            _that.balanceCurrency,
            _that.leverage,
            _that.takeProfit1,
            _that.takeProfit2,
            _that.slPrice,
            _that.autoStopLossProgression,
            _that.riskScore,
            _that.preflight,
            _that.validation,
            _that.isLoadingPreflight,
            _that.isValidating,
            _that.isSubmitting,
            _that.preflightError,
            _that.validationError,
            _that.submitError,
            _that.lastOrder,
            _that.symbolTouched,
            _that.orderTypeTouched,
            _that.amountTouched,
            _that.collateralModeTouched,
            _that.leverageTouched,
            _that.directionTouched,
            _that.exitPlanTouched,
            _that.signalText,
            _that.parsedSignal,
            _that.isApplyingSignal,
            _that.signalError);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            TradingSymbol? symbol,
            OrderType orderType,
            OrderSide side,
            CollateralMode collateralMode,
            AmountInputMode amountInputMode,
            double quantity,
            double? limitPrice,
            MarginMode marginMode,
            double marginValue,
            double availableBalance,
            String balanceCurrency,
            double leverage,
            double? takeProfit1,
            double? takeProfit2,
            double? slPrice,
            bool autoStopLossProgression,
            RiskScore? riskScore,
            TradePreflight? preflight,
            TradeValidationResult? validation,
            bool isLoadingPreflight,
            bool isValidating,
            bool isSubmitting,
            String? preflightError,
            String? validationError,
            String? submitError,
            Order? lastOrder,
            bool symbolTouched,
            bool orderTypeTouched,
            bool amountTouched,
            bool collateralModeTouched,
            bool leverageTouched,
            bool directionTouched,
            bool exitPlanTouched,
            String signalText,
            TradeSignalParse? parsedSignal,
            bool isApplyingSignal,
            String? signalError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TradeFormState() when $default != null:
        return $default(
            _that.symbol,
            _that.orderType,
            _that.side,
            _that.collateralMode,
            _that.amountInputMode,
            _that.quantity,
            _that.limitPrice,
            _that.marginMode,
            _that.marginValue,
            _that.availableBalance,
            _that.balanceCurrency,
            _that.leverage,
            _that.takeProfit1,
            _that.takeProfit2,
            _that.slPrice,
            _that.autoStopLossProgression,
            _that.riskScore,
            _that.preflight,
            _that.validation,
            _that.isLoadingPreflight,
            _that.isValidating,
            _that.isSubmitting,
            _that.preflightError,
            _that.validationError,
            _that.submitError,
            _that.lastOrder,
            _that.symbolTouched,
            _that.orderTypeTouched,
            _that.amountTouched,
            _that.collateralModeTouched,
            _that.leverageTouched,
            _that.directionTouched,
            _that.exitPlanTouched,
            _that.signalText,
            _that.parsedSignal,
            _that.isApplyingSignal,
            _that.signalError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TradeFormState implements TradeFormState {
  const _TradeFormState(
      {this.symbol,
      this.orderType = OrderType.market,
      this.side = OrderSide.long,
      this.collateralMode = CollateralMode.isolated,
      this.amountInputMode = AmountInputMode.margin,
      this.quantity = 1.0,
      this.limitPrice,
      this.marginMode = MarginMode.percentage,
      this.marginValue = 20.0,
      this.availableBalance = 0.0,
      this.balanceCurrency = 'USD',
      this.leverage = 5.0,
      this.takeProfit1,
      this.takeProfit2,
      this.slPrice,
      this.autoStopLossProgression = false,
      this.riskScore,
      this.preflight,
      this.validation,
      this.isLoadingPreflight = false,
      this.isValidating = false,
      this.isSubmitting = false,
      this.preflightError,
      this.validationError,
      this.submitError,
      this.lastOrder,
      this.symbolTouched = false,
      this.orderTypeTouched = false,
      this.amountTouched = false,
      this.collateralModeTouched = false,
      this.leverageTouched = false,
      this.directionTouched = false,
      this.exitPlanTouched = false,
      this.signalText = '',
      this.parsedSignal,
      this.isApplyingSignal = false,
      this.signalError});

  @override
  final TradingSymbol? symbol;
  @override
  @JsonKey()
  final OrderType orderType;
  @override
  @JsonKey()
  final OrderSide side;
  @override
  @JsonKey()
  final CollateralMode collateralMode;
  @override
  @JsonKey()
  final AmountInputMode amountInputMode;
  @override
  @JsonKey()
  final double quantity;
  @override
  final double? limitPrice;
  @override
  @JsonKey()
  final MarginMode marginMode;
  @override
  @JsonKey()
  final double marginValue;
  @override
  @JsonKey()
  final double availableBalance;
  @override
  @JsonKey()
  final String balanceCurrency;
  @override
  @JsonKey()
  final double leverage;
  @override
  final double? takeProfit1;
  @override
  final double? takeProfit2;
  @override
  final double? slPrice;
  @override
  @JsonKey()
  final bool autoStopLossProgression;
  @override
  final RiskScore? riskScore;
  @override
  final TradePreflight? preflight;
  @override
  final TradeValidationResult? validation;
  @override
  @JsonKey()
  final bool isLoadingPreflight;
  @override
  @JsonKey()
  final bool isValidating;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? preflightError;
  @override
  final String? validationError;
  @override
  final String? submitError;
  @override
  final Order? lastOrder;
  @override
  @JsonKey()
  final bool symbolTouched;
  @override
  @JsonKey()
  final bool orderTypeTouched;
  @override
  @JsonKey()
  final bool amountTouched;
  @override
  @JsonKey()
  final bool collateralModeTouched;
  @override
  @JsonKey()
  final bool leverageTouched;
  @override
  @JsonKey()
  final bool directionTouched;
  @override
  @JsonKey()
  final bool exitPlanTouched;
  @override
  @JsonKey()
  final String signalText;
  @override
  final TradeSignalParse? parsedSignal;
  @override
  @JsonKey()
  final bool isApplyingSignal;
  @override
  final String? signalError;

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TradeFormStateCopyWith<_TradeFormState> get copyWith =>
      __$TradeFormStateCopyWithImpl<_TradeFormState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TradeFormState &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.collateralMode, collateralMode) ||
                other.collateralMode == collateralMode) &&
            (identical(other.amountInputMode, amountInputMode) ||
                other.amountInputMode == amountInputMode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.limitPrice, limitPrice) ||
                other.limitPrice == limitPrice) &&
            (identical(other.marginMode, marginMode) ||
                other.marginMode == marginMode) &&
            (identical(other.marginValue, marginValue) ||
                other.marginValue == marginValue) &&
            (identical(other.availableBalance, availableBalance) ||
                other.availableBalance == availableBalance) &&
            (identical(other.balanceCurrency, balanceCurrency) ||
                other.balanceCurrency == balanceCurrency) &&
            (identical(other.leverage, leverage) ||
                other.leverage == leverage) &&
            (identical(other.takeProfit1, takeProfit1) ||
                other.takeProfit1 == takeProfit1) &&
            (identical(other.takeProfit2, takeProfit2) ||
                other.takeProfit2 == takeProfit2) &&
            (identical(other.slPrice, slPrice) || other.slPrice == slPrice) &&
            (identical(
                    other.autoStopLossProgression, autoStopLossProgression) ||
                other.autoStopLossProgression == autoStopLossProgression) &&
            (identical(other.riskScore, riskScore) ||
                other.riskScore == riskScore) &&
            (identical(other.preflight, preflight) ||
                other.preflight == preflight) &&
            (identical(other.validation, validation) ||
                other.validation == validation) &&
            (identical(other.isLoadingPreflight, isLoadingPreflight) ||
                other.isLoadingPreflight == isLoadingPreflight) &&
            (identical(other.isValidating, isValidating) ||
                other.isValidating == isValidating) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.preflightError, preflightError) ||
                other.preflightError == preflightError) &&
            (identical(other.validationError, validationError) ||
                other.validationError == validationError) &&
            (identical(other.submitError, submitError) ||
                other.submitError == submitError) &&
            (identical(other.lastOrder, lastOrder) ||
                other.lastOrder == lastOrder) &&
            (identical(other.symbolTouched, symbolTouched) ||
                other.symbolTouched == symbolTouched) &&
            (identical(other.orderTypeTouched, orderTypeTouched) ||
                other.orderTypeTouched == orderTypeTouched) &&
            (identical(other.amountTouched, amountTouched) ||
                other.amountTouched == amountTouched) &&
            (identical(other.collateralModeTouched, collateralModeTouched) ||
                other.collateralModeTouched == collateralModeTouched) &&
            (identical(other.leverageTouched, leverageTouched) ||
                other.leverageTouched == leverageTouched) &&
            (identical(other.directionTouched, directionTouched) ||
                other.directionTouched == directionTouched) &&
            (identical(other.exitPlanTouched, exitPlanTouched) ||
                other.exitPlanTouched == exitPlanTouched) &&
            (identical(other.signalText, signalText) ||
                other.signalText == signalText) &&
            (identical(other.parsedSignal, parsedSignal) ||
                other.parsedSignal == parsedSignal) &&
            (identical(other.isApplyingSignal, isApplyingSignal) ||
                other.isApplyingSignal == isApplyingSignal) &&
            (identical(other.signalError, signalError) ||
                other.signalError == signalError));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        symbol,
        orderType,
        side,
        collateralMode,
        amountInputMode,
        quantity,
        limitPrice,
        marginMode,
        marginValue,
        availableBalance,
        balanceCurrency,
        leverage,
        takeProfit1,
        takeProfit2,
        slPrice,
        autoStopLossProgression,
        riskScore,
        preflight,
        validation,
        isLoadingPreflight,
        isValidating,
        isSubmitting,
        preflightError,
        validationError,
        submitError,
        lastOrder,
        symbolTouched,
        orderTypeTouched,
        amountTouched,
        collateralModeTouched,
        leverageTouched,
        directionTouched,
        exitPlanTouched,
        signalText,
        parsedSignal,
        isApplyingSignal,
        signalError
      ]);

  @override
  String toString() {
    return 'TradeFormState(symbol: $symbol, orderType: $orderType, side: $side, collateralMode: $collateralMode, amountInputMode: $amountInputMode, quantity: $quantity, limitPrice: $limitPrice, marginMode: $marginMode, marginValue: $marginValue, availableBalance: $availableBalance, balanceCurrency: $balanceCurrency, leverage: $leverage, takeProfit1: $takeProfit1, takeProfit2: $takeProfit2, slPrice: $slPrice, autoStopLossProgression: $autoStopLossProgression, riskScore: $riskScore, preflight: $preflight, validation: $validation, isLoadingPreflight: $isLoadingPreflight, isValidating: $isValidating, isSubmitting: $isSubmitting, preflightError: $preflightError, validationError: $validationError, submitError: $submitError, lastOrder: $lastOrder, symbolTouched: $symbolTouched, orderTypeTouched: $orderTypeTouched, amountTouched: $amountTouched, collateralModeTouched: $collateralModeTouched, leverageTouched: $leverageTouched, directionTouched: $directionTouched, exitPlanTouched: $exitPlanTouched, signalText: $signalText, parsedSignal: $parsedSignal, isApplyingSignal: $isApplyingSignal, signalError: $signalError)';
  }
}

/// @nodoc
abstract mixin class _$TradeFormStateCopyWith<$Res>
    implements $TradeFormStateCopyWith<$Res> {
  factory _$TradeFormStateCopyWith(
          _TradeFormState value, $Res Function(_TradeFormState) _then) =
      __$TradeFormStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {TradingSymbol? symbol,
      OrderType orderType,
      OrderSide side,
      CollateralMode collateralMode,
      AmountInputMode amountInputMode,
      double quantity,
      double? limitPrice,
      MarginMode marginMode,
      double marginValue,
      double availableBalance,
      String balanceCurrency,
      double leverage,
      double? takeProfit1,
      double? takeProfit2,
      double? slPrice,
      bool autoStopLossProgression,
      RiskScore? riskScore,
      TradePreflight? preflight,
      TradeValidationResult? validation,
      bool isLoadingPreflight,
      bool isValidating,
      bool isSubmitting,
      String? preflightError,
      String? validationError,
      String? submitError,
      Order? lastOrder,
      bool symbolTouched,
      bool orderTypeTouched,
      bool amountTouched,
      bool collateralModeTouched,
      bool leverageTouched,
      bool directionTouched,
      bool exitPlanTouched,
      String signalText,
      TradeSignalParse? parsedSignal,
      bool isApplyingSignal,
      String? signalError});

  @override
  $TradingSymbolCopyWith<$Res>? get symbol;
  @override
  $RiskScoreCopyWith<$Res>? get riskScore;
  @override
  $OrderCopyWith<$Res>? get lastOrder;
}

/// @nodoc
class __$TradeFormStateCopyWithImpl<$Res>
    implements _$TradeFormStateCopyWith<$Res> {
  __$TradeFormStateCopyWithImpl(this._self, this._then);

  final _TradeFormState _self;
  final $Res Function(_TradeFormState) _then;

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? symbol = freezed,
    Object? orderType = null,
    Object? side = null,
    Object? collateralMode = null,
    Object? amountInputMode = null,
    Object? quantity = null,
    Object? limitPrice = freezed,
    Object? marginMode = null,
    Object? marginValue = null,
    Object? availableBalance = null,
    Object? balanceCurrency = null,
    Object? leverage = null,
    Object? takeProfit1 = freezed,
    Object? takeProfit2 = freezed,
    Object? slPrice = freezed,
    Object? autoStopLossProgression = null,
    Object? riskScore = freezed,
    Object? preflight = freezed,
    Object? validation = freezed,
    Object? isLoadingPreflight = null,
    Object? isValidating = null,
    Object? isSubmitting = null,
    Object? preflightError = freezed,
    Object? validationError = freezed,
    Object? submitError = freezed,
    Object? lastOrder = freezed,
    Object? symbolTouched = null,
    Object? orderTypeTouched = null,
    Object? amountTouched = null,
    Object? collateralModeTouched = null,
    Object? leverageTouched = null,
    Object? directionTouched = null,
    Object? exitPlanTouched = null,
    Object? signalText = null,
    Object? parsedSignal = freezed,
    Object? isApplyingSignal = null,
    Object? signalError = freezed,
  }) {
    return _then(_TradeFormState(
      symbol: freezed == symbol
          ? _self.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as TradingSymbol?,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as OrderType,
      side: null == side
          ? _self.side
          : side // ignore: cast_nullable_to_non_nullable
              as OrderSide,
      collateralMode: null == collateralMode
          ? _self.collateralMode
          : collateralMode // ignore: cast_nullable_to_non_nullable
              as CollateralMode,
      amountInputMode: null == amountInputMode
          ? _self.amountInputMode
          : amountInputMode // ignore: cast_nullable_to_non_nullable
              as AmountInputMode,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      limitPrice: freezed == limitPrice
          ? _self.limitPrice
          : limitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      marginMode: null == marginMode
          ? _self.marginMode
          : marginMode // ignore: cast_nullable_to_non_nullable
              as MarginMode,
      marginValue: null == marginValue
          ? _self.marginValue
          : marginValue // ignore: cast_nullable_to_non_nullable
              as double,
      availableBalance: null == availableBalance
          ? _self.availableBalance
          : availableBalance // ignore: cast_nullable_to_non_nullable
              as double,
      balanceCurrency: null == balanceCurrency
          ? _self.balanceCurrency
          : balanceCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      leverage: null == leverage
          ? _self.leverage
          : leverage // ignore: cast_nullable_to_non_nullable
              as double,
      takeProfit1: freezed == takeProfit1
          ? _self.takeProfit1
          : takeProfit1 // ignore: cast_nullable_to_non_nullable
              as double?,
      takeProfit2: freezed == takeProfit2
          ? _self.takeProfit2
          : takeProfit2 // ignore: cast_nullable_to_non_nullable
              as double?,
      slPrice: freezed == slPrice
          ? _self.slPrice
          : slPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      autoStopLossProgression: null == autoStopLossProgression
          ? _self.autoStopLossProgression
          : autoStopLossProgression // ignore: cast_nullable_to_non_nullable
              as bool,
      riskScore: freezed == riskScore
          ? _self.riskScore
          : riskScore // ignore: cast_nullable_to_non_nullable
              as RiskScore?,
      preflight: freezed == preflight
          ? _self.preflight
          : preflight // ignore: cast_nullable_to_non_nullable
              as TradePreflight?,
      validation: freezed == validation
          ? _self.validation
          : validation // ignore: cast_nullable_to_non_nullable
              as TradeValidationResult?,
      isLoadingPreflight: null == isLoadingPreflight
          ? _self.isLoadingPreflight
          : isLoadingPreflight // ignore: cast_nullable_to_non_nullable
              as bool,
      isValidating: null == isValidating
          ? _self.isValidating
          : isValidating // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      preflightError: freezed == preflightError
          ? _self.preflightError
          : preflightError // ignore: cast_nullable_to_non_nullable
              as String?,
      validationError: freezed == validationError
          ? _self.validationError
          : validationError // ignore: cast_nullable_to_non_nullable
              as String?,
      submitError: freezed == submitError
          ? _self.submitError
          : submitError // ignore: cast_nullable_to_non_nullable
              as String?,
      lastOrder: freezed == lastOrder
          ? _self.lastOrder
          : lastOrder // ignore: cast_nullable_to_non_nullable
              as Order?,
      symbolTouched: null == symbolTouched
          ? _self.symbolTouched
          : symbolTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      orderTypeTouched: null == orderTypeTouched
          ? _self.orderTypeTouched
          : orderTypeTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      amountTouched: null == amountTouched
          ? _self.amountTouched
          : amountTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      collateralModeTouched: null == collateralModeTouched
          ? _self.collateralModeTouched
          : collateralModeTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      leverageTouched: null == leverageTouched
          ? _self.leverageTouched
          : leverageTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      directionTouched: null == directionTouched
          ? _self.directionTouched
          : directionTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      exitPlanTouched: null == exitPlanTouched
          ? _self.exitPlanTouched
          : exitPlanTouched // ignore: cast_nullable_to_non_nullable
              as bool,
      signalText: null == signalText
          ? _self.signalText
          : signalText // ignore: cast_nullable_to_non_nullable
              as String,
      parsedSignal: freezed == parsedSignal
          ? _self.parsedSignal
          : parsedSignal // ignore: cast_nullable_to_non_nullable
              as TradeSignalParse?,
      isApplyingSignal: null == isApplyingSignal
          ? _self.isApplyingSignal
          : isApplyingSignal // ignore: cast_nullable_to_non_nullable
              as bool,
      signalError: freezed == signalError
          ? _self.signalError
          : signalError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TradingSymbolCopyWith<$Res>? get symbol {
    if (_self.symbol == null) {
      return null;
    }

    return $TradingSymbolCopyWith<$Res>(_self.symbol!, (value) {
      return _then(_self.copyWith(symbol: value));
    });
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RiskScoreCopyWith<$Res>? get riskScore {
    if (_self.riskScore == null) {
      return null;
    }

    return $RiskScoreCopyWith<$Res>(_self.riskScore!, (value) {
      return _then(_self.copyWith(riskScore: value));
    });
  }

  /// Create a copy of TradeFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderCopyWith<$Res>? get lastOrder {
    if (_self.lastOrder == null) {
      return null;
    }

    return $OrderCopyWith<$Res>(_self.lastOrder!, (value) {
      return _then(_self.copyWith(lastOrder: value));
    });
  }
}

// dart format on
