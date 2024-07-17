import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_app/components/books_details.dart';
import 'package:lib_app/logic/app_logic.dart';
import 'package:lib_app/pages/add_book_page/add_book_page.dart';
import 'package:lib_app/pages/home_page/home_page_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.bookData,
    required this.authorsSet,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final Set<String> authorsSet;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder(
      init: AppLogic(),
      builder: (controller) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: HomePageAppBar(
              size: size,
              bookData: bookData,
              authorsSet: authorsSet,
            ),
          ),
          floatingActionButton: FirebaseAuth.instance.currentUser?.uid != null
              ? StreamBuilder(
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
                      return FloatingActionButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBookPage(size: size),
                          ),
                        ),
                        child: const Icon(Icons.add),
                      );
                    }
                  },
                )
              : const SizedBox(),
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
            child: BooksDetails(bookData: bookData, size: size),
          ),
        ),
      ),
    );
  }
}
