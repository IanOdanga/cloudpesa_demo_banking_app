import 'dart:convert';
import 'package:acumen_mbanking/Cards/cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../success_screen.dart';

class DepToBosa extends StatefulWidget{
  static const String idScreen = "deposits";
  @override
  _DepositToBosaPageState createState() => _DepositToBosaPageState();
}


class _DepositToBosaPageState extends State<DepToBosa>{

  TextEditingController amountController = TextEditingController();
  final radioController = TextEditingController();

  double? money;

  int amount = 0;

  late bool isLoading = false;

  String? destAcc;

  List<String> bosaAccs = ["Deposit Contribution", "Share Capital"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MPESA to BOSA',
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Brand Bold",
            ),
          ),
          backgroundColor: Constants.kPrimaryColor,
        ),
        backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
            children: <Widget>[
              Container(
                child: DropdownButton(
                  isExpanded: true,
                  value: destAcc,
                  hint: const Text("Select Bosa Account", style: TextStyle(fontFamily: "Brand-Regular"),),
                  items: bosaAccs.map((bosaAccsTypeOne) {
                    return DropdownMenuItem(
                      child: Text(bosaAccsTypeOne, style: const TextStyle(fontFamily: "Brand-Regular"),),
                      value: bosaAccsTypeOne,
                    );
                  }).toList(),
                  onChanged: (value) {
                    destAcc = value as String;
                    //_getStateList();
                  },
                ),
              ),
              const SizedBox(height: 10,),
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
                        "Deposit Money",
                        style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  onPressed: (){
                    showAlertDialog(context);
                  }
              )
            ]
        ),
      ),
    );
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
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
        depositMoney(destAcc.toString());
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to deposit Ksh. ${amountController.text} to ${destAcc.toString()}?",
        style: const TextStyle(fontFamily: "Brand-Regular"),),
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

  depositMoney(String accTo) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "amount": int.parse(amountController.text),
      "acc_to": accTo
    };

    print(data);
    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/Deposits"),
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

      Map<String,dynamic>res=jsonDecode(response.body);

      //Navigator.push(context, MaterialPageRoute(builder: (context) => Success()));

      snackBar("${res['Description']}");

    } else {
      Map<String,dynamic>res=jsonDecode(response.body);

      snackBar("${res['Description']}");
    }
  }
}