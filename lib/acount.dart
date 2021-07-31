import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterapp/accountParam.dart';
import 'package:flutterapp/historique.dart';
import 'package:flutterapp/loginPage.dart';
import 'package:flutterapp/provider1.dart';
import 'package:flutterapp/route.dart';
import 'package:flutterapp/wishlistePage.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcountProfile extends StatefulWidget {
  @override
  _AcountProfileState createState() => _AcountProfileState();
}

class _AcountProfileState extends State<AcountProfile> {
  final feedbacktxt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<priceChange>(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(80),
                          bottomRight: Radius.circular(80)),
                    ),
                    width: double.infinity,
                    height: 130,
                  ),
                  Container(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 40,
                        ),
                        height: 180,
                        width: 140,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(color: Colors.white, spreadRadius: 3),
                            ],
                            border: Border.all(
                              color: Colors.deepOrange,
                              style: BorderStyle.solid,
                              width: 4.0,
                            ),
                          ),
                          child: (bloc.sessionUser['image'] != null)
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(
                                      bloc.sessionUser['image'].toString()),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage('images/guest.png'),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    margin: EdgeInsets.only(left: 30, right: 30, top: 200),
                    color: Colors.transparent,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 4.0,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 7,
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Flexible(
                                        flex: 5,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                              bottom: 5,
                                            ),
                                            alignment: Alignment.bottomCenter,
                                            height: double.infinity,
                                            child: Text(
                                              bloc.sessionUser['name']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange,
                                              ),
                                            ))),
                                    Flexible(
                                        flex: 5,
                                        child: Container(
                                            alignment: Alignment.topCenter,
                                            height: double.infinity,
                                            child: Text(
                                              bloc.sessionUser['email']
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Flexible(
                                        flex: 5,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                              bottom: 5,
                                            ),
                                            alignment: Alignment.bottomCenter,
                                            height: double.infinity,
                                            child: Text(
                                              'Scors',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange,
                                              ),
                                            ))),
                                    Flexible(
                                        flex: 5,
                                        child: Container(
                                            alignment: Alignment.topCenter,
                                            height: double.infinity,
                                            child: Text(
                                              bloc.sessionUser['scor']
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 60, left: 60, top: 15),
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      if (bloc.sessionUser['id'] != 0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WishListe()));
                      } else {
                        Alert(
                                context: context,
                                title: 'Permission interdit',
                                desc:
                                    'inscrivez-vous ou connecter a votre compte pour continuez')
                            .show();
                      }
                    },
                    leading: Icon(
                      Icons.favorite_border,
                      color: Colors.deepOrange,
                    ),
                    title: Text('Mes favorits'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HistoriqueDachats()));
                    },
                    leading: Icon(
                      Icons.history,
                      color: Colors.deepOrange,
                    ),
                    title: Text("Historique d'achats"),
                  ),
                  ListTile(
                    onTap: () {
                      if (bloc.sessionUser['id'] != 0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AccountParametre()));
                      } else {
                        Alert(
                                context: context,
                                title: 'Permission interdit',
                                desc:
                                    'inscrivez-vous ou connecter a votre compte pour continuez')
                            .show();
                      }
                    },
                    leading: Icon(
                      Icons.settings,
                      color: Colors.deepOrange,
                    ),
                    title: Text('Parametre de compte'),
                  ),
                  ListTile(
                    onTap: () {
                      if (bloc.clickedfeed == false) {
                        try {
                          Widget continueButton = FlatButton(
                            child: (bloc.clickedfeed == false)
                                ? Text("Envoyer")
                                : CircularProgressIndicator(),
                            onPressed: () async {
                              if (bloc.clickedfeed == false) {
                                Navigator.pop(context);
                                bloc.clickedBtn(true, 'feed');
                                String msg = feedbacktxt.text;
                                int iduser = bloc.sessionUser['id'];
                                Response feedbackrep = await http.get(
                                  'https://prishock.com/api/feedback.php?code=icr0dev&user_id=$iduser&message=show',
                                  headers: {"Accept": "application/json"},
                                );
                                msg = feedbackrep.body.toString() +
                                    ' -||- ' +
                                    msg;
                                Response feedbackrep1 = await http.get(
                                  'https://prishock.com/api/feedback.php?code=icr0dev&user_id=$iduser&message=$msg',
                                  headers: {"Accept": "application/json"},
                                );
                                feedbacktxt.text = '';
                                bloc.clickedBtn(false, 'feed');
                              }
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Signaler un probleme"),
                            content: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Nom: ' +
                                          bloc.sessionUser['name'].toString())),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Email: ' +
                                          bloc.sessionUser['email']
                                              .toString())),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 20, right: 1, left: 1),
                                    color: Colors.transparent,
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        controller: feedbacktxt,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          labelText: 'Message',
                                          border: InputBorder.none,
                                          hintText: 'Enter votre message',
                                          icon: Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Icon(Icons.feedback)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              continueButton,
                            ],
                          );

                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        } on SocketException {
                          bloc.clickedBtn(false, 'feed');
                          Widget cancelButton = FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Erreur de connexion"),
                            content: Text('Vérifier votre connexion internet'),
                            actions: [
                              cancelButton,
                            ],
                          );

                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    leading: (bloc.clickedfeed == false)
                        ? Icon(
                            Icons.feedback,
                            color: Colors.deepOrange,
                          )
                        : CircularProgressIndicator(),
                    title: Text('Signaler un probleme'),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.lightbulb_outline,
                      color: Colors.deepOrange,
                    ),
                    title: Text('A propos'),
                  ),
                  SizedBox(
                    height: 20,
                    child: Text('___________________'),
                  ),
                  ListTile(
                    onTap: () async {
                      if (bloc.clicked == false) {
                        // Update the given Dog.
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.clear();
                        bloc.sessionUser.clear();
                        bloc.wishliste.clear();
                        bloc.notify();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RouteScreen(),
                        ));
                      }
                    },
                    leading: Icon(
                      Icons.power_settings_new,
                      color: Colors.deepOrange,
                    ),
                    title: Text('Deconnexion'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
