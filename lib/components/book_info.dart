import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_app/components/book_info_app_bar.dart';
import 'package:lib_app/styles/fonts.dart';
import 'package:lib_app/logic/app_logic.dart';

class BookInfo extends StatefulWidget {
  const BookInfo({
    super.key,
    required this.bookData,
    required this.size,
    required this.booksIndex,
    required this.authorsSet,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> bookData;
  final int booksIndex;
  final Size size;
  final Set<String> authorsSet;

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          const Duration(milliseconds: 500), // Adjust the duration for zoom out
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _scale = _animation.value;
        });
      });
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _previousScale = _scale;
    _controller.stop();
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = _previousScale * details.scale;
    });
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (var book in widget.bookData) {
      widget.authorsSet.add(book['author-name']);
    }

    List<String> titles = [
      'اسم المؤلف',
      'عدد نُسخ الكتاب',
      'عدد أجزاء الكتاب',
    ];

    List<String> subtitles = [
      widget.bookData[widget.booksIndex]['author-name'],
      widget.bookData[widget.booksIndex]['book-copies'],
      widget.bookData[widget.booksIndex]['book-parts'],
    ];
    return GetBuilder(
      init: AppLogic(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: BookInfoAppBar(
            controller: controller,
            bookData: widget.bookData,
            booksIndex: widget.booksIndex,
            size: widget.size,
          ),
        ),
        body: Container(
          height: widget.size.height,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // غلاف الكتاب
                  _bookCoverInBookInfoPage(context),

                  SizedBox(height: widget.size.height * 0.02),

                  // عنوان الكتاب
                  Center(
                    child: Text(
                      widget.bookData[widget.booksIndex]['book-name'],
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style: AppFonts.titles.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  SizedBox(height: widget.size.height * 0.02),

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

                          SizedBox(width: widget.size.width * 0.02),

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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _bookCoverInBookInfoPage(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Transform.scale(
            scale: _scale,
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: widget.bookData[widget.booksIndex]['book-image'],
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
      ),
    );
  }
}
