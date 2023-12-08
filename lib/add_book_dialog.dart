import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/controller.dart';
import 'package:library_app/custom_text_form_field.dart';
import 'package:velocity_x/velocity_x.dart';

class AddBookDialog extends StatelessWidget {
  const AddBookDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(BooksController());

    var formKey = GlobalKey<FormState>();

    return Obx(
      () => Dialog(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  'إضافة كتاب'.text.size(25).make(),
                  (context.screenHeight / 100).heightBox,

                  // add photoe
                  controller.imagePath.isEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          maxRadius: 70,
                          child: const Icon(
                            Icons.add,
                            size: 50,
                          ),
                        ).onTap(
                          () => controller.pickImage(context),
                        )
                      : Container(
                          width: context.screenWidth / 2,
                          height: context.screenHeight / 5,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Image.file(
                            File(controller.imagePath.value),
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ).box.roundedFull.clip(Clip.antiAlias).make().onTap(
                                () => controller.pickImage(context),
                              ),
                        ),

                  (context.screenHeight / 100).heightBox,

                  //book name
                  CustomTextFormField(
                    controller: controller.bookNameController,
                    keyboardType: TextInputType.text,
                    hintText: 'اسم الكتاب',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'قم ملء الحقل';
                      }
                      return null;
                    },
                  ),
                  (context.screenHeight / 100).heightBox,

                  //author name
                  CustomTextFormField(
                    controller: controller.authorNameController,
                    keyboardType: TextInputType.text,
                    hintText: 'اسم المؤلف',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'قم ملء الحقل';
                      }
                      return null;
                    },
                  ),
                  (context.screenHeight / 100).heightBox,

                  //book place
                  CustomTextFormField(
                    controller: controller.bookPlaceController,
                    keyboardType: TextInputType.text,
                    hintText: 'مكان الكتاب',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'قم ملء الحقل';
                      }
                      return null;
                    },
                  ),
                  (context.screenHeight / 100).heightBox,

                  controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.black),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              controller.isLoading(true);
                              try {
                                controller.isLoading(true);
                                await controller.uploadImage();
                                await controller.uploadProduct(
                                  img: controller.imageLink,
                                );
                                Get.back();
                              } catch (e) {
                                controller.isLoading(false);

                                VxToast.show(context, msg: 'يجب إضافة صورة');
                              }
                            }
                          },
                          child: const Text('إضافة الكتاب'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
