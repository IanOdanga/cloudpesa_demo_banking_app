import 'package:flutter/material.dart';
import 'package:acumen_mbanking/Screens/login_screen.dart';
import 'package:acumen_mbanking/Sub Screens/ChangePin/components/background.dart';
import 'package:acumen_mbanking/Sub Screens/Others/components/already_have_an_account_acheck.dart';
import 'package:acumen_mbanking/Sub Screens/Others/components/rounded_button.dart';
import 'package:acumen_mbanking/Sub Screens/Others/components/rounded_input_field.dart';
import 'package:acumen_mbanking/Sub Screens/Others/components/rounded_password_field.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _ChangePassBodyState createState() => _ChangePassBodyState();
}

class _ChangePassBodyState extends State<Body> {

  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  String oldPassword = '';
  String newPassword = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Reset Pin",
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Brand Bold"),
            ),
            SizedBox(height: size.height * 0.03),
            Image.asset(
              Constants.PIN_GIF_IMAGE,
              height: size.height * 0.35,
            ),
            RoundedPasswordField(
              controller: oldPasswordController,
              obscureText: true,
              keyboardType: TextInputType.number,
              validator: (value) {
                RegExp regex = RegExp(r'^.{4,}$');
                if (value.isEmpty) {
                  return ("Pin is required for login");
                }
                if (!regex.hasMatch(value)) {
                  return ("Enter Valid Pin(Min. 4 Character)");
                }
              },
              hintText: "Old M-Banking Pin",
              hintStyle: const TextStyle(fontFamily: "Brand Bold"),
              onChanged: (value) {
                oldPassword = value;
                oldPasswordController.text = oldPassword;
              },
            ),
            RoundedPasswordField(
              controller: newPasswordController,
              obscureText: true,
              keyboardType: TextInputType.number,
              validator: (value) {
                RegExp regex = RegExp(r'^.{4,}$');
                if (value.isEmpty) {
                  return ("Pin is required for login");
                }
                if (!regex.hasMatch(value)) {
                  return ("Enter Valid Pin(Min. 4 Character)");
                }
              },
              hintText: "New M-Banking Pin",
              hintStyle: const TextStyle(fontFamily: "Brand Bold"),
              onChanged: (value) {
                newPassword = value;
                newPasswordController.text = newPassword;
              },
            ),
            RoundedButton(
              text: "Reset Pin",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
