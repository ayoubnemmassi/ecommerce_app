import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/Widgets/prodectView.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/login_screen.dart';
import 'package:e_commerce/services/auth.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/user/cartScreen.dart';
import 'package:e_commerce/user/productInfo.dart';
import 'package:e_commerce/user/userHome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions.dart';


class ProductPage extends StatefulWidget {
  static String id = 'ProductPage';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _auth = Auth();
  // FirebaseUser _loggedUser;
  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;
  final _store = Store();
  List<Product> _products;
  @override
  Widget build(BuildContext context) {
    String id=ModalRoute.of(context).settings.arguments;
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 1,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: KUnActiveColor,
              currentIndex: _bottomBarIndex,
              fixedColor: KMainColor,
              onTap: (value) async {
                if (value == 2) {
                  SharedPreferences pref =
                  await SharedPreferences.getInstance();
                  pref.clear();
                  await _auth.signOut();
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                }
                else if(value==0){Navigator.pushNamed(context, UserHome.id);}
                else if(value==1){Navigator.pushNamed(context, CartScreen.id);}
                setState(() {
                  _bottomBarIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                    title: Text('My Space'), icon: Icon(Icons.person)),
                BottomNavigationBarItem(
                    title: Text('Cart'), icon: Icon(Icons.shopping_cart)),
                BottomNavigationBarItem(
                    title: Text('Sign Out'), icon: Icon(Icons.close)),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: KMainColor,
                onTap: (value) {
                  setState(() {
                    _tabBarIndex = value;
                  });
                },
                tabs: <Widget>[
                  Text(
                    '${id}',
                    style: TextStyle(
                      color: _tabBarIndex == 0 ? Colors.black : KUnActiveColor,
                      fontSize: _tabBarIndex == 0 ? 16 : null,
                    ),
                  ),

                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                jacketView(id),


              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Discover'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CartScreen.id);
                      },
                      child: Icon(Icons.shopping_cart))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    getCurrenUser();
  }

  getCurrenUser() async {

  }

  Widget jacketView(String pcategory) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data();
            products.add(Product(
                pId: doc.id,
                pPrice: data[KProductsPrice],
                pName: data[KProductsName],
                pDescription: data[KProductsDescription],
                pLocation: data[KProductsLocation],
                pCategory: data[KProductsCategory]));
          }
          _products = [...products];
          products.clear();
          products = getProductByCategory(pcategory, _products);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .8,
            ),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductInfo.id,
                      arguments: products[index]);
                },
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.network(

                        products[index].pLocation,fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Opacity(
                        opacity: .6,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  products[index].pName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('\$ ${products[index].pPrice}')
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            itemCount: products.length,
          );
        } else {
          return Center(child: Text('Loading...'));
        }
      },
    );
  }
}
