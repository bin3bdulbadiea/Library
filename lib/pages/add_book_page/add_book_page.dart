import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_app/components/book_data.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';
import 'package:lib_app/pages/add_book_page/add_cover_image.dart';
import 'package:lib_app/pages/add_book_page/add_book_page_app_bar.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage({super.key, required this.size});

  final Size size;

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
                    AddBookPageAppBar(controller: controller),

                    SizedBox(height: size.height * 0.01),

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
                            AddBookPageCoverImage(
                              size: size,
                              controller: controller,
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
