import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_app/components/snack_bar.dart';
import 'package:lib_app/components/text_form_field.dart';
import 'package:lib_app/logic/app_logic.dart';
import 'package:lib_app/styles/fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GetBuilder(
        init: AppLogic(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
            title: const Text('تسجيل الدخول'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // البريد الإلكتروني
                  Text('البريد الإلكتروني', style: AppFonts.titles),
                  CustomTextFormField(
                    controller: controller.emailController,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: size.height * 0.01),

                  // كلمة المرور
                  Text('كلمة المرور', style: AppFonts.titles),
                  CustomTextFormField(
                    controller: controller.passwordController,
                    obscureText: controller.visibilityPassword,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: controller.suffix,
                    suffixPressed: controller.changePasswordVisibility,
                  ),

                  SizedBox(height: size.height * 0.02),

                  // تسجيل الدخول
                  ConditionalBuilder(
                    condition: !controller.isLoading,
                    builder: (context) => GestureDetector(
                      onTap: () {
                        if (controller.emailController.text.isEmpty ||
                            controller.passwordController.text.isEmpty) {
                          showSnackBar(
                            context,
                            message: 'لا يمكن ترك الحقول فارغة',
                          );
                        } else {
                          controller.login(context);
                        }
                      },
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'تسجيل الدخول',
                            style:
                                AppFonts.titles.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator(),
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
}