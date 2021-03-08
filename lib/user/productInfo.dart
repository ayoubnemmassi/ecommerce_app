import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/provider/cartitem.dart';
import 'package:e_commerce/user/cartScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  static String id='productinfo';

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int quantity=1;

  @override
  Widget build(BuildContext context) {
    Product product=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: [
          Container(
          height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image(

                image: AssetImage(product.pLocation))),
          Padding(
            padding:EdgeInsets.fromLTRB( 20,30,20, 0),
            child: Container(

              height: MediaQuery.of(context).size.height*.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){Navigator.pop(context);},
                    child: Icon(
                      Icons.arrow_back_ios
                    ),
                  ),
                  GestureDetector(
                    onTap:(){ Navigator.pushNamed(context, CartScreen.id);},
                    child: Icon(
                        Icons.shopping_cart
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children:[
                Opacity(

                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*.3,
                    child:Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('product name : ${product.pName}',
                          style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.01,),
                          Text('Description: ${product.pDescription}',
                          style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.01,),
                          Text('Price:  ${product.pPrice}\$',
                          style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.01,),
                          Text('Category:  ${product.pCategory}',
                          style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Material(
                                  color: KMainColor,
                                  child: GestureDetector(
                                    onTap: add,
                                    child: SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ),
                              Text(quantity.toString(),
                                style: TextStyle(fontSize: 40),),
                              ClipOval(
                                child: Material(
                                  color: KMainColor,
                                  child: GestureDetector(
                                    onTap: subtract,
                                    child: SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  opacity: .5,
                ),
                ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*.08,
                child: Builder(
                  builder:(context)=> RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                    ),
                    color: KMainColor,
                    onPressed: ()
                    {
                      addToCart(context, product);
                    },
                  child: Text('Add to Cart'.toUpperCase(),
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
        ]
            ),
          )
        ],
      ),
    );
  }

  void addToCart(BuildContext context, Product product) {
    CartItem cartItem= Provider.of<CartItem>(context,listen: false);
    product.quantity=quantity;
    bool exist =false;
    var productsInCart=cartItem.products;
    for(var productInCart in productsInCart)
      {
        if(productInCart.pName==product.pName)
        {
          exist=true;
        }
      }
    if(exist)
      {
        Scaffold.of(context).showSnackBar(SnackBar(
          content:Text('you\'ve added this item before') ,));
      }
    else{
      cartItem.addProduct(product);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Added to cart')));
    }

  }

  subtract() {
    if(quantity>0){
   setState(() {
     quantity--;
   });

  }
  }

  add() {
    setState(() {
      quantity++;
    });
   }
}
