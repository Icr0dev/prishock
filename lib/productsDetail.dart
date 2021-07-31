import 'dart:convert';
import 'route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/provider1.dart';
import 'package:flutterapp/wpapi.dart';
import 'provider1.dart';
import 'package:http/http.dart' as http2;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductsDetaille extends StatefulWidget {
  final Map products;
  const ProductsDetaille(this.products);
  @override
  _ProductsDetailleState createState() => _ProductsDetailleState(products);
}

class _ProductsDetailleState extends State<ProductsDetaille> {
  final Map products;
  final comment = TextEditingController();
  _ProductsDetailleState(this.products);
  List wish = List();
  String dropdownValue;
  List<String> options;
  int varid;
  Map attrib;

  @override
  void initState() {
    if (products['type'].toString() == 'variable') {
      attrib = products['attributes'][0];
      varid = products['id'];
      options = List<String>.from(attrib['options']);
      dropdownValue = attrib['options'][0];
      varid = products['variations'][0]['id'];
      print(attrib);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (products['type'].toString()=='variable') {
    //   attrib = products['attributes'][0];
    //   varid=products['id'];
    //   options = List<String>.from(attrib['options']);
    // print(attrib);
    // }
    final bloc = Provider.of<priceChange>(context);
    int idwish = bloc.sessionUser['id'];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => priceChange(),
        )
      ],
      child: Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          title: Container(
            padding: EdgeInsets.only(right: 50),
            child: Center(
              child: Text(
                products['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.deepOrange,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              (products['images'].length > 1)
                  ? CarouselSlider.builder(
                      itemCount: products['images'].length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                              padding: EdgeInsets.only(top: 5),
                              height: 300,
                              child: Image.network(
                                  products['images'][index]['src'].toString())),
                      options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: true,
                        //viewportFraction: 0.9,
                        //aspectRatio: 2.0,
                        initialPage: 2,
                        height: 250,
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 5),
                      height: 300,
                      child: Card(
                          child: Image.network(
                              products['images'][0]['src'].toString()))),
              Container(
                padding: EdgeInsets.only(left: 15, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Html(data: products['description'])),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Prix :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        products['price'].toString() + ' DA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  (products['type'].toString() == 'variable')
                      ? !bloc.productsInCart.containsKey(products['id'])
                          ? Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(attrib['name']),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.red),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.red,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                        varid = products['variations']
                                            [options.indexOf(newValue)]['id'];
                                        print('var id == ' +
                                            products['variations'][options
                                                    .indexOf(newValue)]['id']
                                                .toString());
                                      });
                                    },
                                    items: options
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            )
                          : Container()
                      : Container(),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 5,
                      child: Container(
                        width: 180,
                        padding: EdgeInsets.only(left: 2, right: 15),
                        child: RaisedButton(
                          padding: EdgeInsets.only(left: 12),
                          textColor: (wishRoute.contains(products['id']))
                              ? Colors.white
                              : Colors.deepOrange,
                          color: (wishRoute.contains(products['id']))
                              ? Colors.deepOrange
                              : Colors.white,
                          onPressed: () async {
                            if (int.parse(bloc.sessionUser['id'].toString()) !=
                                0) {
                              if (bloc.clickedwish == false) {
                                List zbii = wishRoute;
                                bloc.clickedBtn(true, 'wish');
                                if (zbii.contains(products['id']) == false) {
                                  setState(() {
                                    zbii.add(products['id']);
                                  });
                                  // wish.addAll(bloc.wishliste.toList());
                                  // bloc.saveData(
                                  //     'wishlist', bloc.wishliste.toString());
                                } else {
                                  setState(() {
                                    zbii.remove(products['id']);
                                  });
                                  // wish.addAll(bloc.wishliste.toList());
                                }
                                print('Print befor sent : ' + zbii.toString());
                                Response bd = await http2.get(
                                  'https://prishock.com/api/wishlist.php?code=icr0dev&user_id=$idwish&user_liste=$zbii',
                                  headers: {"Accept": "application/json"},
                                );
                                zbii = json.decode(bd.body);
                                print('Print after sent : ' + zbii.toString());
                                // try {
                                //   await http.get(
                                //     'https://prishock.com/api/wishlist.php?code=icr0dev&user_id=$idwish&user_liste=' +
                                //         zbii.toString(),
                                //     headers: {
                                //       HttpHeaders.authorizationHeader: "Bearer "
                                //     },
                                //   );
                                //   bloc.clickedBtn(false, 'wish');
                                // } on SocketException {
                                //   bloc.clickedBtn(false, 'wish');
                                //   Widget cancelButton = FlatButton(
                                //     child: Text("Cancel"),
                                //     onPressed: () {
                                //       Navigator.pop(context);
                                //     },
                                //   );
                                //   // set up the AlertDialog
                                //   AlertDialog alert = AlertDialog(
                                //     title: Text("Erreur"),
                                //     content: Text(
                                //         'Vérifier votre connexion internet'),
                                //     actions: [
                                //       cancelButton,
                                //     ],
                                //   );

                                //   // show the dialog
                                //   showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return alert;
                                //     },
                                //   );
                                // } catch (e) {
                                //   print(e);
                                // }
                                bloc.saveData('wishlist', zbii.toString());
                                bloc.wishliste.clear();
                                wishRoute.clear();
                                wishRoute.addAll(zbii);
                                bloc.wishliste.addAll(zbii);
                                print(
                                    'bloc wish : ' + bloc.wishliste.toString());
                                bloc.clickedBtn(false, 'wish');
                              }
                            }
                            bloc.saveData(
                                'wishlist', bloc.wishliste.toString());
                            bloc.notify();
                            setState(() {});
                          },
                          child: (bloc.clickedwish == false)
                              ? Row(children: <Widget>[
                                  (wishRoute.contains(products['id']))
                                      ? Text('Suprimer du Favorit ')
                                      : Text('Ajouter au Favorit '),
                                  (wishRoute.contains(products['id']))
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border),
                                ])
                              : Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: (!bloc.productsInCart.containsKey(products['id']))
                          ? Container(
                              width: 180,
                              padding: EdgeInsets.only(left: 7, right: 10),
                              child: RaisedButton(
                                padding: EdgeInsets.only(left: 12),
                                textColor: Colors.white,
                                color: Colors.green,
                                onPressed: () {
                                  if (products['type'].toString() ==
                                      'variable') {
                                    bloc.addshop(
                                        products['id'],
                                        products['title'],
                                        1,
                                        num.parse(products['price']),
                                        products['images'][0]['src'],
                                        varid);
                                    print('tsttttt === ' +
                                        bloc.productsInCart.toString());
                                  } else {
                                    bloc.addshop(
                                        products['id'],
                                        products['title'],
                                        1,
                                        num.parse(products['price']),
                                        products['images'][0]['src'],
                                        0);
                                  }
                                  bloc.priceFunction(
                                      num.parse(products['price']), true);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text('Ajouter au panier'),
                                    Icon(Icons.add_shopping_cart),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(6),
                              height: 50,
                              color: Colors.white70,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          if (bloc.productsInCart[
                                                  products['id']]['qte'] >
                                              1) {
                                            int qte = bloc.productsInCart[
                                                    products['id']]['qte'] -
                                                1;
                                            if (products['type'].toString() ==
                                                'variable') {
                                              bloc.addshop(
                                                  products['id'],
                                                  products['title'],
                                                  qte,
                                                  num.parse(products['price']
                                                      .toString()),
                                                  products['images'][0]['src'],
                                                  varid);
                                              print('tstttt33 == ' +
                                                  bloc.productsInCart
                                                      .toString());
                                            } else {
                                              bloc.addshop(
                                                  products['id'],
                                                  products['title'],
                                                  qte,
                                                  num.parse(products['price']
                                                      .toString()),
                                                  products['images'][0]['src'],
                                                  0);
                                            }
                                            bloc.priceFunction(
                                                num.parse(products['price']
                                                    .toString()),
                                                false);
                                          } else {
                                            bloc.priceFunction(
                                                num.parse(products['price']),
                                                false);
                                            bloc.addshop(null, null, null, null,
                                                null, null);
                                            bloc.simpleBadge(
                                                bloc.productsInCart.length - 1);
                                            bloc.productsInCart
                                                .remove(products['id']);
                                            bloc.listProducts
                                                .remove(products['id']);
                                          }
                                        },
                                        elevation: 2.0,
                                        fillColor: Colors.red,
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                        shape: CircleBorder(),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 4,
                                      child: Container(
                                          width: double.infinity,
                                          child: Center(
                                              child: Text(
                                            bloc.productsInCart[products['id']]
                                                    ['qte']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )))),
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          int qte = bloc.productsInCart[
                                                  products['id']]['qte'] +
                                              1;
                                          if (products['type'].toString() ==
                                              'variable') {
                                            bloc.addshop(
                                                products['id'],
                                                products['title'],
                                                qte,
                                                num.parse(products['price']),
                                                products['images'][0]['src'],
                                                varid);
                                            print('tstttt22 === ' +
                                                bloc.productsInCart.toString());
                                          } else {
                                            bloc.addshop(
                                                products['id'],
                                                products['title'],
                                                qte,
                                                num.parse(products['price']),
                                                products['images'][0]['src'],
                                                0);
                                          }
                                          bloc.priceFunction(
                                              num.parse(products['price']),
                                              true);
                                        },
                                        elevation: 2.0,
                                        fillColor: Colors.green,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        shape: CircleBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 25),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Avis :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  (bloc.clickedrating == false)
                      ? Container(
                          margin: EdgeInsets.only(top: 25),
                          child: RatingBar(
                            initialRating:
                                double.parse(products['average_rating']),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              Widget continueButton = FlatButton(
                                child: Text("Envoyer"),
                                onPressed: () async {
                                  if (comment.text != '') {
                                    bloc.clickedBtn(true, 'rating');
                                    Navigator.pop(context);
                                    await makePostRequest(
                                        products['id'],
                                        1,
                                        rating,
                                        bloc.sessionUser['name'].toString(),
                                        bloc.sessionUser['email'].toString(),
                                        comment.text);
                                    bloc.clickedBtn(false, 'rating');
                                    comment.text = '';
                                  }
                                },
                              );
                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                title: Text("Donner votre avis"),
                                content: Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Nom: ' +
                                              bloc.sessionUser['name']
                                                  .toString())),
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
                                            controller: comment,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              labelText: 'Commentaire',
                                              border: InputBorder.none,
                                              hintText:
                                                  'Enter votre Commentaire',
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
                              bloc.clickedBtn(false, 'rating');
                            },
                          ))
                      : Container(
                          child: Center(child: CircularProgressIndicator())),
                ],
              ),
              SizedBox(
                width: 200,
                height: 20,
                child: Text('____________________________'),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Produits relative :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              (products['related_ids'].length > 0)
                  ? FutureBuilder(
                      future: fetchwppost(
                          'https://prishock.com/wc-api/v3/products?filter[limit]=-1&consumer_key=ck_66a4275df13881f5c2012aeb9795f6d181717421&consumer_secret=cs_abd6b7fdc7ec5e83582a9f2a0c96bb21ce392f91'),
                      builder: (context, snapshot) {
                        List prodrelative = products['related_ids'];
                        if (snapshot.hasData) {
                          List<Map> dataFinal = List<Map>();
                          for (var i = 0;
                              i < snapshot.data['products'].length;
                              i++) {
                            Map snap = snapshot.data['products'][i];
                            //********************************************another fetchwppost with parameter idsubcat */
                            if (prodrelative.contains(snap['id'])) {
                              dataFinal.add(snap);
                            }
                            //********************************************and mouve this code in new function */
                          }
                          return CarouselSlider.builder(
                            itemCount: dataFinal.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              width: 350,
                              color: Colors.transparent,
                              child: GridTile(
                                  child: Container(
                                height: 200,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  child: Card(
                                      elevation: 4,
                                      child: GridTile(
                                          header: Container(
                                            color: Colors.green,
                                            padding: EdgeInsets.all(2),
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              dataFinal[index]['price']
                                                      .toString() +
                                                  ' DA',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          footer: (!bloc.productsInCart
                                                  .containsKey(
                                                      dataFinal[index]['id']))
                                              ? Container(
                                                  padding: EdgeInsets.all(6),
                                                  height: 50,
                                                  color: Colors.white70,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 7,
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Center(
                                                            child: Text(
                                                              dataFinal[index]
                                                                  ['title'],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      dataFinal[index]['type'].toString() != 'variable'
                                                      ?Flexible(
                                                        flex: 3,
                                                        child: Container(
                                                          child:
                                                              RawMaterialButton(
                                                            onPressed: () {
                                                              bloc.addshop(
                                                                  dataFinal[
                                                                          index]
                                                                      ['id'],
                                                                  dataFinal[
                                                                          index]
                                                                      ['title'],
                                                                  1,
                                                                  num.parse(dataFinal[
                                                                          index]
                                                                      [
                                                                      'price']),
                                                                  dataFinal[
                                                                          index]
                                                                      ['image'],
                                                                  0);
                                                              bloc.priceFunction(
                                                                  dataFinal[
                                                                          index]
                                                                      ['price'],
                                                                  true);
                                                            },
                                                            elevation: 2.0,
                                                            fillColor:
                                                                Colors.green,
                                                            child: Icon(
                                                              Icons
                                                                  .add_shopping_cart,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            shape:
                                                                CircleBorder(),
                                                          ),
                                                        ),
                                                      ):Container()
                                                    ],
                                                  ))
                                              : Container(
                                                  padding: EdgeInsets.all(6),
                                                  height: 50,
                                                  color: Colors.white70,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 3,
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          child:
                                                              RawMaterialButton(
                                                            onPressed: () {
                                                              if (bloc.productsInCart[
                                                                      dataFinal[
                                                                              index]
                                                                          [
                                                                          'id']]['qte'] >
                                                                  1) {
                                                                int qte = bloc
                                                                        .productsInCart[dataFinal[
                                                                            index]
                                                                        [
                                                                        'id']]['qte'] -
                                                                    1;
                                                                 if (dataFinal[index]['type'].toString() == 'variable') {
                                                                bloc.addshop(
                                                                  dataFinal[index]['id'],
                                                                  dataFinal[index][
                                                                      'title'],
                                                                  qte,
                                                                  num.parse(dataFinal[index][
                                                                      'price']),
                                                                  dataFinal[index]['images']
                                                                          [0]
                                                                      ['src'],bloc.productsInCart[
                                                                          dataFinal[index][
                                                                              'id']]['varid']);   
                                                              } else {
                                                                bloc.addshop(
                                                                  dataFinal[index]['id'],
                                                                  dataFinal[index][
                                                                      'title'],
                                                                  qte,
                                                                  num.parse(dataFinal[index][
                                                                      'price']),
                                                                  dataFinal[index]['images']
                                                                          [0]
                                                                      ['src'],0);
                                                              }
                                                                bloc.priceFunction(
                                                                    num.parse(dataFinal[
                                                                            index]
                                                                        [
                                                                        'price']),
                                                                    false);
                                                              } else {
                                                                bloc.productsInCart
                                                                    .remove(dataFinal[
                                                                            index]
                                                                        ['id']);
                                                                bloc.listProducts
                                                                    .remove(dataFinal[
                                                                            index]
                                                                        ['id']);
                                                                bloc.addshop(
                                                                    null,
                                                                    null,
                                                                    null,
                                                                    null,
                                                                    null,
                                                                    null);
                                                                bloc.simpleBadge(bloc
                                                                        .productsInCart
                                                                        .length -
                                                                    1);
                                                                bloc.priceFunction(
                                                                    num.parse(dataFinal[
                                                                            index]
                                                                        [
                                                                        'price']),
                                                                    false);
                                                              }
                                                            },
                                                            elevation: 2.0,
                                                            fillColor:
                                                                Colors.red,
                                                            child: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            shape:
                                                                CircleBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                          flex: 4,
                                                          child: Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Center(
                                                                  child: Text(
                                                                bloc.productsInCart[
                                                                        dataFinal[index]
                                                                            [
                                                                            'id']]
                                                                        ['qte']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )))),
                                                      Flexible(
                                                        flex: 3,
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          child:
                                                              RawMaterialButton(
                                                            onPressed: () {
                                                              int qte = bloc
                                                                      .productsInCart[dataFinal[
                                                                          index]
                                                                      [
                                                                      'id']]['qte'] +
                                                                  1;
                                                              if (dataFinal[index]['type'].toString() == 'variable') {
                                                                bloc.addshop(
                                                                  dataFinal[index]['id'],
                                                                  dataFinal[index][
                                                                      'title'],
                                                                  qte,
                                                                  num.parse(dataFinal[index][
                                                                      'price']),
                                                                  dataFinal[index]['images']
                                                                          [0]
                                                                      ['src'],bloc.productsInCart[
                                                                          dataFinal[index][
                                                                              'id']]['varid']);   
                                                              } else {
                                                                bloc.addshop(
                                                                  dataFinal[index]['id'],
                                                                  dataFinal[index][
                                                                      'title'],
                                                                  qte,
                                                                  num.parse(dataFinal[index][
                                                                      'price']),
                                                                  dataFinal[index]['images']
                                                                          [0]
                                                                      ['src'],0);
                                                              }
                                                              bloc.priceFunction(
                                                                  num.parse(dataFinal[
                                                                          index]
                                                                      [
                                                                      'price']),
                                                                  true);
                                                            },
                                                            elevation: 2.0,
                                                            fillColor:
                                                                Colors.green,
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            shape:
                                                                CircleBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductsDetaille(
                                                              dataFinal[
                                                                  index])));
                                            },
                                            child: Image.network(
                                              dataFinal[index]['images'][0]
                                                      ['src']
                                                  .toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          ))),
                                ),
                              )),
                            ),
                            options: CarouselOptions(
                              autoPlay: false,
                              enlargeCenterPage: true,
                              //viewportFraction: 0.9,
                              //aspectRatio: 2.0,
                              initialPage: 2,
                              height: 250,
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })
                  : Container(
                      padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                      alignment: Alignment.center,
                      child: Text(
                        'Aucun produit relative.',
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
