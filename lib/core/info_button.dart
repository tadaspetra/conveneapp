import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  final String action;
  final String info;
  final Function() onPressed;
  const InfoButton({Key? key, required this.action, required this.info, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10.0, left: 5),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Flexible(child: CustomText(text: action)),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      info,
                      style: const TextStyle(color: Palette.niceDarkGrey),
                    ),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
