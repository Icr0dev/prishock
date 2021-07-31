import 'package:flutter/material.dart';
import 'package:flutterapp/provider1.dart';
import 'package:flutterapp/validate.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<priceChange>(context);
    return Scaffold(
      body: Container(
          child: ListView.builder(
        itemCount: bloc.productsInCart.length - 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Card(
                child: Container(
              height: 100,
              child: ListTile(
                // onTap: () {},
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                title: Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          child: Text(
                              bloc.productsInCart[bloc.listProducts[index + 1]]
                                  ['name']),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 3,
                                child: Container(
                                  width: double.infinity,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      if (bloc.productsInCart[bloc
                                              .listProducts[index + 1]]['qte'] >
                                          1) {
                                        int qte = bloc.productsInCart[bloc
                                                    .listProducts[index + 1]]
                                                ['qte'] -
                                            1;
                                          bloc.addshop(
                                            bloc.listProducts[index + 1],
                                            bloc.productsInCart[bloc
                                                    .listProducts[index + 1]]
                                                ['name'],
                                            qte,
                                            bloc.productsInCart[bloc
                                                    .listProducts[index + 1]]
                                                ['price'],
                                            bloc.productsInCart[bloc
                                                    .listProducts[index + 1]]
                                                ['image'],bloc.productsInCart[bloc
                                                    .listProducts[index + 1]]['varid']);
                                                    print('panier == '+bloc.productsInCart.toString());
                                        bloc.priceFunction(
                                            bloc.productsInCart[bloc
                                                    .listProducts[index + 1]]
                                                ['price'],
                                            false);
                                      } else {
                                        bloc.priceFunction(
                                            bloc.productsInCart[bloc
                                                    .listProducts[index + 1]]
                                                ['price'],
                                            false);
                                        bloc.productsInCart.remove(
                                            bloc.listProducts[index + 1]);
                                        bloc.listProducts.remove(
                                            bloc.listProducts[index + 1]);
                                        bloc.simpleBadge(
                                            bloc.productsInCart.length - 1);
                                        bloc.addshop(
                                            null, null, null, null, null,null);
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
                                        bloc.productsInCart[bloc
                                                .listProducts[index + 1]]['qte']
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
                                      int qte = bloc.productsInCart[bloc
                                              .listProducts[index + 1]]['qte'] +
                                          1;
                                      bloc.addshop(
                                          bloc.listProducts[index + 1],
                                          bloc.productsInCart[bloc
                                              .listProducts[index + 1]]['name'],
                                          qte,
                                          bloc.productsInCart[
                                                  bloc.listProducts[index + 1]]
                                              ['price'],
                                          bloc.productsInCart[
                                                  bloc.listProducts[index + 1]]
                                              ['image'],bloc.productsInCart[bloc
                                                    .listProducts[index + 1]]['varid']);
                                                    print('panier == '+bloc.productsInCart.toString());
                                      bloc.priceFunction(
                                          bloc.productsInCart[
                                                  bloc.listProducts[index + 1]]
                                              ['price'],
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
                      )
                    ],
                  ),
                ),
                leading: bloc.productsInCart[bloc.listProducts[index + 1]]
                            ['image'] !=
                        null
                    ? Image.network(bloc
                        .productsInCart[bloc.listProducts[index + 1]]['image']
                        .toString())
                    : Image.network(
                        'https://static.thenounproject.com/png/1211233-200.png'),
              ),
            )),
          );
        },
      )),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 30),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  heroTag: 'btnDelete',
                  onPressed: () {
                    //showAboutDialog(context:context);
                    Widget cancelButton = FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                    Widget continueButton = FlatButton(
                      child: Text("Continue"),
                      onPressed: () {
                        bloc.deleteallcart();
                        bloc.simpleBadge(bloc.productsInCart.length - 1);
                        Navigator.pop(context);
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: Text("Vider le panier"),
                      content: Text("Voulez vous vider le panier ?"),
                      actions: [
                        cancelButton,
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
                  },
                  child: Icon(Icons.delete),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: 'btnVlidate',
                    onPressed: () {
                      if (bloc.sessionUser['id'] != 0) {
                        if (bloc.productsInCart.length>1) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ValidationPanier()));
                        }else{
                        Alert(
                          context: context,
                          title: 'Panier vide',
                          desc: 'Ajouter des articles a votre panier pour continuez')
                          .show();  
                        }
                      } else {
                        Alert(
                          context: context,
                          title: 'Permission interdit',
                          desc: 'inscrivez-vous ou connecter a votre compte pour continuez')
                          .show();
                      }
                    },
                    child: Icon(Icons.check_circle),
                    backgroundColor: Colors.green,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
