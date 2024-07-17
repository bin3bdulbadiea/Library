// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lib_app/components/snack_bar.dart';

class AppLogic extends GetxController {
  TextEditingController searchController = TextEditingController();

  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController bookCopiesController = TextEditingController();
  TextEditingController bookPartsController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  // =====================( تبديل الرؤية )====================
  bool visibilityPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void changePasswordVisibility() {
    visibilityPassword = !visibilityPassword;

    suffix = visibilityPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    update();
  }

  // ======================( إنشاء حساب )=====================
  Future<void> register(BuildContext context) async {
    isLoading = true;
    update();

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        'user-id': FirebaseAuth.instance.currentUser?.uid,
        'user-name': nameController.text.trim(),
        'user-email': emailController.text.trim(),
        'is-admin': false,
      });

      showSnackBar(context, message: 'تم إنشاء الحساب بنجاح');
      isLoading = false;
      Navigator.pop(context);
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      update();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(
          context,
          message: 'هذا المستخدم موجود',
        );
      } else if (e.code == 'invalid-email') {
        showSnackBar(
          context,
          message: 'البريد الإلكتروني غير صحيح',
        );
      } else if (e.code == 'weak-password') {
        showSnackBar(
          context,
          message: 'كلمة المرور تبدو ضعيفة',
        );
      }
    }

    isLoading = false;
    update();
  }

  // =====================( تسجيل الدخول )====================
  Future<void> login(BuildContext context) async {
    isLoading = true;
    update();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      showSnackBar(context, message: 'تم تسجيل الدخول بنجاح');
      isLoading = false;
      Navigator.pop(context);
      emailController.clear();
      passwordController.clear();
      update();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showSnackBar(
          context,
          message: 'البريد الإلكتروني غير صحيح',
        );
      } else if (e.code == 'user-not-found') {
        showSnackBar(
          context,
          message: 'هذا المستخدم غير موجود',
        );
      } else if (e.code == 'wrong-password') {
        showSnackBar(
          context,
          message: 'كلمة المرور غير صحيحة',
        );
      }
    }

    isLoading = false;
    update();
  }

  // =====================( تسجيل الخروج )====================
  Future<void> signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    showSnackBar(context, message: 'تم تسجيل الخروج بنجاح');

    update();
  }

  // =====================( pick images )=====================
  File? image;

  Future<void> pickImageGallery(BuildContext context) async {
    await ImagePicker()
        .pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    )
        .then((value) {
      image = File(value!.path);
    });
    update();
  }

  // =====================( إضافة كتاب )======================
  Future<void> addBook(BuildContext context) async {
    isLoading = true;
    update();

    var docID = FirebaseFirestore.instance.collection('books').doc();

    FirebaseStorage.instance
        .ref()
        .child(
          // ${Uri.file(image!.path).pathSegments.last}
          'books/${docID.id}/cover',
        )
        .putFile(image!)
        .then(
      (value) {
        return value.ref.getDownloadURL().then(
              (image) => FirebaseFirestore.instance
                  .collection('books')
                  .doc(docID.id)
                  .set(
                {
                  'doc-id': docID.id,
                  'book-image': image,
                  'book-name': bookNameController.text.trim(),
                  'author-name': authorNameController.text.trim(),
                  'book-copies': bookCopiesController.text.trim(),
                  'book-parts': bookPartsController.text.trim(),
                },
              ),
            );
      },
    ).whenComplete(() {
      showSnackBar(context, message: 'تمت إضافة الكتاب بنجاح');
      isLoading = false;
      Navigator.pop(context);
      image = null;
      bookNameController.clear();
      authorNameController.clear();
      bookCopiesController.clear();
      bookPartsController.clear();
      update();
    });
  }

  // ======================( تعديل كتاب )=====================
  Future<void> editBook(
    BuildContext context, {
    required String docID,
  }) async {
    isLoading = true;
    update();

    if (image != null) {
      FirebaseStorage.instance
          .ref()
          .child(
            // ${Uri.file(image!.path).pathSegments.last}
            'books/$docID/cover',
          )
          .putFile(image!)
          .then(
        (value) {
          return value.ref.getDownloadURL().then(
                (image) => FirebaseFirestore.instance
                    .collection('books')
                    .doc(docID)
                    .update(
                  {
                    'book-image': image,
                    'book-name': bookNameController.text.trim(),
                    'author-name': authorNameController.text.trim(),
                    'book-copies': bookCopiesController.text.trim(),
                    'book-parts': bookPartsController.text.trim(),
                  },
                ),
              );
        },
      ).whenComplete(() {
        showSnackBar(context, message: 'تم تعديل الكتاب بنجاح');
        isLoading = false;
        Navigator.pop(context);
        Navigator.pop(context);
        image = null;
        bookNameController.clear();
        authorNameController.clear();
        bookCopiesController.clear();
        bookPartsController.clear();
      });
    } else {
      FirebaseFirestore.instance.collection('books').doc(docID).update(
        {
          'book-name': bookNameController.text.trim(),
          'author-name': authorNameController.text.trim(),
          'book-copies': bookCopiesController.text.trim(),
          'book-parts': bookPartsController.text.trim(),
        },
      ).whenComplete(() {
        showSnackBar(context, message: 'تم تعديل الكتاب بنجاح');
        isLoading = false;
        Navigator.pop(context);
        Navigator.pop(context);
        bookNameController.clear();
        authorNameController.clear();
        bookCopiesController.clear();
        bookPartsController.clear();
        update();
      });
    }
  }

  // =======================( حذف كتاب )======================
  Future<void> deleteBook(
    BuildContext context, {
    required String docID,
  }) async {
    isLoading = true;
    update();

    DocumentSnapshot bookDoc =
        await FirebaseFirestore.instance.collection('books').doc(docID).get();

    if (bookDoc.exists) {
      String imageUrl = bookDoc.get('book-image');

      FirebaseStorage.instance.refFromURL(imageUrl).delete().then((_) {
        FirebaseFirestore.instance.collection('books').doc(docID).delete();
      }).whenComplete(() {
        showSnackBar(context, message: 'تم حذف الكتاب بنجاح');
        isLoading = false;
        Navigator.pop(context);
        Navigator.pop(context);
        update();
      });
    }
  }
}
