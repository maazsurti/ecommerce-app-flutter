import 'package:ecommerce_app_flutter/common/routes/names.dart';
import 'package:ecommerce_app_flutter/common/service/storage_service.dart';
import 'package:ecommerce_app_flutter/common/widgets/flutter_toasts.dart';
import 'package:ecommerce_app_flutter/global.dart';
import 'package:ecommerce_app_flutter/pages/sign_in/bloc/sign_in_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/sign_in_bloc.dart';

class SignInController {
  final BuildContext context;
  const SignInController({required this.context});

  void handleSignIn(LoginType type) async {
    try {
      if (type == LoginType.email) {
        final state = context.read<SignInBloc>().state;
        String emailAddress = state.email;
        String password = state.password;

        if (emailAddress.isEmpty) {
          showToast(message: "Email address is empty");
          return;
        } else if (password.isEmpty) {
          showToast(message: "Password is empty");
          return;
        }

        try {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailAddress, password: password);

          var user = credential.user;

          if (user == null) {
            showToast(message: "User does not exist");
            return;
          } else if (!credential.user!.emailVerified) {
            showToast(message: "The email is not verified");
            return;
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoute.homePage, (route) => false);
            Global.storageService.setBool(Keys.isUserLoggedIn.name, true);
            print("Logged in users name is ${user.displayName}");
          }
        } on FirebaseException catch (e) {
          if (e.code == "user-not-found") {
            showToast(message: "No user found for that email");
          } else if (e.code == "wrong-password") {
            showToast(message: "Password is incorrect");
          } else if (e.code == "invalid-email") {
            showToast(message: "The email is formatted incorrectly");
          } else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
            showToast(message: "Login credentials are incorrect");
          } else {
            showToast(message: e.message ?? "");
            print(e.message);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

enum LoginType {
  email,
  thirdParty,
}
