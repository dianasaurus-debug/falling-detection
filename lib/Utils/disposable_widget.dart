import 'dart:async';

class DisposableWidget {
  final List<StreamSubscription> _subscriptions = [];

  void cancelSubscription() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }

  void addSubscription(StreamSubscription subscription) =>
      _subscriptions.add(subscription);
}

extension DisposableStreamSubscription on StreamSubscription {
  void canceledBy(DisposableWidget widget) => widget.addSubscription(this);
}
