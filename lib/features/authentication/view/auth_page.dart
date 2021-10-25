import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthPage extends ConsumerWidget {
  final bool appleSignInAvailable;
  const AuthPage({Key? key, required this.appleSignInAvailable}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  final result = await ref.read(authApiProvider).signInWithApple();
                  result.fold((failure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
                  }, (_) {});
                },
              ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class GoogleButton extends ConsumerWidget {
  const GoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BigButton(
      onPressed: () async {
        final result = await ref.read(authApiProvider).signIn();

        ///- create extensions to handle this if there is no use for the right(result)
        result.fold((failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
        }, (_) {});
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
