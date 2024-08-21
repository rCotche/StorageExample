import "dart:io";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:gallery_picker/gallery_picker.dart";

Future<void> signInUserAnon() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("uid : ${userCredential.user?.uid}");
  } catch (e) {
    print(e);
  }
}

Future<File?> getImageFromGallery(BuildContext context) async {
  try {
    List<MediaFile>? singleMedia =
        await GalleryPicker.pickMedia(context: context, singleMedia: true);
    // print("$singleMedia; getImageFromGallery");
    return singleMedia?.first.getFile();
  } catch (e) {
    print(e);
  }
  return null;
}

Future<bool> uploadFileForUser(File file) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    //Splits the string at matches of [pattern] and returns a list of substrings.
    //The last element of the list
    final fileName = file.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    //to custom folder structure
    final uploadRef =
        storageRef.child("$userId/uploads/${timestamp}_${fileName}");
    await uploadRef.putFile(file);
    return true;
  } catch (e) {
    print(e);
  }
  return false;
}

Future<List<Reference>?> getUserUploadFiles() async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final uploadRef = storageRef.child("$userId/uploads/");
    final uploads = await uploadRef.listAll();
    return uploads.items;
  } catch (e) {
    print(e);
  }
}

Future<bool> deleteFile(String filename) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final deleteRef = storageRef.child("$userId/uploads/$filename");
    await deleteRef.delete();
    return true;
  } catch (e) {
    print(e);
  }
  return false;
}
