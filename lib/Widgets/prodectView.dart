import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/user/productInfo.dart';
import 'package:flutter/material.dart';

import '../functions.dart';
Widget ProductView(String pcategory,List<Product>allProducts)
{
  List<Product>products;
  products=getProductByCategory(pcategory,allProducts);
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: .8,
    ),
    itemBuilder:(context,index)=>Padding(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: GestureDetector(
        onTap: (){Navigator.pushNamed(context, ProductInfo.id,arguments: products[index]);},
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                fit: BoxFit.fill,
                image:AssetImage(products[index].pLocation),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: .6,
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child:Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(products[index].pName,style: TextStyle(fontWeight:FontWeight.bold ),),
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
}