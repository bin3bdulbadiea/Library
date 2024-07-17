import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:lib_app/components/snack_bar.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';

class EditBookPageAppBar extends StatelessWidget {
  const EditBookPageAppBar({
    super.key,
    required this.controller,
    required this.bookData,
    required this.booksIndex,
  });

  final AppLogic controller;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final int booksIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // arrow back
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            controller.image = null;
            controller.bookNameController.clear();
            controller.authorNameController.clear();
            controller.bookCopiesController.clear();
            controller.bookPartsController.clear();
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),

        // حفظ
        ConditionalBuilder(
          condition: !controller.isLoading,
          builder: (context) => GestureDetector(
            onTap: () {
              if (controller.bookNameController.text.isEmpty ||
                  controller.authorNameController.text.isEmpty ||
                  controller.bookCopiesController.text.isEmpty ||
                  controller.bookPartsController.text.isEmpty) {
                showSnackBar(
                  context,
                  message: 'لا يمكن ترك الحقول فارغة',
                );
              } else {
                controller.editBook(
                  context,
                  docID: bookData[booksIndex]['doc-id'],
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'حفظ',
                style: AppFonts.titles.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          fallback: (context) => const CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
