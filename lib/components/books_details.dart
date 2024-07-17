import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lib_app/components/book_info.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BooksDetails extends StatelessWidget {
  const BooksDetails({
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

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      shrinkWrap: true,
      itemCount: bookData.length,
      itemBuilder: (context, index) => MaterialButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () => Navigator.push(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 30,
          ),
          child: Row(
            children: [
              // غلاف الكتاب
              SizedBox(
                width: size.width * 0.4,
                height: size.height * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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

              SizedBox(width: size.width * 0.03),

              // تفاصيل الكتاب
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم الكتاب
                    Text(
                      '${bookData[index]['book-name']}',
                      maxLines: 6,
                      style: AppFonts.titles.copyWith(
                        fontSize: 17,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    // اسم المؤلف
                    Text(
                      '${bookData[index]['author-name']}',
                      style: AppFonts.titles.copyWith(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
