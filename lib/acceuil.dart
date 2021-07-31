import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/productsDetail.dart';
import 'package:flutterapp/provider1.dart';
import 'package:flutterapp/ryons.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'ad_manager.dart';

const String testDevice = '';


class AcceuilPage extends StatefulWidget {
  @override
  _AcceuilPageState createState() => _AcceuilPageState();
}

class _AcceuilPageState extends State<AcceuilPage> {
// Future prod;


//   BannerAd _bannerAd;

//   // TODO: Implement _loadBannerAd()
//   void _loadBannerAd() {
//     _bannerAd
//       ..load()
//       ..show(anchorType: AnchorType.top);
//   }

//   @override
//   void initState() {
//       // TODO: Initialize _bannerAd
//   _bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-1792482231072200/6755689506',
//       size: AdSize.banner,
//   );

//   // TODO: Load a Banner Ad
//   _loadBannerAd();
//     // prod=getprod();
//     super.initState();
//   }

// @override
// void dispose() {
//   // TODO: Dispose BannerAd object
//   _bannerAd?.dispose();

//   super.dispose();
// }
// TODO: Add _interstitialAd
static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    //testDevices: <String>[],
    keywords: <String>['tshirt', 'casquette', 't-shirt', 'fashion'],
    childDirected: true,
  );

  InterstitialAd _interstitialAd;
  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: "ca-app-pub-1792482231072200/6535056016",
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event : $event");
        });
  }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   FirebaseAdMob.instance
  //       .initialize(appId: "ca-app-pub-4252364201498947~9120074333");
  //   _bannerAd = createBannerAd()
  //     ..load()
  //     ..show();
  //   subscription = collectionReference.snapshots().listen((datasnapshot) {
  //     setState(() {
  //       wallpapersList = datasnapshot.documents;
  //     });
  //   });

  //   // _currentScreen();
  // }
  @override
  void dispose() {
    _interstitialAd.dispose();
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
              child: Container(
                margin: EdgeInsets.all(0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.deepOrange,
                        padding: EdgeInsets.all(0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 80.0,
                                  offset: Offset(0, 80))
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                          child: FutureBuilder(
                            future: categorie,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        snapshot.data['product_categories'].length,
                                    itemBuilder: (context, index) {
                                      Map categorie =
                                          snapshot.data['product_categories'][index];
                                      return Container(
                                        margin: EdgeInsets.only(right: 5, left: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.deepOrange[400],
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 2.0,
                                                style: BorderStyle.solid),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(60.0))),
                                        width: 70,
                                        height: 100,
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(120.0)),
                                          color: Colors.grey[200],
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(120.0)),
                                            splashColor: Colors.deepOrange[400],
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          categorie['image'].toString())),
                                                  ),
                                              // child: GridTile(
                                              //     child: Container(
                                              //       margin: EdgeInsets.all(5),
                                              //       child: Row(
                                              //         mainAxisAlignment:
                                              //             MainAxisAlignment.center,
                                              //         crossAxisAlignment:
                                              //             CrossAxisAlignment.start,
                                              //         children: [
                                              //           Flexible(
                                              //             child: Text(
                                              //               categorie['name']
                                              //                   .toString(),
                                              //               style: TextStyle(
                                              //                   fontSize: 15,
                                              //                   color: Colors.black,
                                              //                   fontWeight:
                                              //                       FontWeight.bold),
                                              //             ),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //     footer: Container(
                                              //        height: 40,
                                              //       child: Image(
                                              //           image: NetworkImage(
                                              //               categorie['image']
                                              //                   .toString())),
                                              //     )),
                                            ),
                                            onTap: () {
                                              bloc.changeContainer(categorie['id'],
                                                  'products', categorie['name'], null);
        createInterstitialAd()
                          ..load()
                          ..show();
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RyonsPage()));
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return Row(
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(10),
                      child: Text('Produits en promotions:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(
                      flex: 5,
                      child: AnimatedContainer(
                        duration: Duration(seconds: 5),
                        child: FutureBuilder(
                          future: prodacts,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Map> dataFinal = List<Map>();
                              for (var i = 0;
                                  i < snapshot.data['products'].length;
                                  i++) {
                                    bool isSolded=false;
                                Map snap = snapshot.data['products'][i];
                                if (snap['type'].toString() == 'variable') {
                                  for (var i = 0; i < snap['variations'].length; i++) {
                                    if (snap['variations'][i]['sale_price'] != null) {
                                      isSolded=true;
                                    }
                                  }
                                }
                                if (snap['sale_price'] != null || isSolded) {
                                  dataFinal.add(snap);
                                }
                              }
        
                              return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemCount: dataFinal.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    Map wppost1 = dataFinal[index];
                                    return GridTile(
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
                                                                          FontWeight
                                                                              .bold,
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
                                                                child:
                                                                    RawMaterialButton(
                                                                  onPressed: () {
                                                                    bloc.addshop(
                                                                        wppost1['id'],
                                                                        wppost1[
                                                                            'title'],
                                                                        1,
                                                                        num.parse(wppost1[
                                                                            'price']),
                                                                        wppost1['images']
                                                                            [0]['src'],0);
                                                                    bloc.priceFunction(
                                                                        num.parse(wppost1[
                                                                            'price']),
                                                                        true);
                                                                        print('cart 0000 '+bloc.productsInCart.toString());
                                                                  },
                                                                  elevation: 2.0,
                                                                  fillColor:
                                                                      Colors.green,
                                                                  child: Icon(
                                                                    Icons
                                                                        .add_shopping_cart,
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
                                                                child:
                                                                    RawMaterialButton(
                                                                  onPressed: () {
                                                                    if (bloc.productsInCart[
                                                                                wppost1[
                                                                                    'id']]
                                                                            ['qte'] >
                                                                        1) {
                                                                      int qte = bloc.productsInCart[
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
                                                                              wppost1[
                                                                                  'id']);
                                                                      bloc.listProducts
                                                                          .remove(
                                                                              wppost1[
                                                                                  'id']);
                                                                      bloc.addshop(
                                                                          null,
                                                                          null,
                                                                          null,
                                                                          null,
                                                                          null,null);
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
                                                                    width:
                                                                        double.infinity,
                                                                    child: Center(
                                                                        child: Text(
                                                                      bloc.productsInCart[
                                                                              wppost1[
                                                                                  'id']]
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
                                                                child:
                                                                    RawMaterialButton(
                                                                  onPressed: () {
                                                                    int qte = bloc.productsInCart[
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
                                                                        true);
                                                                  },
                                                                  elevation: 2.0,
                                                                  fillColor:
                                                                      Colors.green,
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
createInterstitialAd()
                          ..load()
                          ..show();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductsDetaille(
                                                                    wppost1)));
                                                  },
                                                  child: Image.network(
                                                    wppost1['images'][0]['src']
                                                        .toString(),
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
                  ],
                ),
              ),
            );
          }
        
          void _moveToHome() {
            Navigator.pop(context);
          }
}
