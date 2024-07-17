import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_app/components/books_details.dart';
import 'package:lib_app/logic/app_logic.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.bookData});

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: GetBuilder(
        init: AppLogic(),
        builder: (controller) {
          var filteredBooks = widget.bookData
              .where((book) =>
                  book['book-name'].toString().toLowerCase().contains(
                      controller.searchController.text.toLowerCase()) ||
                  book['author-name']
                      .toString()
                      .toLowerCase()
                      .contains(controller.searchController.text.toLowerCase()))
              .toList();

          // ترتيب الكتب بناء على أبجديتها
          filteredBooks.sort((a, b) {
            var titleA = a['book-name'] as String;
            var titleB = b['book-name'] as String;
            return titleA.compareTo(titleB);
          });

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.searchController.clear();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                titleSpacing: 10,
                // البحث عن كتاب
                title: TextFormField(
                  controller: controller.searchController,
                  onChanged: (value) => setState(
                    () => controller.searchController.text = value,
                  ),
                  autofocus: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () => setState(
                              () => controller.searchController.clear(),
                            ),
                            icon: const Icon(Icons.cancel),
                          ),
                    hintText: 'البحث عن كتاب أو مؤلف',
                  ),
                ),
              ),
              body: controller.searchController.text.isNotEmpty
                  // نتيجة البحث
                  ? Container(
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
                      child: BooksDetails(
                        bookData: filteredBooks,
                        size: size,
                      ),
                    )
                  // جميع الكتب التي بالمكتبة
                  : Container(
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
                      child: BooksDetails(
                        bookData: widget.bookData,
                        size: size,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
