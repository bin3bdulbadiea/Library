import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_app/logic/app_logic.dart';
import 'package:lib_app/pages/login_page/login_page.dart';
import 'package:lib_app/pages/register_page/register_page.dart';
import 'package:lib_app/pages/search_page/search_page.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/pages/all_authors_page/all_authors_page.dart';
import 'package:lib_app/pages/all_books_page/all_books_page.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({
    super.key,
    required this.size,
    required this.bookData,
    required this.authorsSet,
  });

  final Size size;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final Set<String> authorsSet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'مكتبة الدكتور',
              style: TextStyle(fontSize: 10),
            ),
            Text(
              'حسين العريني',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),

        // فاصل
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: CircleAvatar(
            radius: 2,
            backgroundColor: Colors.black,
          ),
        ),

        Expanded(
          child: ShowBooksAndAuthorsORLogin(
            bookData: bookData,
            size: size,
            authorsSet: authorsSet,
          ),
        ),

        // بحث
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(bookData: bookData),
            ),
          ),
          icon: const Icon(Icons.search),
        ),

        // تسجيل الخروج
        if (FirebaseAuth.instance.currentUser?.uid != null)
          IconButton(
            onPressed: () => Get.put(AppLogic()).signout(context),
            icon: const Icon(Icons.logout),
          ),
      ],
    );
  }
}

class ShowBooksAndAuthorsORLogin extends StatelessWidget {
  const ShowBooksAndAuthorsORLogin({
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
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: const Text('هل لديك حساب؟'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.put(AppLogic()).emailController.clear();
                      Get.put(AppLogic()).passwordController.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text('نعم'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.put(AppLogic()).nameController.clear();
                      Get.put(AppLogic()).emailController.clear();
                      Get.put(AppLogic()).passwordController.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text('لا'),
                  ),
                ],
              ),
            ),
            child: const Text('تسجيل الدخول'),
          );
        } else {
          return Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              // الكتب
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllBooksPage(
                      bookData: bookData,
                      size: size,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'الكتب',
                      style: AppFonts.titles.copyWith(fontSize: 13),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Text(
                      '${bookData.length > 999 ? '+999' : bookData.length}',
                      style: AppFonts.numbers.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),

              // فاصل
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  radius: 2,
                  backgroundColor: Colors.black,
                ),
              ),

              // المؤلفين
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllAuthorsPage(
                      bookData: bookData,
                      size: size,
                      authorsSet: authorsSet,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'المؤلفين',
                      style: AppFonts.titles.copyWith(fontSize: 13),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Text(
                      '${authorsSet.length > 999 ? '+999' : authorsSet.length}',
                      style: AppFonts.numbers.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
