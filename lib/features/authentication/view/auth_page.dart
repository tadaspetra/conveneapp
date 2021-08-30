import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Spacer(),
            Image(
              image: AssetImage("assets/wordsconvene.png"),
              height: 50,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Image(
                image: AssetImage("assets/reading.png"),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            CustomText(text: "Start your reading journey here"),
            SizedBox(
              height: 30,
            ),
            GoogleButton(),
            Spacer()
          ],
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BigButton(
      onPressed: () => AuthApi().signIn(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage("assets/google.png"),
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 18,
                  color: Palette.niceWhite,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
