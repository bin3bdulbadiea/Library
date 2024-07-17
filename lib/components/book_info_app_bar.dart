import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';
import 'package:lib_app/pages/edit_book_page/edit_book_page.dart';

class BookInfoAppBar extends StatelessWidget {
  const BookInfoAppBar({
    super.key,
    required this.controller,
    required this.bookData,
    required this.booksIndex,
    required this.size,
  });

  final AppLogic controller;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final int booksIndex;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'تفاصيل الكتاب',
          style: TextStyle(fontSize: 20),
        ),

        // تعديل
        if (FirebaseAuth.instance.currentUser?.uid != null)
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where(
                  'user-id',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              var admin = snapshot.data?.docs[0]['is-admin'];

              if (!admin) {
                return const SizedBox();
              } else {
                return GestureDetector(
                  onTap: () {
                    controller.bookNameController.text =
                        bookData[booksIndex]['book-name'];
                    controller.authorNameController.text =
                        bookData[booksIndex]['author-name'];
                    controller.bookCopiesController.text =
                        bookData[booksIndex]['book-copies'];
                    controller.bookPartsController.text =
                        bookData[booksIndex]['book-parts'];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBookPage(
                          size: size,
                          bookData: bookData,
                          booksIndex: booksIndex,
                          bookNameController: controller.bookNameController,
                          authorNameController: controller.authorNameController,
                          bookCopiesController: controller.bookCopiesController,
                          bookPartsController: controller.bookPartsController,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'تعديل',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),

        // حذف
        if (FirebaseAuth.instance.currentUser?.uid != null)
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where(
                  'user-id',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              var admin = snapshot.data?.docs[0]['is-admin'];

              if (!admin) {
                return const SizedBox();
              } else {
                return ConditionalBuilder(
                  condition: !controller.isLoading,
                  builder: (context) => GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('حذف الكتاب'),
                        content: const Text('هل أنت متأكد من حذف هذا الكتاب؟'),
                        actions: [
                          // حذف
                          TextButton(
                            onPressed: () => controller.deleteBook(
                              context,
                              docID: bookData[booksIndex]['doc-id'],
                            ),
                            child: Text(
                              'حذف',
                              style:
                                  AppFonts.titles.copyWith(color: Colors.red),
                            ),
                          ),

                          // رجوع
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'رجوع',
                              style: AppFonts.titles,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'حذف',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                  fallback: (context) => const CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}
