import 'dart:convert';
import 'package:acumen_mbanking/Services/storage.dart';
import 'package:http/http.dart' as http;

Future<bool> checkValidity() async {
  //final prefs = await SharedPreferences.getInstance();

  String username = "admin@cloudpesateam";
  String password = "CloudPesa@2021.";

  final response= await http.get(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/GetToken"),
      headers: {
        "Username": username,
        "Password": password,
        "Accept": "application/json"
      }
  );
  //print(response.body);
  if (response.statusCode == 401) {
    final SecureStorage secureStorage = SecureStorage();
    secureStorage.deleteSecureToken('Token');
    secureStorage.deleteSecureToken('Telephone');
    secureStorage.deleteSecureToken('Password');
    return true;
  }
  else {
    return false;
  }
}