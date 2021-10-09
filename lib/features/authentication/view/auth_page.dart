import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/apis/firebase/user.dart';
import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthPage extends StatelessWidget {
  final bool appleSignInAvailable;
  const AuthPage({Key? key, required this.appleSignInAvailable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Image(
              image: AssetImage("assets/wordsconvene.png"),
              height: 50,
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Image(
                image: AssetImage("assets/reading.png"),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            const CustomText(text: "Start your reading journey here"),
            const SizedBox(
              height: 30,
            ),
            const GoogleButton(),
            if (appleSignInAvailable)
              const SizedBox(
                height: 20,
              ),
            if (appleSignInAvailable)
              AppleSignInButton(
                onPressed: () async {
                  User user = await AuthApi().signInWithApple();
                  await UserApi().addUser(
                    uid: user.uid,
                    email: user.email,
                    name: user.displayName,
                  );
                },
              ),
            const Spacer()
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
      onPressed: () async {
        try {
          UserCredential user = await AuthApi().signIn();
          await UserApi().addUser(
            uid: user.user!.uid,
            email: user.user!.email!,
            name: user.user!.displayName,
          );
        } on PlatformException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
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
