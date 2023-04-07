import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

  Future uploadSound(XFile sound, XFile icon) async {
    final storageRef = storage.ref();


    try {
      await storageRef.putData(await sound.readAsBytes());
      await storageRef.putData(await icon.readAsBytes());
    } catch (e) {
      print(e);
    }
  }
}
