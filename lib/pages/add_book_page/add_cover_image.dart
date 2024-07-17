import 'package:flutter/material.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';

class AddBookPageCoverImage extends StatelessWidget {
  const AddBookPageCoverImage({
    super.key,
    required this.size,
    required this.controller,
  });

  final Size size;
  final AppLogic controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // صورة الكتاب
          controller.image != null
              ? Container(
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: FileImage(controller.image!),
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : Container(
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

          SizedBox(width: size.width * 0.03),

          Column(
            children: [
              // إضافة الصورة من المعرض
              InkWell(
                onTap: () => controller.pickImageGallery(context),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.photo_library, size: 20),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        'أضف صورة',
                        style: AppFonts.titles.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // حذف الصورة
              if (controller.image != null)
                InkWell(
                  onTap: () {
                    controller.image = null;
                    controller.update();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete,
                          size: 16,
                          color: Colors.red,
                        ),
                        SizedBox(width: size.width * 0.02),
                        Text(
                          'حذف الصورة',
                          style: AppFonts.titles.copyWith(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
