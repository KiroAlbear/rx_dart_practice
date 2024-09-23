import 'dart:async';

import 'package:rxdart/rxdart.dart';

class MainBloc {
  // Stream<int> counterStream =
  //     Stream<int>.periodic(Duration(seconds: 1), (x) => x);
  //
  Stream<int> get stream => _countStream(6);

  StreamController<int> counterController = StreamController<int>();
  Stream<int> get counterStream => counterController.stream;

  BehaviorSubject<int> counterBehaviour = BehaviorSubject<int>.seeded(0);

  Stream<int> _countStream(int max) async* {
    for (int i = 1; i <= max; i++) {
      // Yield each value asynchronously
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  void startCounterStream() async {
    for (int i = 0; i < 3; i++) {
      await Future.delayed(Duration(seconds: 1));
      counterController.add(i);
    }
  }

  void startCounterBehaviour() async {
    for (int i = 0; i < 6; i++) {
      await Future.delayed(Duration(seconds: 1));
      counterBehaviour.add(i);
    }
  }
}
