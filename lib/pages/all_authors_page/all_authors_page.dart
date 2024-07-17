import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/pages/author_list_books_page/author_list_books_page.dart';

class AllAuthorsPage extends StatelessWidget {
  const AllAuthorsPage({
    super.key,
    required this.bookData,
    required this.size,
    required this.authorsSet,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final Size size;
  final Set<String> authorsSet;

  @override
  Widget build(BuildContext context) {
    for (var book in bookData) {
      authorsSet.add(book['author-name']);
    }

    final List<String> authors = authorsSet.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('المؤلفين (${authors.length})'),
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
          itemCount: authors.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthorListBooksPage(
                  bookData: bookData,
                  authorName: authors[index],
                  size: size,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  authors[index],
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: AppFonts.titles.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
