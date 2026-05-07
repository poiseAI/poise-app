import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/utils/result.dart';
import '../data/models/order.dart';
import '../data/orders_api.dart';
import 'orders_provider.dart';

part 'place_order_provider.g.dart';

enum PlaceOrderStatus { idle, loading, success, error }

@riverpod
class PlaceOrderNotifier extends _$PlaceOrderNotifier {
  @override
  PlaceOrderStatus build() => PlaceOrderStatus.idle;

  Future<Result<Order, AppError>> place(PlaceOrderRequest req) async {
    state = PlaceOrderStatus.loading;

    // Optimistic insert placeholder
    final api = ref.read(ordersApiProvider);
    final result = await api.placeOrder(req);

    result.fold(
      onOk: (order) {
        state = PlaceOrderStatus.success;
        // Refresh orders list to include confirmed order
        ref.read(ordersNotifierProvider.notifier).refresh();
      },
      onErr: (_) => state = PlaceOrderStatus.error,
    );

    return result;
  }

  void reset() => state = PlaceOrderStatus.idle;
}
