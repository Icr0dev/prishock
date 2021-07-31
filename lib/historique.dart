import 'package:flutter/material.dart';
import 'package:flutterapp/provider1.dart';
import 'package:flutterapp/wpapi.dart';
import 'package:provider/provider.dart';

class HistoriqueDachats extends StatefulWidget {
  @override
  _HistoriqueDachatsState createState() => _HistoriqueDachatsState();
}

class _HistoriqueDachatsState extends State<HistoriqueDachats> {
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
                'Historique d\'achats',
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
        body: (bloc.sessionUser['id'] != 0)
            ? Container(
                child: FutureBuilder(
                  future: fetchwppost(
                      'https://prishock.com/wc-api/v3/orders?filter[limit]=-1&consumer_key=ck_66a4275df13881f5c2012aeb9795f6d181717421&consumer_secret=cs_abd6b7fdc7ec5e83582a9f2a0c96bb21ce392f91'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data['orders'].length,
                        itemBuilder: (BuildContext context, int index) {
                          Map wppost = snapshot.data['orders'][index];
                          List productsItems = wppost['line_items'];
                          double hight =
                              double.parse(productsItems.length.toString()) *
                                  65;
                          Widget productsIt = ListView.builder(
                              itemCount: productsItems.length,
                              itemBuilder: (BuildContext context, int index1) {
                                return ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(wppost['line_items'][index1]
                                                ['name']
                                            .toString()),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text('x' +
                                          wppost['line_items'][index1]
                                                  ['quantity']
                                              .toString()),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(wppost['line_items'][index1]['price']
                                              .toString() +
                                          ' Dzd'),
                                    ],
                                  ),
                                );
                              });
                          print(wppost['customer_id'].toString() +
                              '==' +
                              bloc.sessionUser['id'].toString());
                          return (wppost['customer_id'] ==
                                  bloc.sessionUser['id'])
                              ? ExpansionTile(
                                  title: Row(
                                    children: <Widget>[
                                      Text(
                                        'Commande num: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '#' + wppost['order_number'].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 5,
                                                child: Row(
                                                  children: <Widget>[
                                                    Text('Total: '),
                                                    Text(wppost['total'] +
                                                        ' Dzd'),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(wppost['status']),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Pdouits :',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Container(
                                              width: double.maxFinite,
                                              height: hight,
                                              child: productsIt),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container();
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              )
            : Container(
                child: Center(
                  child: Text(
                    'Vous n\'avez pas d\'historique',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
