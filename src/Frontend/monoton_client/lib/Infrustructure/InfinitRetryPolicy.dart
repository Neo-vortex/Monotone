import 'package:signalr_netcore/iretry_policy.dart';

class InfinitRetryPolicy implements IRetryPolicy {
  @override
  int? nextRetryDelayInMilliseconds(RetryContext retryContext) {
    return 2000;
  }
}