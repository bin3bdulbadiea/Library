// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:velocity_x/velocity_x.dart';

class BooksController extends GetxController {
  var bookNameController = TextEditingController();

  var authorNameController = TextEditingController();

  var bookPlaceController = TextEditingController();

  var searchController = TextEditingController();

  var isLoading = false.obs;

  var imagePath = ''.obs;

  var imageLink = '';

  pickImage(context) async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (img == null) return;
      imagePath.value = img.path;
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImage() async {
    var fileName = basename(imagePath.value);
    var destination = 'books/$fileName';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(imagePath.value));
    imageLink = await ref.getDownloadURL();
  }

  uploadProduct({context, required img}) async {
    var store = FirebaseFirestore.instance.collection('books').doc();
    await store.set({
      'author': authorNameController.text,
      'image': img,
      'place': bookPlaceController.text,
      'title': bookNameController.text,
    });

    isLoading(false);
  }

  deleteBook(docID) async {
    await FirebaseFirestore.instance.collection('books').doc(docID).delete();
  }
}
