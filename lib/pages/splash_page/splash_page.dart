import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lib_app/pages/home_page/home_page.dart';
import 'package:lib_app/styles/fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _showProgressIndicator = true;

  @override
  void initState() {
    super.initState();
    // إخفاء المؤشر بعد 3 ثوانٍ
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showProgressIndicator = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // صورة الوالد
            ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(30),
              child: Image.asset('assets/dad.png', scale: 4),
            ),

            SizedBox(height: size.height * 0.01),

            Text(
              'مكتبة الدكتور حسين العريني',
              style: AppFonts.titles.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: size.height * 0.01),

            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || _showProgressIndicator) {
                  return const CircularProgressIndicator(
                    color: Colors.black,
                  );
                }

                var bookData = snapshot.data!.docs;

                // ترتيب الكتب بناء على أبجديتها
                bookData.sort((a, b) {
                  var bookA = a['book-name'] as String;
                  var bookB = b['book-name'] as String;
                  var authorA = a['author-name'] as String;
                  var authorB = b['author-name'] as String;

                  // حيث يتم ترتيبها أولاً بناء على أسماء المؤلفين
                  var result = authorA.compareTo(authorB);
                  if (result != 0) {
                    return result;
                  }

                  // ثم أسماء الكتب
                  return bookA.compareTo(bookB);
                });

                // لحساب عدد المؤلفين بدون تكرار
                var authorsSet = <String>{};
                for (var book in bookData) {
                  authorsSet.add(book['author-name'] as String);
                }

                // الانتقال لصفحة الكتب عندما يتم تحميلها بالكامل ومرور 3 ثوانٍ
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        bookData: bookData,
                        authorsSet: authorsSet,
                      ),
                    ),
                  ),
                );

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
