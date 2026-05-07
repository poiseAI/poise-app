import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import 'models/risk_score.dart';

part 'risk_api.g.dart';

@riverpod
RiskApi riskApi(Ref ref) => RiskApi(ref.watch(dioProvider));

class RiskApi {
  RiskApi(this._dio);
  final Dio _dio;

  Future<Result<RiskScore, AppError>> getTokenRisk(String symbol) async {
    try {
      final resp =
          await _dio.get<Map<String, dynamic>>('/risk/tokens/$symbol/score');
      return Ok(RiskScore.fromJson(resp.data!));
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }

  Future<Result<PortfolioRisk, AppError>> getPortfolioRisk() async {
    try {
      final resp =
          await _dio.get<Map<String, dynamic>>('/risk/portfolio');
      return Ok(PortfolioRisk.fromJson(resp.data!));
    } on DioException catch (e) {
      return Err(
          e.error is AppError ? e.error as AppError : UnknownError(e.message ?? ''));
    }
  }
}
