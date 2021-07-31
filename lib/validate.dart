import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'provider1.dart';

class ValidationPanier extends StatefulWidget {
  @override
  _ValidationPanierState createState() => _ValidationPanierState();
}

class _ValidationPanierState extends State<ValidationPanier> {
  final adresseValid = TextEditingController();
  final stateValid = TextEditingController();
  final cpValid = TextEditingController();
  final phoneValid = TextEditingController();
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
                'Valider le panier',
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
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Remplisez vos information :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, right: 1, left: 15),
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Client : ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        bloc.sessionUser['name'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, right: 1, left: 15),
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Pays : ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Algerie',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
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
                      controller: stateValid,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Wilaya',
                        border: InputBorder.none,
                        hintText: 'Enter votre Wilaya',
                        icon: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.location_on)),
                      ),
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
                      controller: cpValid,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Code postal',
                        border: InputBorder.none,
                        hintText: 'Enter votre code postal',
                        icon: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.location_on)),
                      ),
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
                      controller: adresseValid,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Adresse',
                        border: InputBorder.none,
                        hintText: 'Enter votre adresse',
                        icon: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.location_on)),
                      ),
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
                      keyboardType: TextInputType.phone,
                      controller: phoneValid,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Telephone',
                        border: InputBorder.none,
                        hintText: 'Enter votre numero de telephone',
                        icon: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.phone)),
                      ),
                    ),
                  ),
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Prix de vos achats : ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        bloc.intNumber.toString()+' DA',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Prix de livraison : ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '400 DA Oran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Prix total : ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        (num.parse(bloc.intNumber.toString())+400).toString()+' DA',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 70,
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
                            //code de creation de commande**************
                            List<Map> prodactToOrder = List<Map>();
                            void iterateMapEntry(key, value) {
                              if (key != 0) {
                                if (value['varid'] != 0) {
                                  prodactToOrder.addAll([
                                    {
                                      "\"product_id\"": key,
                                      "\"variation_id\"": value['varid'],
                                      "\"quantity\"": value['qte']
                                    }
                                  ]);
                                } else {
                                  prodactToOrder.addAll([
                                    {
                                      "\"product_id\"": key,
                                      "\"quantity\"": value['qte']
                                    }
                                  ]);
                                }
                              }
                            }

                            bloc.productsInCart.forEach(iterateMapEntry);
                            if (stateValid.text != '' &&
                                cpValid.text != '' &&
                                adresseValid.text != '' &&
                                phoneValid.text != '') {
                              int idClient =
                                  int.parse(bloc.sessionUser['id'].toString());
                              var state = stateValid.text;
                              var cp = cpValid.text;
                              var adresse = adresseValid.text;
                              var phone = phoneValid.text;
                              String productValid = prodactToOrder.toString();
                              print(productValid);
                              String url =
                                  'https://prishock.com/wp-json/wc/v3/orders?consumer_key=ck_66a4275df13881f5c2012aeb9795f6d181717421&consumer_secret=cs_abd6b7fdc7ec5e83582a9f2a0c96bb21ce392f91';
                              Map<String, String> headers = {
                                "Content-type": "application/json"
                              };
                              String json = '''{
                                "payment_method": "bacs",
                                "payment_method_title": "Virement bancaire",
                                "set_paid": true,
	                              "customer_id": $idClient,
                                "billing": {
                                  "address_1": "$adresse",
                                  "address_2": "",
                                  "city": "$state",
                                  "state": "$state",
                                  "postcode": "$cp",
                                  "country": "Algerie",
                                  "phone": "$phone"
                                },
                                "shipping": {
                                  "address_1": "$adresse",
                                  "address_2": "",
                                  "city": "$state",
                                  "state": "$state",
                                  "postcode": "$cp",
                                  "country": "Algerie"
                                },
                                "line_items": ''' +
                                  productValid +
                                  '''
                              }''';
                              bloc.clickedBtn(true, 'insc');
                              Response response =
                                  await post(url, headers: headers, body: json);
                              int statusCode = response.statusCode;
                              Map reponse = jsonDecode(response.body);
                              bloc.clickedBtn(false, 'insc');
                              print(statusCode);
                              if (statusCode == 200 || statusCode == 201) {
                                stateValid.text = '';
                                cpValid.text = '';
                                adresseValid.text = '';
                                phoneValid.text = '';
                                bloc.sessionUser['scor'] = int.parse(
                                        bloc.sessionUser['scor'].toString()) +
                                    1;
                                bloc.saveData('scor',
                                    bloc.sessionUser["scor"].toString());
                                bloc.saveData(
                                    'wishlist', bloc.wishliste.toString());
                                bloc.notify();
                                bloc.deleteallcart();
                                bloc.simpleBadge(
                                    bloc.productsInCart.length - 1);
                                Widget continueButton = FlatButton(
                                  child: Text("Ok"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );

                                // set up the AlertDialog
                                AlertDialog alert = AlertDialog(
                                  title: Text("Commande passer"),
                                  content: Text(
                                      "nous avons recue votre commande, quellqun va vous appellez. soyez patient."),
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
                              }
                            } else {
                              Alert(
                                      context: context,
                                      title: 'Commande error',
                                      desc: 'Remplissez tout les information.')
                                  .show();
                            }
                          },
                          child: (bloc.clickedinsc == false)
                              ? Text(
                                  'Valider Votre commande',
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
      ),
    );
  }
}
