import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterapp/provider1.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AccountParametre extends StatefulWidget {
  @override
  _AccountParametreState createState() => _AccountParametreState();
}

class _AccountParametreState extends State<AccountParametre> {
  final repeatpasswordch = TextEditingController();
  final passwordch = TextEditingController();
  final ancienpasswordch = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    repeatpasswordch.dispose();
    passwordch.dispose();
    ancienpasswordch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<priceChange>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => priceChange(),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Container(
            padding: EdgeInsets.only(right: 50),
            child: Center(
              child: Text(
                bloc.sessionUser['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(8),
                child: Text(
                  'Changer le mote de passe :',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, right: 1, left: 1),
                color: Colors.transparent,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    obscureText: true,
                    controller: ancienpasswordch,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'Ancien mote de passe',
                      border: InputBorder.none,
                      hintText: 'Enter votre mote de passe actuel',
                      icon: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.lock)),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(top: 20, right: 1, left: 1),
                      color: Colors.transparent,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          obscureText: true,
                          controller: passwordch,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'Nouveau',
                            border: InputBorder.none,
                            hintText: 'Enter votre mote de passe',
                            icon: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.lock)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(top: 20, right: 1, left: 1),
                      color: Colors.transparent,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          obscureText: true,
                          controller: repeatpasswordch,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'Repeter le mote de passe',
                            border: InputBorder.none,
                            hintText: 'Repeter votre mote de passe',
                            icon: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.lock)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 55,
                      padding: EdgeInsets.only(
                        right: 10,
                        left: 10,
                        top: 10,
                      ),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: Colors.green,
                        elevation: 5,
                        onPressed: () async {
                          if (bloc.clickedpass == false) {
                            bloc.clickedBtn(true,'pass');
                            if (passwordch.text != '' &&
                                repeatpasswordch.text != '' &&
                                ancienpasswordch.text != '') {
                              if (passwordch.text == repeatpasswordch.text) {
                                bloc.clickedBtn(true,'pass');
                                var ancienpassword1 = ancienpasswordch.text;
                                var password = passwordch.text;
                                var userId = bloc.sessionUser['id'];
                                Response response = await http.get(
                                    "https://prishock.com/api/changePS.php?code=icr0dev&user_id=$userId&password=$ancienpassword1&new_password=$password",
                                    headers: {
                                      "Accept": "application/json"
                                    }).timeout(Duration(seconds: 5),
                                    onTimeout: () {
                                  bloc.clickedBtn(false,'pass');
                                  Widget cancelButton = FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                  // set up the AlertDialog
                                  AlertDialog alert = AlertDialog(
                                    title: Text("Erreur de connexion"),
                                    content:
                                        Text("Verifie votre connexion et ressaiyer"),
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
                                  return null;
                                });
                                var convertDataToJson =
                                    jsonDecode(response.body.toString());
                                print(convertDataToJson['code']);
                                if (convertDataToJson['code'] == 200) {
                                  Alert(
                                          context: context,
                                          title: 'modification success',
                                          desc:
                                              'Le Mote de passe a bien ete changer')
                                      .show();
                                } else {
                                  Alert(
                                          context: context,
                                          title: 'modification erreur',
                                          desc: 'Une erreur est survenue')
                                      .show();
                                }
                                bloc.clickedBtn(false,'pass');
                              } else {
                                //fiel repeat password !passwod
                                Alert(
                                        context: context,
                                        title: 'modification erreur',
                                        desc:
                                            'Le Mote de passe ne correspond pas')
                                    .show();
                                bloc.clickedBtn(false,'pass');
                              }
                            } else {
                              //all field is null
                              Alert(
                                      context: context,
                                      title: 'modification erreur',
                                      desc: 'Remplissez tout les chomps')
                                  .show();
                              bloc.clickedBtn(false,'pass');
                            }
                          }
                        },
                        child: (bloc.clickedpass == false)
                            ? Text(
                                'Enregisrer',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            : CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
