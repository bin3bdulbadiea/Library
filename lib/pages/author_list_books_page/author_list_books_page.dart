import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';
import 'package:lib_app/pages/author_list_books_page/display_book_info_in_modal_bottom_sheet.dart';

class AuthorListBooksPage extends StatelessWidget {
  const AuthorListBooksPage({
    super.key,
    required this.bookData,
    required this.authorName,
    required this.size,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final String authorName;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final authorBooks = bookData
        .where(
          (book) => book['author-name'] == authorName,
        )
        .toList();

    List<String> actions = ['تعديل', 'حذف'];
    List<Color> colors = [Colors.red, Colors.black];

    return GetBuilder(
      init: AppLogic(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(
            'قائمة " $authorName "',
            style: const TextStyle(fontSize: 15),
          ),
        ),
        body: GridView.builder(
          itemCount: authorBooks.length,
          padding: const EdgeInsets.all(15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, booksIndex) => GestureDetector(
            onTap: () => displayBookInfoInModalBottomSheet(
              context,
              booksIndex: booksIndex,
              controller: controller,
              colors: colors,
              actions: actions,
              size: size,
              authorBooks: authorBooks,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
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
                ),

                // عنوان الكتاب
                Container(
                  width: size.width,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      authorBooks[booksIndex]['book-name'],
                      textAlign: TextAlign.center,
                      maxLines: 7,
                      style: AppFonts.titles.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
