import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:touch_bar/touch_bar.dart';
import 'package:touch_bar_soundpad/init.dart';
import 'package:touch_bar_soundpad/services/firebase_storage_service.dart';

void main() async {
  await initApp();
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
  final audioPlayer = AssetsAudioPlayer.newPlayer();
  String url = 'sounds/gnome.mp3'; //local mp3 file in asset folder
  List<TouchBarScrubberItem> scrubberChildren = [];
  final firebaseStorageService = FirebaseStorageService();
  XFile? sound;
  XFile? icon;
  bool isDraggingSound = false;
  bool isDraggingIcon = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropTarget(
                  child: Container(
                    width: 200,
                    height: 200,
                    color: isDraggingSound ? Colors.blue : Colors.grey.shade300,
                    child: const Text("Drop Sound Here"),
                  ),
                  onDragEntered: (details) {
                    setState(() {
                      isDraggingSound = true;
                    });
                  },
                  onDragExited: (details) {
                    setState(() {
                      isDraggingSound = false;
                    });
                  },
                  onDragDone: (details) {
                    sound = details.files[0];
                    setState(() {
                      isDraggingSound = false;
                    });
                  },
                ),
                const SizedBox(width: 50),
                DropTarget(
                  child: Container(
                    width: 200,
                    height: 200,
                    color: isDraggingIcon ? Colors.blue : Colors.grey.shade300,
                    child: const Text("Drop Image Here"),
                  ),
                  onDragEntered: (details) {
                    setState(() {
                      isDraggingIcon = true;
                    });
                  },
                  onDragExited: (details) {
                    isDraggingIcon = false;
                  },
                  onDragDone: (details) {
                    icon = details.files[0];
                    setState(() {
                      isDraggingIcon = false;
                    });
                  },
                ),
              ],
            ),
            FloatingActionButton(
              onPressed: () => uploadSound(sound, icon),
            ),
          ],
        ),
      ),
    );
  }

  void loadData() async {
    var scrubber = await _scrubber();
    final touchBar = TouchBar(
      children: [
        TouchBarButton(
          label: "Hello",
          onClick: playLocal,
        ),
        scrubber,
      ],
    );
    setTouchBar(touchBar);
  }

  playLocal() async {
    audioPlayer.open(Audio(url), autoStart: true, showNotification: true);
  }

  uploadSound(XFile? sound, XFile? icon) async {
    if (sound == null || icon == null) {
      return;
    }

    firebaseStorageService.uploadSound(sound, icon);
  }

  Future _scrubber() async {
    var image = await TouchBarImage.loadFrom(path: 'assets/img.png');
    scrubberChildren.add(TouchBarScrubberLabel("There"));
    scrubberChildren.add(TouchBarScrubberLabel("General"));
    scrubberChildren.add(TouchBarScrubberLabel("Kenobi"));
    scrubberChildren.add(TouchBarScrubberImage(image));
    return TouchBarScrubber(
      children: scrubberChildren,
      selectedStyle: ScrubberSelectionStyle.roundedBackground,
      overlayStyle: ScrubberSelectionStyle.outlineOverlay,
      mode: ScrubberMode.fixed,
      shouldUnselectAfterHit: true,
      onSelect: (childId) {
        if (childId == -1) return;
        playLocal();
      },
      onHighlight: (childId) => null,
    );
  }
}
