import 'dart:async';
import 'dart:convert';
import 'package:acumen_mbanking/Screens/transaction_otp_screen.dart';
import 'package:acumen_mbanking/Widgets/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../constants.dart';

class Airtime extends StatefulWidget{
  static const String idScreen = "airtime";
  _AirtimeState createState() => _AirtimeState();
}

class _AirtimeState extends State<Airtime> {

  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  int amount = 0;

  bool isLoading = false;

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void init() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String? destAcc;
  String? phoneNo;
  late String message;
  bool? error;
  List data = List<String>.empty();

  String? _mySelection;

  List<String> bosaAccs = ["Safaricom", "Airtel", "Telkom"];

  List<String> phone = ["My Phone"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Airtime Purchase",
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Brand Bold",
            ),
          ),
          backgroundColor: Constants.MenuColor,
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
              children: <Widget>[
          Container(
          child: DropdownButton(
            isExpanded: true,
            value: destAcc,
            hint: const Text("Select Service Provider", style: TextStyle(fontFamily: "Brand-Regular"),),
            items: bosaAccs.map((destAccOne) {
              return DropdownMenuItem(
                child: Text(destAccOne, style: const TextStyle(fontFamily: "Brand-Regular"),),
                value: destAccOne,
              );
            }).toList(),
            onChanged: (value) {
              destAcc = value as String;
              //_getStateList();
            },
          ),
        ),
                const SizedBox(height: 10,),
                Container(
                  child: DropdownButton(
                    isExpanded: true,
                    value: phoneNo,
                    hint: const Text("Select Phone Number to buy", style: TextStyle(fontFamily: "Brand-Regular"),),
                    items: phone.map((destAccOne) {
                      return DropdownMenuItem(
                        child: Text(destAccOne, style: const TextStyle(fontFamily: "Brand-Regular"),),
                        value: destAccOne,
                      );
                    }).toList(),
                    onChanged: (value) {
                      phoneNo = value as String;
                      //_getStateList();
                    },
                  ),
                ),
                //const SizedBox(height: 1.0,),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    amount = int.parse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Brand-Regular"
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 30.0,),
                RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Container(
                      height: 50,
                      child: const Center(
                        child: Text(
                          "Purchase Airtime",
                          style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage(int.parse(amountController.text))));
                    }
                )
              ]
          ),
        )
    );
  }
  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage(int.parse(amountController.text))));
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to buy airtime worth Ksh. ${int.parse(amountController.text)}?",
        style: const TextStyle(fontFamily: "Brand Bold"),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  transferFunds(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "trans_otp": otp
    };

    print(data);
    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/AirtimePurchase"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );

    

    setState(() {
      isLoading=false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      snackBar("Transaction Successful!");

    } else {
      showCodeDialog(context);
    }
  }

  showCodeDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Failed", style: TextStyle(fontFamily: "Brand Bold"),),
      content: const Text("Incorrect OTP provided!", style: TextStyle(fontFamily: "Brand Bold"),),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}


