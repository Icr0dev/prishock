import 'package:badges/badges.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/panier.dart';
import 'package:flutterapp/provider1.dart';
import 'package:flutterapp/route.dart';
import 'package:flutterapp/wpapi.dart';
import 'package:provider/provider.dart';
import 'acceuil.dart';
import 'acount.dart';

getprod() async {
  try {
    return await fetchwppost(
        'https://prishock.com/wc-api/v3/products?filter[limit]=-1&consumer_key=ck_66a4275df13881f5c2012aeb9795f6d181717421&consumer_secret=cs_abd6b7fdc7ec5e83582a9f2a0c96bb21ce392f91');
  } catch (e) {
    return null;
  }
}

getcat() async {
  try {
    return await fetchwppost(
        'https://prishock.com/wc-api/v3/products/categories?filter[limit]=-1&consumer_key=ck_66a4275df13881f5c2012aeb9795f6d181717421&consumer_secret=cs_abd6b7fdc7ec5e83582a9f2a0c96bb21ce392f91');
  } catch (e) {
    return null;
  }
}



Future wish;
Future categorie;
Future prodacts;
void main() {
  prodacts = getprod();
  categorie = getcat();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => priceChange(),
        )
      ],
      child: MaterialApp(
        // title: 'Prishock',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        home: RouteScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> mypage;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  int bottomSelectedIndex = 0;
  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  @override
  void initState() {
    mypage = [AcceuilPage(), PanierPage(), AcountProfile()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<priceChange>(context);
    return Scaffold(
        appBar: new AppBar(
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new PageView.builder(
            controller: pageController,
            itemBuilder: (context, position) => mypage[position],
            itemCount: mypage.length,
            onPageChanged: (index) {
              pageChanged(index);
            },
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: bottomSelectedIndex,
          color: Colors.deepOrange,
          backgroundColor: Colors.white70,
          height: 60.0,
          items: <Widget>[
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            // Icon(
            //   Icons.list,
            //   color: Colors.white,
            // ),
            (bloc.panierCount < 1)
                ? Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                  )
                : Badge(
                    position: BadgePosition.topRight(top: 6, right: 20),
                    animationType: BadgeAnimationType.slide,
                    animationDuration: Duration(milliseconds: 2000),
                    badgeColor: Colors.green,
                    badgeContent: Text(
                      bloc.panierCount.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                  ),
            Icon(
              Icons.person,
              color: Colors.white,
            ),
          ],
          animationDuration: Duration(
            milliseconds: 300,
          ),
          onTap: (index) {
            //changing page view index
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          },
        ));
  }
}
