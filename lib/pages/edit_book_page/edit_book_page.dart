import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_app/components/book_data.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';
import 'package:lib_app/pages/edit_book_page/edit_book_page_app_bar.dart';
import 'package:lib_app/pages/edit_book_page/edit_book_page_cover_image.dart';

class EditBookPage extends StatelessWidget {
  const EditBookPage({
    super.key,
    required this.bookNameController,
    required this.authorNameController,
    required this.bookCopiesController,
    required this.bookPartsController,
    required this.size,
    required this.bookData,
    required this.booksIndex,
  });

  final Size size;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final int booksIndex;

  final TextEditingController bookNameController;
  final TextEditingController authorNameController;
  final TextEditingController bookCopiesController;
  final TextEditingController bookPartsController;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GetBuilder(
        init: AppLogic(),
        builder: (controller) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    // app bar
                    EditBookPageAppBar(
                      controller: controller,
                      bookData: bookData,
                      booksIndex: booksIndex,
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // إضافة صورة
                            Text(
                              'صورة الغلاف',
                              style: AppFonts.titles.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            EditBookPageCoverImage(
                              size: size,
                              bookData: bookData,
                              controller: controller,
                              booksIndex: booksIndex,
                            ),

                            SizedBox(height: size.height * 0.03),

                            // بيانات الكتاب
                            Text(
                              'بيانات الكتاب',
                              style: AppFonts.titles.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            CustomBookData(
                              size: size,
                              controller: controller,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
