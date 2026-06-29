import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/utils/result.dart';
import '../data/billing_api.dart';

final billingUrlLauncherProvider =
    Provider<Future<bool> Function(String url)>((ref) {
  return (url) async {
    final openedInApp =
        await launchUrlString(url, mode: LaunchMode.inAppBrowserView);
    if (openedInApp) return true;
    return launchUrlString(url, mode: LaunchMode.externalApplication);
  };
});

final billingSubscriptionProvider =
    FutureProvider.autoDispose<BillingSubscription>((ref) async {
  final result = await ref.read(billingApiProvider).getSubscription();
  return result.valueOrNull ?? BillingSubscription.none;
});

final billingControllerProvider = Provider.autoDispose<BillingController>(
  BillingController.new,
);

class BillingController {
  BillingController(this.ref);
  final Ref ref;

  Future<Result<void, AppError>> startCheckout(BillingCycle cycle) async {
    final result = await ref.read(billingApiProvider).startCheckout(cycle);
    if (result.isErr) return Err(result.error);
    final session = result.value;
    if (session.url.isEmpty) {
      return const Err(UnknownError('Checkout URL was empty'));
    }
    final launched = await ref.read(billingUrlLauncherProvider)(session.url);
    if (!launched) {
      return const Err(UnknownError('Could not open checkout'));
    }
    return const Ok(null);
  }

  Future<Result<void, AppError>> openPortal() async {
    final result = await ref.read(billingApiProvider).createPortal();
    if (result.isErr) return Err(result.error);
    final session = result.value;
    if (session.url.isEmpty) {
      return const Err(UnknownError('Billing portal URL was empty'));
    }
    final launched = await ref.read(billingUrlLauncherProvider)(session.url);
    if (!launched) {
      return const Err(UnknownError('Could not open billing portal'));
    }
    return const Ok(null);
  }
}
