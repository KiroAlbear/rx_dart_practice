import 'package:flutter/material.dart';
import 'package:rx_dart_practice/main_bloc.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  MainBloc mainBloc = MainBloc();

  void listenToStream() {
    mainBloc.stream.listen((event) {
      setState(() {
        _counter = event;
      });
      print('Stream: $event');
    });
  }

  void listenToCounterStream() async {
    mainBloc.startCounterStream();

    // this line to simulate a delay to test listen after some time
    await Future.delayed(Duration(seconds: 5));

    mainBloc.counterStream.listen((event) {
      setState(() {
        _counter = event;
      });
      print('Counter is: $event');
    }, onDone: () {
      print('Counter Stream is done');
    });
    //
    // mainBloc.counterStream.listen((event) {
    //   setState(() {
    //     _counter = event;
    //   });
    //   print('Counter is: $event');
    // }, onDone: () {
    //   print('Counter Stream is done');
    // });

    // mainBloc.counterStream.contains(2).then((event) {
    //   setState(() {
    //     _counter = event ? 2 : 0;
    //   });
    //   print('Counter contains 2: $event');
    // });

    // mainBloc.counterStream.where((event) => event % 2 == 0).listen((event) {
    //
    //   setState(() {
    //     _counter = event;
    //   });
    //
    //   print('Counter is even: $event');
    // });

    // mainBloc.counterStream
    //     .where((event) => event % 2 == 0)
    //     .map((event) => event * 2)
    //     .listen((event) {
    //   setState(() {
    //     _counter = event;
    //   });
    // });
  }

  void listenForMergeStreams() {
    // Rx.combineLatest2(mainStreams.counterStream, mainStreams.counterBehaviour,
    //     (a, b) => a + b).listen((event) {
    //   print('Combined Stream: $event');
    // });

    Rx.merge([mainBloc.counterStream, mainBloc.counterBehaviour])
        .listen((event) {
      print('Merged Stream: $event');
    });

    mainBloc.startCounterBehaviour();
    mainBloc.startCounterStream();
  }

  void listenToCounterBehaviour() async {
    // mainStreams.counterBehaviour.listen((event) {
    //   setState(() {
    //     _counter = event;
    //   });
    // });
    mainBloc.startCounterBehaviour();

    // await Future.delayed(Duration(seconds: 5));

    mainBloc.counterBehaviour.listen((event) {
      setState(() {
        _counter = event;
      });
      print('Counter is: $event');
    });

    mainBloc.counterBehaviour.listen((event) {
      setState(() {
        _counter = event;
      });
      print('Counter is: $event');
    });

    // mainBloc.counterBehaviour
    //     // .where((event) => event % 2 == 0)
    //     // .expand((event) => [event, event + 1])
    //     .map((event) => event * 2)
    //     .listen((event) {
    //   setState(() {
    //     _counter = event;
    //   });
    //   print('Counter is even: $event');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // Method 1: Using StreamBuilder
            // StreamBuilder(
            //   stream: mainStreams.counterStream,
            //   builder: (context, snapshot) {
            //     return snapshot.hasData
            //         ? Text(
            //             '${snapshot.data}',
            //             style: Theme.of(context).textTheme.headlineMedium,
            //           )
            //         : Text('00');
            //   },
            // ),

            // Method 2: Using Stream.listen
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // listenToStream();
          // listenToCounterStream();
          listenToCounterBehaviour();
          // listenForMergeStreams();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
