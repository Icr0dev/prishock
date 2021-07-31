import 'package:flutter/material.dart';
import 'package:flutterapp/productsDetail.dart';
import 'package:flutterapp/provider1.dart';
import 'package:flutterapp/route.dart';
import 'main.dart';
import 'package:provider/provider.dart';

class WishListe extends StatefulWidget {
  @override
  _WishListeState createState() => _WishListeState();
}

class _WishListeState extends State<WishListe> {
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
                'Mes Favorits',
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
        body: Container(
          child: FutureBuilder(
            future: prodacts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map> dataFinal = List<Map>();
                for (var i = 0; i < snapshot.data['products'].length; i++) {
                  Map snap = snapshot.data['products'][i];
                  if (wishRoute.contains(snap['id']) == true) {
                    dataFinal.add(snap);
                  }
                }

                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: dataFinal.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map wppost1 = dataFinal[index];
                      return GridTile(
                          child: Container(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Card(
                              elevation: 4,
                              child: GridTile(
                                  header: Container(
                                    color: Colors.green,
                                    padding: EdgeInsets.all(2),
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      wppost1['price'].toString() + ' DA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  footer: (!bloc.productsInCart
                                          .containsKey(wppost1['id']))
                                      ? Container(
                                          padding: EdgeInsets.all(6),
                                          height: 50,
                                          color: Colors.white70,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                flex: 7,
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      wppost1['title'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              wppost1['type'].toString() != 'variable'
                                              ?Flexible(
                                                flex: 3,
                                                child: Container(
                                                  child: RawMaterialButton(
                                                    onPressed: () {
                                                      bloc.addshop(
                                                          wppost1['id'],
                                                          wppost1['title'],
                                                          1,
                                                          num.parse(
                                                              wppost1['price']),
                                                          wppost1['images'][0]
                                                              ['src'],0);
                                                      bloc.priceFunction(
                                                          num.parse(
                                                              wppost1['price']),
                                                          true);
                                                    },
                                                    elevation: 2.0,
                                                    fillColor: Colors.green,
                                                    child: Icon(
                                                      Icons.add_shopping_cart,
                                                      color: Colors.white,
                                                    ),
                                                    shape: CircleBorder(),
                                                  ),
                                                ),
                                              )
                                              :Container()
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
                                                  width: double.infinity,
                                                  child: RawMaterialButton(
                                                    onPressed: () {
                                                      if (bloc.productsInCart[
                                                                  wppost1['id']]
                                                              ['qte'] >
                                                          1) {
                                                        int qte =
                                                            bloc.productsInCart[
                                                                        wppost1[
                                                                            'id']]
                                                                    ['qte'] -
                                                                1;
                                                        if (wppost1['type'].toString() == 'variable') {
                                                                bloc.addshop(
                                                                  wppost1['id'],
                                                                  wppost1[
                                                                      'title'],
                                                                  qte,
                                                                  num.parse(wppost1[
                                                                      'price']),
                                                                  wppost1['images']
                                                                          [0]
                                                                      ['src'],bloc.productsInCart[
                                                                          wppost1[
                                                                              'id']]['varid']);   
                                                              } else {
                                                                bloc.addshop(
                                                                  wppost1['id'],
                                                                  wppost1[
                                                                      'title'],
                                                                  qte,
                                                                  num.parse(wppost1[
                                                                      'price']),
                                                                  wppost1['images']
                                                                          [0]
                                                                      ['src'],0);
                                                              }
                                                        bloc.priceFunction(
                                                            num.parse(wppost1[
                                                                'price']),
                                                            false);
                                                      } else {
                                                        bloc.productsInCart
                                                            .remove(
                                                                wppost1['id']);
                                                        bloc.listProducts
                                                            .remove(
                                                                wppost1['id']);
                                                        bloc.addshop(null, null,
                                                            null, null, null,null);
                                                        bloc.simpleBadge(bloc
                                                                .productsInCart
                                                                .length -
                                                            1);
                                                        bloc.priceFunction(
                                                            num.parse(wppost1[
                                                                'price']),
                                                            false);
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
                                                        bloc.productsInCart[
                                                                wppost1['id']]
                                                                ['qte']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )))),
                                              Flexible(
                                                flex: 3,
                                                child: Container(
                                                  width: double.infinity,
                                                  child: RawMaterialButton(
                                                    onPressed: () {
                                                      int qte =
                                                          bloc.productsInCart[
                                                                      wppost1[
                                                                          'id']]
                                                                  ['qte'] +
                                                              1;
                                                      if (wppost1['type'].toString() == 'variable') {
                                                                bloc.addshop(
                                                                  wppost1['id'],
                                                                  wppost1[
                                                                      'title'],
                                                                  qte,
                                                                  num.parse(wppost1[
                                                                      'price']),
                                                                  wppost1['images']
                                                                          [0]
                                                                      ['src'],bloc.productsInCart[
                                                                          wppost1[
                                                                              'id']]['varid']);   
                                                              print(bloc.productsInCart);
                                                              } else {
                                                                bloc.addshop(
                                                                  wppost1['id'],
                                                                  wppost1[
                                                                      'title'],
                                                                  qte,
                                                                  num.parse(wppost1[
                                                                      'price']),
                                                                  wppost1['images']
                                                                          [0]
                                                                      ['src'],0);
                                                              }
                                                      bloc.priceFunction(
                                                          num.parse(
                                                              wppost1['price']),
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
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductsDetaille(wppost1)));
                                    },
                                    child: Image.network(
                                      wppost1['images'][0]['src'].toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ))),
                        ),
                      ));
                    });
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
