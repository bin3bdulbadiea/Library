import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lib_app/components/book_info.dart';
import 'package:lib_app/styles/fonts.dart';

class AllBooksPage extends StatelessWidget {
  const AllBooksPage({
    super.key,
    required this.bookData,
    required this.size,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final Size size;

  @override
  Widget build(BuildContext context) {
    var authorsSet = <String>{};
    for (var book in bookData) {
      authorsSet.add(book['author-name'] as String);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('الكتب (${bookData.length})'),
      ),
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(54, 186, 152, 1),
              Color.fromRGBO(233, 196, 106, 1),
              Color.fromRGBO(244, 162, 97, 1),
              Color.fromRGBO(231, 111, 81, 1),
            ],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: bookData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookInfo(
                  bookData: bookData,
                  size: size,
                  booksIndex: index,
                  authorsSet: authorsSet,
                ),
              ),
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
                      imageUrl: bookData[index]['book-image'],
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
                      bookData[index]['book-name'],
                      textAlign: TextAlign.center,
                      maxLines: 5,
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
