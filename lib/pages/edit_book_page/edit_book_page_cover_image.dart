import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';

class EditBookPageCoverImage extends StatelessWidget {
  const EditBookPageCoverImage({
    super.key,
    required this.size,
    required this.bookData,
    required this.booksIndex,
    required this.controller,
  });

  final Size size;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final int booksIndex;
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
                      image: FileImage(
                        controller.image!,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : SizedBox(
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: bookData[booksIndex]['book-image'],
                      placeholder: (context, url) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            Text(
                              'جار تحميل الصورة',
                              textAlign: TextAlign.center,
                              style: AppFonts.titles,
                            ),
                          ],
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error),
                            Text(
                              'حدثت مشكلة أثناء تحميل الصورة',
                              textAlign: TextAlign.center,
                              style: AppFonts.titles,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

          SizedBox(width: size.width * 0.03),

          // إضافة الصورة من المعرض
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // المعرض
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
