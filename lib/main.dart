import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:touch_bar/touch_bar.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  List<TouchBarScrubberItem> scrubberChildren = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    var image = await TouchBarImage.loadFrom(path: 'assets/img.png');
    scrubberChildren.add(TouchBarScrubberLabel("There"));
    scrubberChildren.add(TouchBarScrubberLabel("General"));
    scrubberChildren.add(TouchBarScrubberLabel("Kenobi"));
    scrubberChildren.add(TouchBarScrubberImage(image));
    var scrubber = TouchBarScrubber(
      children: scrubberChildren,
      selectedStyle: ScrubberSelectionStyle.none,
      overlayStyle: ScrubberSelectionStyle.none,
      mode: ScrubberMode.fixed,
      onSelect: (childId) {
        print("selected item with id {$childId} ");
      },
      onHighlight: (childId) => null,
    );
    // scrubber = TouchBarScrubber(children: scrubberChildren);

    final touchBar = TouchBar(
      children: [
        TouchBarButton(
          label: "Hello",
          onClick: _playAudio,
        ),
        scrubber,
      ],
    );
    setTouchBar(touchBar);
  }

  _playAudio() async {
    print("start player");
    await player.play('wtf.wav');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
