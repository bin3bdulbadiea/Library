import 'package:flutter/material.dart';
import 'package:lib_app/components/text_form_field.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';

class CustomBookData extends StatelessWidget {
  const CustomBookData({
    super.key,
    required this.size,
    required this.controller,
  });

  final Size size;
  final AppLogic controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان الكتاب
        Text('عنوان الكتاب', style: AppFonts.titles),
        CustomTextFormField(
          controller: controller.bookNameController,
          obscureText: false,
        ),

        SizedBox(height: size.height * 0.01),

        // اسم المؤلف
        Text('اسم المؤلف', style: AppFonts.titles),
        CustomTextFormField(
          controller: controller.authorNameController,
          obscureText: false,
        ),

        SizedBox(height: size.height * 0.01),

        // عدد النسخ & عدد الصفحات
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // عدد نسخ الكتاب
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عدد نُسخ الكتاب',
                  style: AppFonts.titles,
                ),
                SizedBox(
                  width: size.width * 0.45,
                  child: CustomTextFormField(
                    controller: controller.bookCopiesController,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                  ),
                ),
              ],
            ),

            // عدد أجزاء الكتاب
            SizedBox(
              width: size.width * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عدد أجزاء الكتاب',
                    style: AppFonts.titles,
                  ),
                  CustomTextFormField(
                    controller: controller.bookPartsController,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
