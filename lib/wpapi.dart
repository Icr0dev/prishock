import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart';

Future<Map> fetchwppost(String urlJson) async {
  try {
    final response =
      await http.get(urlJson, headers: {"Accept": "application/json"});
  var convertDataToJson = jsonDecode(response.body);
  return convertDataToJson;
  } catch (e) {
    return null;
  }
}
Future<List> fetchwppostlist(String urlJson) async {
  final response =
      await http.get(urlJson, headers: {"Accept": "application/json"});
  var convertDataToJson = jsonDecode(response.body);
  return convertDataToJson;
}

makePostRequest(var id, var ratecount, var rateaverage, String name, String email, String message) async {
  ratecount = ratecount.toString();
  // set up POST request arguments
  String url =
      'https://prishock.com/wp-json/wc/v3/products/reviews?consumer_key=ck_66a4275df13881f5c2012aeb9795f6d181717421&consumer_secret=cs_abd6b7fdc7ec5e83582a9f2a0c96bb21ce392f91';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json =
      '{"product_id":$id, "review":"$message", "reviewer":"$name" ,"reviewer_email": "$email", "rating": "$rateaverage"}';
  // make POST request
  Response response = await post(url, headers: headers, body: json);
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  String body = response.body;
  // {
  //   "title": "Hello",
  //   "body": "body text",
  //   "userId": 1,
  //   "id": 101
  // }
  print(statusCode);
}

makePostRequestNewUsers(var id, var ratecount, var rateaverage) async {
  ratecount = ratecount.toString();
  String url =
      'https://prishock.com/wp-json/wc/v3/products/reviews?consumer_key=ck_66a4275df13881f5c2012aeb9795f6d181717421&consumer_secret=cs_abd6b7fdc7ec5e83582a9f2a0c96bb21ce392f91';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json =
      '{"product_id":$id, "review":"djack", "reviewer":"miloud" ,"reviewer_email": "gueste@gamil.com", "rating": "$rateaverage"}';
  Response response = await post(url, headers: headers, body: json);
  int statusCode = response.statusCode;
}

addusers(String nom, String prenom, String email, var password,
    var repeatpassword, var phone) async {
      String url =
          'https://prishock.com/wp-json/wp/v2/users/register';
      Map<String, String> headers = {"Content-type": "application/json"};
      //String username = prenom+'.'+nom+'.'+phone;
      String json = '''{
      "first_name": "$prenom",
      "last_name": "$nom",
      "username": "$phone",
      "email": "$email",
      "password": "$password"
      }''';
      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      print(response.body);
      return jsonDecode(response.body);
}


addcustomers(String nom, String prenom, String email, var password,
    var repeatpassword, var phone) async {
  if (nom != null &&
      prenom != null &&
      email != null &&
      password != null &&
      repeatpassword != null &&
      phone != null) {
    if (password == repeatpassword) {
      String url =
          'https://prishock.com/wp-json/wc/v3/customers?consumer_key=ck_66a4275df13881f5c2012aeb9795f6d181717421&consumer_secret=cs_abd6b7fdc7ec5e83582a9f2a0c96bb21ce392f91';
      Map<String, String> headers = {"Content-type": "application/json"};
      String username = prenom+'.'+nom+'.'+phone;
      String json = '''{
  "email": "$email",
  "first_name": "$prenom",
  "last_name": "$nom",
  "username": "$username",
  "billing": {
    "first_name": "$prenom",
    "last_name": "$nom",
    "company": "",
    "address_1": "",
    "address_2": "",
    "city": "",
    "state": "",
    "postcode": "",
    "country": "",
    "email": "$email",
    "phone": "$phone"
  }
}''';
      Response response = await post(url, headers: headers, body: json);
      int statusCode = response.statusCode;
    }
  }
}
