import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/provider1.dart';
import 'package:flutterapp/route.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordlogin = TextEditingController();
  final emaillogin = TextEditingController();
  final nom = TextEditingController();
  final prenom = TextEditingController();
  final repeatpassword = TextEditingController();
  final phone = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    password.dispose();
    email.dispose();
    passwordlogin.dispose();
    emaillogin.dispose();
    nom.dispose();
    prenom.dispose();
    repeatpassword.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<priceChange>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.deepOrange, Colors.orange])),
        child: AnimatedCrossFade(
            firstChild: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 200,
                      right: 20,
                      left: 20,
                      child: Image(
                        image: AssetImage('images/PPPP.png'),
                        alignment: Alignment.center,
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 270),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 320,
                    color: Colors.transparent,
                    child: Card(
                      color: Colors.white10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                      child: Column(
                        children: <Widget>[
                          AnimatedContainer(
                            //height: 0,
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: null,
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 1, left: 1),
                            color: Colors.transparent,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextField(
                                controller: emaillogin,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Nom d\'utilisateur',
                                  border: InputBorder.none,
                                  hintText: 'Enter votre Nom d\'utilisateur',
                                  icon: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.person)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 1, left: 1),
                            color: Colors.transparent,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextField(
                                controller: passwordlogin,
                                autocorrect: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Mot de passe',
                                  border: InputBorder.none,
                                  hintText: 'Enter votre mot de passe',
                                  icon: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.lock)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              right: 30,
                            ),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                'Mot de passe oublier?',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 55,
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    top: 10,
                                    right: 5,
                                  ),
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      color: (bloc.clicked == false)
                                          ? Colors.blue
                                          : Colors.white,
                                      elevation: 5,
                                      onPressed: () async {
                                        if (bloc.clicked == false) {
                                          bloc.clickedBtn(true, 'login');
                                          try {
                                            String url =
                                                'https://prishock.com/wp-json/jwt-auth/v1/token';
                                            Map<String, String> headers = {
                                              "Content-type": "application/json"
                                            };
                                            String emaillogin1 =
                                                emaillogin.text;
                                            String passwordlogin1 =
                                                passwordlogin.text;
                                            String jsonb = '''{
                                        "username": "$emaillogin1",
                                        "password": "$passwordlogin1"
                                      }''';
                                            if (emaillogin1 != '' &&
                                                passwordlogin1 != '') {
                                              Response response = await post(
                                                  url,
                                                  headers: headers,
                                                  body: jsonb);
                                              Map data = json.decode(
                                                  response.body.toString());
                                              int statusCode =
                                                  response.statusCode;
                                              // Map response = data;
                                              if (statusCode == 200) {
                                                String token = data['token'];
                                                Response responseMe =
                                                    await http.get(
                                                  'https://prishock.com/wp-json/wp/v2/users/me',
                                                  headers: {
                                                    HttpHeaders
                                                            .authorizationHeader:
                                                        "Bearer $token"
                                                  },
                                                );
                                                Map dataMe = json.decode(
                                                    responseMe.body.toString());

                                                // bloc.sessionUser.addAll({
                                                //   "id": dataMe['id'],
                                                //   "token": dataMe['token'],
                                                //   "email": dataMe['user_email'],
                                                //   "name": dataMe[
                                                //       'user_display_name'],
                                                //   "scor": 0
                                                // });
                                                bloc.sessionUser['id'] =
                                                    int.parse(dataMe['id']
                                                        .toString());
                                                print(dataMe['id']);
                                                bloc.sessionUser['token'] =
                                                    token;
                                                bloc.sessionUser['email'] =
                                                    data['user_email'];
                                                bloc.sessionUser['name'] =
                                                    data['user_display_name'];
                                                bloc.sessionUser['scor'] = 0;
                                                bloc.saveData('id',
                                                    dataMe['id'].toString());
                                                bloc.saveData(
                                                    'token', token.toString());
                                                bloc.saveData(
                                                    'email',
                                                    data['user_email']
                                                        .toString());
                                                bloc.saveData(
                                                    'name',
                                                    data['user_display_name']
                                                        .toString());
                                                int idwish =
                                                    bloc.sessionUser['id'];
                                                Response wishlistrep =
                                                    await http.get(
                                                  'https://prishock.com/api/wishlist.php?code=icr0dev&user_id=$idwish&user_liste=show',
                                                  headers: {
                                                    HttpHeaders
                                                            .authorizationHeader:
                                                        "Bearer $token"
                                                  },
                                                );
                                                List zbi = json.decode(
                                                    wishlistrep.body
                                                        .toString());
                                                if (zbi == null ||
                                                    zbi.isEmpty) {
                                                  bloc.wishliste.add(0);
                                                } else {
                                                  bloc.wishliste.addAll(json
                                                      .decode(wishlistrep.body
                                                          .toString()));
                                                }
                                                Response scorerep =
                                                    await http.get(
                                                  'https://prishock.com/wc-api/v3/orders?filter[limit]=-1&consumer_key=ck_66a4275df13881f5c2012aeb9795f6d181717421&consumer_secret=cs_abd6b7fdc7ec5e83582a9f2a0c96bb21ce392f91',
                                                  headers: {
                                                    "Accept": "application/json"
                                                  },
                                                );
                                                Map maps = json.decode(
                                                    scorerep.body.toString());
                                                List orderhistorie =
                                                    maps['orders'];
                                                for (var i = 0;
                                                    i < orderhistorie.length;
                                                    i++) {
                                                  print(orderhistorie[i]
                                                      ['customer_id']);
                                                  if (orderhistorie[i]
                                                          ['customer_id'] ==
                                                      bloc.sessionUser['id']&&
                                                      orderhistorie[i]
                                                          ['status'].toString() ==
                                                      'completed') {
                                                    bloc.sessionUser[
                                                        'scor'] = int.parse(bloc
                                                            .sessionUser['scor']
                                                            .toString()) +
                                                        1;
                                                  }
                                                }
                                                bloc.saveData(
                                                    'id',
                                                    bloc.sessionUser["id"]
                                                        .toString());
                                                bloc.saveData(
                                                    'email',
                                                    bloc.sessionUser["email"]
                                                        .toString());
                                                bloc.saveData(
                                                    'name',
                                                    bloc.sessionUser["name"]
                                                        .toString());
                                                bloc.saveData(
                                                    'scor',
                                                    bloc.sessionUser["scor"]
                                                        .toString());
                                                bloc.saveData('wishlist',
                                                    bloc.wishliste.toString());
                                                // bloc.saveData('id', bloc.sessionUser["id"].toString());
                                                bloc.notify();
                                                print(bloc.sessionUser);

                                                bloc.clickedBtn(false, 'login');
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                  builder: (context) =>
                                                      RouteScreen(),
                                                ));
                                              } else {
                                                Alert(
                                                        context: context,
                                                        title: 'login erreur',
                                                        desc:
                                                            'Les donnees ne correspondent pas.')
                                                    .show();
                                                bloc.clickedBtn(false, 'login');
                                              }
                                            } else {
                                              Alert(
                                                      context: context,
                                                      title: 'login erreur',
                                                      desc:
                                                          'Remplissez les chomps'
                                                              .toString())
                                                  .show();
                                              bloc.clickedBtn(false, 'login');
                                            }
                                            bloc.clickedBtn(false, 'login');
                                          } on SocketException {
                                            bloc.clickedBtn(false, 'login');
                                            Widget cancelButton = FlatButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                            // set up the AlertDialog
                                            AlertDialog alert = AlertDialog(
                                              title:
                                                  Text("Erreur de connexion"),
                                              content: Text(
                                                  'Vérifier votre connexion internet'),
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
                                      child: (bloc.clicked == false)
                                          ? Text(
                                              'Connexion',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          : CircularProgressIndicator(
                                              backgroundColor:
                                                  Colors.deepOrange,
                                            )),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 55,
                                  padding: EdgeInsets.only(
                                    right: 10,
                                    left: 5,
                                    top: 10,
                                  ),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: Colors.white,
                                    elevation: 5,
                                    onPressed: () {
                                      if (bloc.clicked == false) {
                                        bloc.sessionUser['id'] = 0;
                                        bloc.sessionUser['email'] =
                                            'Guest@guest.con';
                                        bloc.sessionUser['name'] = 'Guest';
                                        bloc.sessionUser['scor'] = 0;
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) => MyHomePage(),
                                        ));
                                      }
                                    },
                                    child: Text(
                                      'Decouvrir',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
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
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: Colors.green,
                                    elevation: 5,
                                    onPressed: () {
                                      if (bloc.clicked == false) {
                                        bloc.switcheinslogin(true);
                                      }
                                    },
                                    child: Text(
                                      'inscription',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
//******************************************************inscription */
            secondChild: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 90,
                      right: 20,
                      left: 20,
                      child: Container(
                        width: 90,
                        height: 90,
                        child: Image(
                          image: AssetImage('images/logo.png'),
                          alignment: Alignment.center,
                        ),
                      )),
                  Positioned(
                      top: 200,
                      right: 20,
                      left: 20,
                      child: Image(
                        image: AssetImage('images/PPPP.png'),
                        alignment: Alignment.center,
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 270),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    //height: 320,
                    color: Colors.transparent,
                    child: Card(
                      color: Colors.white10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, right: 1, left: 1),
                                  color: Colors.transparent,
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: TextField(
                                      controller: nom,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        labelText: 'Nom',
                                        border: InputBorder.none,
                                        hintText: 'Enter votre nom',
                                        icon: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Icon(Icons.person)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 20, right: 1, left: 1),
                                  color: Colors.transparent,
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: TextField(
                                      controller: prenom,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        labelText: 'Prenom',
                                        border: InputBorder.none,
                                        hintText: 'Enter votre prenom',
                                        icon: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Icon(Icons.person)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 1, left: 1),
                            color: Colors.transparent,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextField(
                                controller: phone,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Nom d\'utilisateur',
                                  border: InputBorder.none,
                                  hintText: 'Enter votre nom d\'utilisateur',
                                  icon: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.person)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 1, left: 1),
                            color: Colors.transparent,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Email',
                                  border: InputBorder.none,
                                  hintText: 'Enter votre email',
                                  icon: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.mail)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 1, left: 1),
                            color: Colors.transparent,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextField(
                                controller: password,
                                autocorrect: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Mot de passe',
                                  border: InputBorder.none,
                                  hintText: 'Enter votre mot de passe',
                                  icon: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.lock)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 1, left: 1),
                            color: Colors.transparent,
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextField(
                                controller: repeatpassword,
                                autocorrect: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  labelText: 'Repeter le mot de passe',
                                  border: InputBorder.none,
                                  hintText:
                                      'Enter votre mot de passe a nouveau',
                                  icon: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.lock)),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: 55,
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      top: 10,
                                      right: 5,
                                    ),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      color: (bloc.clicked == false)
                                          ? Colors.blue
                                          : Colors.grey[300],
                                      elevation: 5,
                                      onPressed: () {
                                        if (bloc.clicked == false) {
                                          bloc.switcheinslogin(false);
                                        }
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              flex: 5,
                                              child: Icon(
                                                Icons.arrow_back,
                                                color: Colors.white,
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: Text(
                                                'Login',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: 55,
                                    padding: EdgeInsets.only(
                                      right: 10,
                                      left: 5,
                                      top: 10,
                                    ),
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        color: Colors.green,
                                        elevation: 5,
                                        onPressed: () async {
                                          if (bloc.clicked == false) {
                                            if (nom.text != '' &&
                                                prenom.text != '' &&
                                                email.text != '' &&
                                                password.text != '' &&
                                                repeatpassword.text != '' &&
                                                phone.text != '') {
                                              if (password.text ==
                                                  repeatpassword.text) {
                                                if (EmailValidator.validate(
                                                    email.text)) {
                                                  bloc.clickedBtn(
                                                      true, 'login');
                                                  //********************************* */
                                                  String nom1 = nom.text;
                                                  String prenom1 = prenom.text;
                                                  String email1 = email.text;
                                                  var password1 = password.text;
                                                  var phone1 = phone.text;
                                                  String url =
                                                      'https://prishock.com/wp-json/wp/v2/users/register';
                                                  Map<String, String> headers =
                                                      {
                                                    "Content-type":
                                                        "application/json"
                                                  };
                                                  String json = '''
                                                  {"fname": "$prenom1",
                                              "lname": "$nom1",
                                              "username": "$phone1",
                                              "email": "$email1",
                                              "password": "$password1"}''';
                                                  Response response1 =
                                                      await post(url,
                                                          headers: headers,
                                                          body: json);
                                                  print(response1.body
                                                      .toString());
                                                  int statusCode =
                                                      response1.statusCode;
                                                  // Map reponse = jsonDecode(jsonEncode(response1.body));
                                                  print('after decode');

                                                  if (statusCode == 200) {
                                                    Alert(
                                                            context: context,
                                                            title:
                                                                'inscription',
                                                            desc:
                                                                'Inscription réussi')
                                                        .show();
                                                    bloc.switcheinslogin(true);
                                                  } else {
                                                    Alert(
                                                            context: context,
                                                            title:
                                                                'inscription erreur',
                                                            desc:
                                                                'Email ou nom d\'utilisateur deja pris.')
                                                        .show();
                                                  }

                                                  //********************************* */
                                                  bloc.clickedBtn(
                                                      false, 'login');
                                                } else {
                                                  Alert(
                                                          context: context,
                                                          title:
                                                              'inscription erreur',
                                                          desc:
                                                              'l\'email n\'est pas valid')
                                                      .show();
                                                  bloc.clickedBtn(
                                                      false, 'login');
                                                }
                                              } else {
                                                //fiel repeat password !passwod
                                                Alert(
                                                        context: context,
                                                        title:
                                                            'inscription erreur',
                                                        desc:
                                                            'Le Mote de passe ne correspond pas')
                                                    .show();
                                                bloc.clickedBtn(false, 'login');
                                              }
                                            } else {
                                              //all field is null
                                              Alert(
                                                      context: context,
                                                      title:
                                                          'inscription erreur',
                                                      desc:
                                                          'Remplissez tout les chomps')
                                                  .show();
                                              bloc.clickedBtn(false, 'login');
                                            }
                                          }
                                        },
                                        child: (bloc.clicked == false)
                                            ? Text(
                                                'inscrirs',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )
                                            : CircularProgressIndicator(
                                                backgroundColor:
                                                    Colors.deepOrange,
                                              )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: bloc.inscription == false
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 600)),
      ),
    );
  }
}
