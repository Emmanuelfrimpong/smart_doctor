import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageServices {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // save user image cloud storage
  static Future<String> saveUserImage(File image, String userImage) async {
    final Reference storageReference =
        _firebaseStorage.ref().child('userImage/$userImage');
    final UploadTask uploadTask = storageReference.putFile(image);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  static Future<String> saveFiles(File image, String string) async {
    final Reference storageReference =
        _firebaseStorage.ref().child('images/$image');
    final UploadTask uploadTask = storageReference.putFile(image);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
