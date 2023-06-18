import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageChanger {
  Future<String> getProfileImageFromCamera() async {
    String url = '';
    await ImagePicker()
        .pickImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 400,
    )
        .then((pickedImage) async {
      if (pickedImage == null) return;
      url = await getImageLink(pickedImage);
    });
    return url;
  }

  Future<String> getProfileImageFromGallery() async {
    String url = '';
    await ImagePicker()
        .pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      maxWidth: 400,
    )
        .then((pickedImage) async {
      if (pickedImage == null) return;
      url = await getImageLink(pickedImage);
    });
    return url;
  }

  Future<String> getImageLink(XFile pickedFile) async {
    File file = File(pickedFile.path);
    final imageUrl = await uploadProfileImage(file);
    return imageUrl;
  }

  //upload profile image
  Future<String> uploadProfileImage(File file) async {
    String imageUrl = file.path;
    final user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseStorage.instance.ref('Profile Images/${user!.uid}.jpg');
    await ref.putFile(file).whenComplete(() async {
      final url = await ref.getDownloadURL();
      await user.updatePhotoURL(url);
      // await FirebaseDatabase.instance.ref('Users/${user.uid}').update({
      //   'photoUrl': url,
      // });
      imageUrl = url;
    });
    return imageUrl;
  }

}
