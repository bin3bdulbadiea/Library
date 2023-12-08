import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/add_book_dialog.dart';
import 'package:library_app/book_details_dialog.dart';
import 'package:library_app/controller.dart';
import 'package:velocity_x/velocity_x.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(BooksController());

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: 'المكتبة'.text.size(25).make(),
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('books').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var data = snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      'عدد الكتب'.text.make(),
                      '${data.length}'.text.make(),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),

      // -------------------------

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade500,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddBookDialog(),
          );
        },
        tooltip: 'إضافة كتاب',
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // -------------------------

      body: SizedBox(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // search
            Container(
              color: Colors.grey,
              alignment: Alignment.center,
              child: TextFormField(
                cursorColor: Colors.black,
                controller: controller.searchController,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (value) {
                  if (value.isNotEmptyAndNotNull) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('books')
                              .get(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.data!.docs.isEmpty) {
                              return 'لا توجد كتب'
                                  .text
                                  .semiBold
                                  .size(16)
                                  .make();
                            } else {
                              var data = snapshot.data!.docs;

                              var filtered = data
                                  .where(
                                    (element) =>
                                        element['title'].toString().contains(
                                              controller.searchController.text,
                                            ),
                                  )
                                  .toList();

                              return GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  mainAxisExtent: context.screenHeight * 0.3,
                                ),
                                children: filtered
                                    .mapIndexed((currentValue, index) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Image.network(
                                                filtered[index]['image'],
                                                width: context.screenWidth / 2,
                                                fit: BoxFit.contain,
                                              ).box.makeCentered(),
                                            ),
                                            (context.screenHeight / 20)
                                                .heightBox,
                                            '${filtered[index]['title']}'
                                                .text
                                                .maxLines(1)
                                                .overflow(TextOverflow.ellipsis)
                                                .semiBold
                                                .make(),
                                          ],
                                        )
                                            .box
                                            .white
                                            .width(context.screenWidth * 0.5)
                                            .roundedSM
                                            .padding(const EdgeInsets.all(8))
                                            .make()
                                            .onTap(() {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                BookDetailsDialog(
                                              data: data[index],
                                            ),
                                          );
                                        }))
                                    .toList(),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.5),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'ابحث عن كتاب',
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                ),
              ),
            ).box.margin(const EdgeInsets.only(top: 10)).make(),

            // -----------------------

            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return 'لا توجد كتب'.text.makeCentered();
                } else {
                  var data = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: List.generate(
                        data.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            tileColor: Colors.white,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => BookDetailsDialog(
                                  data: data[index],
                                ),
                              );
                            },
                            leading: Image.network(
                              '${data[index]['image']}',
                              width: 30,
                            ),
                            title: '${data[index]['title']}'
                                .text
                                .bold
                                .size(20)
                                .maxLines(1)
                                .overflow(TextOverflow.ellipsis)
                                .make(),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          'هل تريد حذف الكتاب ؟'.text.make(),
                                          (context.screenHeight / 70).heightBox,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  controller.deleteBook(
                                                      data[index].id);
                                                  Get.back();
                                                },
                                                child: 'نعم'.text.make(),
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: 'لا'.text.make(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
