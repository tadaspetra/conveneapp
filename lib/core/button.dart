import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const BigButton({Key? key, required this.child, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(300, 60)),
        backgroundColor: MaterialStateProperty.all(Palette.niceBlack),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevation: MaterialStateProperty.all(10),
      ),
      child: child,
    );
  }
}
