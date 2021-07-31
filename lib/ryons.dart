import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/productsDetail.dart';
import 'package:flutterapp/provider1.dart';
// import 'package:flutterapp/wpapi.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class RyonsPage extends StatefulWidget {
  @override
  _RyonsPageState createState() => _RyonsPageState();
}

class _RyonsPageState extends State<RyonsPage> {
//initstate

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<priceChange>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Container(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Align(
              child: Image(
                image: AssetImage('images/logo.png'),
              ),
              alignment: Alignment.topLeft,
            ),
          ),
        ),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          Container(
            height: 50,
            padding: EdgeInsets.only(top: 10),
            margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
            child: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                  style: TextStyle(fontSize: 22),
                  text: bloc.intNumber.toString(),
                  children: <TextSpan>[
                    TextSpan(
                        text: ',' + bloc.doubleint.toString(),
                        style: TextStyle(
                          fontSize: 10,
                        )),
                    TextSpan(
                        text: ' DA',
                        style: TextStyle(
                          fontSize: 10,
                        )),
                  ]),
            ),
          ),
        ],
      ),
      body: products(bloc.catselected),
    );
  }

//Widget categories ******************************************
  Widget categories(context) {
    final containerProviders = Provider.of<priceChange>(context);
    if (containerProviders.subcat == 'subcategories') {
      return AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              child: child,
              scale: animation,
            );
          },
          duration: Duration(milliseconds: 300),
          child: subcategories(context));
    } else if (containerProviders.subcat == 'products') {
      return AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              child: child,
              scale: animation,
            );
          },
          duration: Duration(milliseconds: 300),
          child: products(containerProviders.catselected));
    } else {
      return AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            child: child,
            scale: animation,
          );
        },
        duration: Duration(milliseconds: 300),
        child: FutureBuilder(
          future: categorie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data['product_categories'].length,
                itemBuilder: (BuildContext context, int index) {
                  Map wppost = snapshot.data['product_categories'][index];
                  return (wppost['parent'] == 0)
                      ? Container(
                          height: 120,
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: wppost['description'].toString() != ''
                                ? HexColor(wppost['description'].toString())
                                : Colors.blue[300],
                            child: ListTile(
                              onTap: () {
                                containerProviders.changeContainer(
                                    wppost['id'],
                                    'subcategories',
                                    wppost['name'],
                                    wppost['id']);
                                containerProviders.cattex = wppost['name'];
                              },
                              title: Center(
                                  child: Text(
                                wppost['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              leading: wppost['image'] != null
                                  ? Image.network(wppost['image'])
                                  : Image.network(
                                      'https://static.thenounproject.com/png/1211233-200.png'),
                            ),
                          ),
                        )
                      : Container();
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    }
  }

//Widget subcategorie ***************************************
  Widget subcategories(context) {
    final containerProviders = Provider.of<priceChange>(context);
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            // height: double.infinity,
            child: Card(
              margin: EdgeInsets.all(7),
              elevation: 5,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 5,
                    child: ListTile(
                      onTap: () {
                        containerProviders.changeContainer(
                            0, 'categories', null, null);
                      },
                      title: Text('Retour'),
                      //contentPadding: EdgeInsets.all(10),
                      leading: Icon(Icons.arrow_back),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          containerProviders.cattex,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 9,
          child: Container(
            child: FutureBuilder(
              future: categorie,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data['product_categories'].length,
                    itemBuilder: (BuildContext context, int index) {
                      Map wppost = snapshot.data['product_categories'][index];
                      return (wppost['parent'] == containerProviders.id)
                          ? Container(
                              height: 120,
                              padding:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              child: Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: wppost['description'].toString() != ''
                                    ? HexColor(wppost['description'].toString())
                                    : Colors.blue[300],
                                child: ListTile(
                                  onTap: () {
                                    containerProviders.changeContainer(
                                        wppost['id'],
                                        'products',
                                        wppost['name'],
                                        null);
                                  },
                                  title: Center(
                                      child: Text(
                                    wppost['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  leading: wppost['image'] != null
                                      ? Image.network(wppost['image'])
                                      : Image.network(
                                          'https://static.thenounproject.com/png/1211233-200.png'),
                                ),
                              ),
                            )
                          : Container();
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ],
    );
  }

// widget produts ***********************
  Widget products(String catselected) {
    final bloc = Provider.of<priceChange>(context);
    return Container(
      child: FutureBuilder(
        future: prodacts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map> dataFinal = List<Map>();
            for (var i = 0; i < snapshot.data['products'].length; i++) {
              Map snap = snapshot.data['products'][i];
              List catlist = snap['categories'];
              if (catlist.contains(bloc.catselected)) {
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
                                                    fontWeight: FontWeight.bold,
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
                                              width: double.infinity,
                                              child: RawMaterialButton(
                                                onPressed: () {
                                                  if (bloc.productsInCart[
                                                              wppost1['id']]
                                                          ['qte'] >
                                                      1) {
                                                    int qte = bloc
                                                                .productsInCart[
                                                            wppost1[
                                                                'id']]['qte'] -
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
                                                        false);
                                                  } else {
                                                    bloc.productsInCart
                                                        .remove(wppost1['id']);
                                                    bloc.listProducts
                                                        .remove(wppost1['id']);
                                                    bloc.addshop(null, null,
                                                        null, null, null,null);
                                                    bloc.simpleBadge(bloc
                                                            .productsInCart
                                                            .length -
                                                        1);
                                                    bloc.priceFunction(
                                                        num.parse(
                                                            wppost1['price']),
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
                                                            FontWeight.bold),
                                                  )))),
                                          Flexible(
                                            flex: 3,
                                            child: Container(
                                              width: double.infinity,
                                              child: RawMaterialButton(
                                                onPressed: () {
                                                  int qte = bloc.productsInCart[
                                                              wppost1['id']]
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
                                  Navigator.of(context).push(MaterialPageRoute(
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
    );
  }
}
