import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BookDetailsDialog extends StatelessWidget {
  const BookDetailsDialog({super.key, this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              '${data['image']}',
              width: double.infinity,
              height: context.screenHeight * 0.4,
              fit: BoxFit.contain,
            ),
            '${data['title']}'.text.make(),
            Align(
              alignment: Alignment.center,
              child: '${data['author']}'.text.make(),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: '${data['place']}'.text.make(),
            ),
          ],
        ).box.white.padding(const EdgeInsets.all(10)).roundedSM.make(),
      ),
    );
  }
}
