import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';
import 'package:lib_app/pages/edit_book_page/edit_book_page.dart';

Future<dynamic> displayBookInfoInModalBottomSheet(
  BuildContext context, {
  required int booksIndex,
  required AppLogic controller,
  required List<Color> colors,
  required List<String> actions,
  required Size size,
  required List<QueryDocumentSnapshot<Map<String, dynamic>>> authorBooks,
}) {
  List<String> titles = [
    'اسم المؤلف',
    'عدد نُسخ الكتاب',
    'عدد أجزاء الكتاب',
  ];
  List<String> subtitles = [
    authorBooks[booksIndex]['author-name'],
    authorBooks[booksIndex]['book-copies'],
    authorBooks[booksIndex]['book-parts'],
  ];

  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(),
    isScrollControlled: true,
    builder: (context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // الرجوع للخلف وتفاصيل الكتاب
            _arrowBackWithBookInfo(context, size),

            SizedBox(height: size.height * 0.02),

            // غلاف الكتاب
            _bookCover(size, authorBooks, booksIndex),

            SizedBox(height: size.height * 0.02),

            // عنوان الكتاب
            _bookTitle(authorBooks, booksIndex),

            SizedBox(height: size.height * 0.02),

            // بيانات الكتاب
            _bookData(titles, size, subtitles),

            SizedBox(height: size.height * 0.02),

            // التعديل على الكتاب أو حذفه
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
                    return _editBookDataOrDeleteIt(
                      controller,
                      authorBooks,
                      booksIndex,
                      context,
                      size,
                      colors,
                      actions,
                    );
                  }
                },
              ),
          ],
        ),
      ),
    ),
  );
}

Row _editBookDataOrDeleteIt(
  AppLogic controller,
  List<QueryDocumentSnapshot<Map<String, dynamic>>> authorBooks,
  int booksIndex,
  BuildContext context,
  Size size,
  List<Color> colors,
  List<String> actions,
) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        2,
        (index) => GestureDetector(
          onTap: () {
            if (index == 0) {
              // تعديل بيانات الكتاب
              controller.bookNameController.text =
                  authorBooks[booksIndex]['book-name'];
              controller.authorNameController.text =
                  authorBooks[booksIndex]['author-name'];
              controller.bookCopiesController.text =
                  authorBooks[booksIndex]['book-copies'];
              controller.bookPartsController.text =
                  authorBooks[booksIndex]['book-parts'];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBookPage(
                    bookNameController: controller.bookNameController,
                    authorNameController: controller.authorNameController,
                    bookCopiesController: controller.bookCopiesController,
                    bookPartsController: controller.bookPartsController,
                    size: size,
                    bookData: authorBooks,
                    booksIndex: booksIndex,
                  ),
                ),
              );
            } else {
              // حذف الكتاب
              controller.deleteBook(
                context,
                docID: authorBooks[booksIndex]['doc-id'],
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              actions[index],
              style: AppFonts.titles.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );

Container _bookData(
  List<String> titles,
  Size size,
  List<String> subtitles,
) =>
    Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        itemCount: titles.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // الرؤوس
            Text(
              titles[index],
              style: AppFonts.titles.copyWith(fontSize: 15),
            ),

            SizedBox(width: size.width * 0.02),

            // الفروع
            Expanded(
              child: Text(
                subtitles[index],
                textAlign: TextAlign.left,
                maxLines: 1,
                style: AppFonts.titles.copyWith(
                  fontSize: 15,
                  color: Colors.teal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );

Center _bookTitle(
  List<QueryDocumentSnapshot<Map<String, dynamic>>> authorBooks,
  int booksIndex,
) =>
    Center(
      child: Text(
        authorBooks[booksIndex]['book-name'],
        maxLines: 5,
        textAlign: TextAlign.center,
        style: AppFonts.titles.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

SizedBox _bookCover(
  Size size,
  List<QueryDocumentSnapshot<Map<String, dynamic>>> authorBooks,
  int booksIndex,
) =>
    SizedBox(
      height: size.height * 0.5,
      width: size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: authorBooks[booksIndex]['book-image'],
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
    );

Row _arrowBackWithBookInfo(
  BuildContext context,
  Size size,
) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // الرجوع للخلف
        GestureDetector(
          onTap: () => Navigator.pop(context),
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

        SizedBox(width: size.width * 0.02),

        // تفاصيل الكتاب
        Text(
          'تفاصيل الكتاب',
          style: AppFonts.titles.copyWith(
            fontSize: 20,
          ),
        ),
      ],
    );
