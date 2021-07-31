import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/provider1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';
import 'ad_manager.dart';
import 'loginPage.dart';
import 'main.dart';

// class RouteScreen extends StatefulWidget {
//   @override
//   _RouteScreenState createState() => _RouteScreenState();
// }

// class _RouteScreenState extends State<RouteScreen> {
//   int redirect;
//   List wish = List();
//   Map sessionUser = Map();
//   Future<void> getData() async {
//     print('okkkoo');
//     SharedPreferences data = await SharedPreferences.getInstance();
//     String id = data.getString('id');
//     if (id == null) {
//       setState(() {
//         redirect = 0;
//       });
//     } else {
//       print(data.getString('wishlist'));
//       sessionUser.addAll({
//         "id": int.parse(data.getString('id')),
//         "email": data.getString('email'),
//         "name": data.getString('name'),
//         "scor": int.parse(data.getString('scor'))
//       });
//       setState(() {
//         redirect = 1;
//         print('json == ' + data.getString('wishlist'));
//         wish.addAll(json.decode(data.getString('wishlist')));
//       });
//     }
//   }

//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bloc = Provider.of<priceChange>(context);
//     print(redirect);
//     if (redirect == 0) {
//       return LoginPage();
//     } else {
//       bloc.sessionUser.addAll(sessionUser);
//       bloc.wishliste.clear();
//       wish.forEach((element) {
//         bloc.wishliste.add(num.parse(element.toString()));
//       });
//       print(bloc.wishliste);
//       return MyHomePage(
//         title: 'Prishock',
//       );
//     }
//   }
// }
List wishRoute = List();

class RouteScreen extends StatefulWidget {
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  int redirect;
  bool onece = false;

  Map sessionUser1 = Map();

  Future<void> getData() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String id = data.getString('id');
    if (id == null) {
      setState(() {
        redirect = 0;
      });
    } else {
      setState(() {
        redirect = 1;
        sessionUser1.addAll({
          "id": int.parse(data.getString('id')),
          "email": data.getString('email'),
          "name": data.getString('name'),
          "scor": int.parse(data.getString('scor'))
        });
        priceChange().wishliste.clear();
        wishRoute.addAll(json.decode(data.getString('wishlist')));
        priceChange().sessionUser.addAll(sessionUser1);
        wishRoute.forEach((element) {
          priceChange().wishliste.add(int.parse(element.toString()));
        });
        print(' wish ===' + wishRoute.toString());
        print('price chanfe wish ===' + priceChange().wishliste.toString());
        priceChange().notifyListeners();
      });
    }
  }

Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  void initState() {
    getData();
    onece = false;
    // price
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<priceChange>(context);
    print(redirect);
    if (redirect == 0) {
      return LoginPage();
    } else {
      bloc.sessionUser.addAll(sessionUser1);
      print('user == ' + bloc.sessionUser.toString());
      // if (onece == false) {
      //   bloc.wishliste.clear();
      //   wish.forEach((element) {
      //     bloc.wishliste.add(num.parse(element.toString()));
      //   });
      //   onece = true;
      // }
      print(bloc.wishliste);
      return MyHomePage(
        title: 'Prishock',
      );
    }
  }
}
