import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:lib_app/components/snack_bar.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';

class AddBookPageAppBar extends StatelessWidget {
  const AddBookPageAppBar({
    super.key,
    required this.controller,
  });

  final AppLogic controller;

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

        // إضافة
        ConditionalBuilder(
          condition: !controller.isLoading,
          builder: (context) => GestureDetector(
            onTap: () {
              if (controller.bookNameController.text.isEmpty ||
                  controller.authorNameController.text.isEmpty ||
                  controller.bookCopiesController.text.isEmpty ||
                  controller.bookPartsController.text.isEmpty ||
                  controller.image == null) {
                showSnackBar(
                  context,
                  message: 'لا يمكن ترك الحقول فارغة',
                );
              } else {
                controller.addBook(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(54, 186, 152, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'إضافة',
                style: AppFonts.titles.copyWith(color: Colors.white),
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
