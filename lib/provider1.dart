import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class priceChange with ChangeNotifier {
  bool dbreaded = false;
  final List wishliste = new List();

  double price = 0.0;
  int intNumber = 0;
  double doublenumber = 0;
  int doubleint = 0;
  priceFunction(prix, bool plusTrue) {
    if (plusTrue == true) {
      price = price + prix;
      intNumber = price.toInt();
      doublenumber = (price - intNumber) * 100;
      doubleint = doublenumber.toInt();
      activeBadge(true);
      notifyListeners();
    } else {
      price = price - prix;
      intNumber = price.toInt();
      doublenumber = (price - intNumber) * 100;
      doubleint = doublenumber.toInt();
      if (price != 0) {
        activeBadge(true);
      } else {
        activeBadge(false);
      }
      notifyListeners();
    }
  }

  List listProducts = [0];
  Map productsInCart = {
    0: {'name': 'name', 'qte': 9, 'price': 0, 'image': 'ssssss.jpg'},
  };
  deleteallcart() {
    productsInCart.clear();
    productsInCart = {
      0: {'name': 'name', 'qte': 9, 'price': 0, 'image': 'ssssss.jpg'},
    };
    price = 0.0;
    intNumber = 0;
    doublenumber = 0;
    doubleint = 0;
    notifyListeners();
  }

  addshop(idProducts, nameP, qteP, prixP, imageP,idvar) {
    if (nameP != null && idProducts != null) {
      productsInCart[idProducts] = {
        'name': nameP,
        'qte': qteP,
        'price': prixP,
        'image': imageP,
        'varid': idvar
      };
      if (!listProducts.contains(idProducts)) {
        listProducts.add(idProducts);
      }
      notifyListeners();
    }
  }

  int id = 0;
  int backid = 0;
  String cattex;
  String subcat = 'categories';
  String catselected;
  changeContainer(int idF, String subcatF, String catselectedF, int backidF) {
    if (backidF == null) {
      id = idF;
      subcat = subcatF;
      catselected = catselectedF;
    } else {
      id = idF;
      subcat = subcatF;
      catselected = catselectedF;
      backid = backidF;
    }
    notifyListeners();
  }

  int panierCount = 0;
  Widget badgeVar = Icon(
    Icons.add_shopping_cart,
    color: Colors.white,
  );

  simpleBadge(int countF) {
    panierCount = countF;
    notifyListeners();
  }

  activeBadge(bool activated) {
    if (activated == true) {
      panierCount = productsInCart.length - 1;
      badgeVar = Badge(
        position: BadgePosition.topRight(top: 6, right: 20),
        animationType: BadgeAnimationType.slide,
        animationDuration: Duration(milliseconds: 2000),
        badgeColor: Colors.green,
        badgeContent: Text(
          panierCount.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
      );
    } else {
      badgeVar = Icon(
        Icons.add_shopping_cart,
        color: Colors.white,
      );
    }
  }

//************************************connexion prtie */
  switcheinslogin(bool boolien) {
    if (boolien == false) {
      inscription = false;
      notifyListeners();
    } else {
      inscription = true;
      notifyListeners();
    }
  }

  wishlisteFunction(bool isdelete, int id) {
    if (isdelete == true) {
      wishliste.remove(id);
      notifyListeners();
    } else {
      wishliste.add(id);
      notifyListeners();
    }
    return wishliste;
  }

  bool inscription = false;
  final Map sessionUser = Map();
  // {
  //   'id': -1,
  //   'name': 'Guest',
  //   'email': 'Guest@gmail.com',
  //   'image': null,
  //   'scor': 0,
  //   'token': ''
  // };
  notify() {
    notifyListeners();
  }

  bool clicked = false;
  bool clickedinsc = false;
  bool clickedpass = false;
  bool clickedfeed = false;
  bool clickedwish = false;
  bool clickedrating = false;
  clickedBtn(bool clickedf, String message) {
    switch (message) {
      case 'login':
        clicked = clickedf;
        break;
      case 'insc':
        clickedinsc = clickedf;
        break;
      case 'feed':
        clickedfeed = clickedf;
        break;
      case 'pass':
        clickedpass = clickedf;
        break;
      case 'wish':
        clickedwish = clickedf;
        break;
      case 'rating':
        clickedwish = clickedf;
        break;
      default:
    }
    notifyListeners();
  }

  bool inkclicked = false;
  inkclick(bool ink) {
    inkclicked = ink;
    notifyListeners();
  }

  Future<void> saveData(String key, String dataToSave) async {
    SharedPreferences data2 = await SharedPreferences.getInstance();
    data2.setString(key, dataToSave);
  }

  double average = 0.0;
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}

// color class separated //
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
