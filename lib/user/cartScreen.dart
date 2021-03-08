import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/Widgets/custom_menu.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/provider/cartitem.dart';
import 'package:e_commerce/services/store.dart';
import 'package:e_commerce/user/productInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
class CartScreen extends StatelessWidget {
  static String id = 'cartscreen';
  @override
  Widget build(BuildContext context) {
    List<Product> products=Provider.of<CartItem>(context).products;
    final double screenHeight=MediaQuery.of(context).size.height;
    final double screenWidth=MediaQuery.of(context).size.width;
    final double appbarHeight=AppBar().preferredSize.height;
    final double statusBarHeight=MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){Navigator.pop(context);},
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Text('My Cart',style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        children: [
          LayoutBuilder(
            builder: (context,constraint) {
              if(products.isNotEmpty){return Container(
                height: screenHeight-statusBarHeight-appbarHeight-(screenHeight*.08),
                child: ListView.builder(

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: GestureDetector(onTapUp: (details){showCustomMenu(details,context,products[index]);},
                        child: Container(
                          height: screenHeight * .15,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: screenHeight * .15 / 2,
                                backgroundImage: AssetImage(
                                    products[index].pLocation),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width*.14,),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Text(products[index].pName,
                                            style: TextStyle(fontSize: 20,
                                                color: Colors.white,

                                                fontWeight: FontWeight.bold),),
                                          SizedBox(height: 10,),
                                          Text('\$ ${products[index].pPrice}',
                                            style: TextStyle(
                                              color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]
                                        ,),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Text(
                                            products[index].quantity.toString(),
                                          style: TextStyle(color: Colors.white,fontSize: 20),
                                        )
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

                          decoration: BoxDecoration( image:  DecorationImage(
                            image: AssetImage('images/bgdg.jpg'),
                            fit: BoxFit.cover,
                          ),
                            borderRadius: BorderRadius.circular(12), color: Color(0xFFB7C3CD),),
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
              );}
              else
                {
                  return Container(
                    height: screenHeight-(screenHeight*.08)-appbarHeight-statusBarHeight,
                    child: Center(
                      child: Text('Cart is Empty'),
                    ),
                  );
                }


            }
          ),
          Builder(
            builder: (context)=>ButtonTheme(

             minWidth: screenWidth,
              height: screenHeight*.08,
              child: RaisedButton(

color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50 ))
                ),
                onPressed: (){showCostumDialog(products,context);},
              child: Text('Order'.toUpperCase(),style: TextStyle(color: Colors.white),),

                splashColor: Colors.blueGrey,
              ),
            ),
          )
        ],
      ),
    );

  }

  showCustomMenu(details,context,product)
  async {
    double dx=details.globalPosition.dx;
    double dy=details.globalPosition.dy;
    double dx2=MediaQuery.of(context).size.width-dx;
    double dy2=MediaQuery.of(context).size.height-dy;
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
    items: [
    MyPopupMenuItem(onClick:(){
      Navigator.pop(context);
      Provider.of<CartItem>(context,listen: false).deleteProduct(product);
      Navigator.pushNamed(context, ProductInfo.id,arguments: product);} ,
  child: Text('Edit')
  ),
  MyPopupMenuItem(onClick: ()
  {
    Navigator.pop(context);
    Provider.of<CartItem>(context,listen: false).deleteProduct(product);
  },
  child: Text('Delete')
  )
    ]
    );
  }

  void showCostumDialog(List<Product> products,context) async
  {
    var price =getTotalPrice(products);
    var address;
    AlertDialog alertDialog =AlertDialog(
      actions: [
        MaterialButton(onPressed: (){
          try {
            Store store = Store();
            store.storeOrders(
                {
                  KTotalPrice: price,
                  KAddress: address
                },
                products);
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Ordered Successfully')));
            Navigator.pop(context);
          }catch(ex)
          {
            print(ex.message);
          }
        },
        child:Text('Confirm') ,
        )
      ],
      content: TextField(
        onChanged: (value)
        {
          address=value;
        },
        decoration: InputDecoration(
          hintText: 'Enter your Address'
        ),
      ),
      title: Text('Total Price = $price \$'),
    );
    await showDialog(context: context,builder: (context){return alertDialog;}

    );
  }

  getTotalPrice(List<Product> products)
  {
    var price =0;
    for(var product in products)
    {
      price+=product.quantity*int.parse(product.pPrice);
    }
    return price;
  }

}