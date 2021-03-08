import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/services/store.dart';
import 'package:flutter/material.dart';
class OrderDetails extends StatelessWidget {
  static String id='OrderDetails';
  Store store =Store();
  @override
  Widget build(BuildContext context) {
      String documentId=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Text('Orders details',style: TextStyle(color: Colors.black),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: store.loadOrderDetails(documentId),
        builder:(context,snapshot)
        {
          if(snapshot.hasData)
          {
               List<Product> products=[];
               for(var doc in snapshot.data.docs)
                 {
                   products.add(Product(
                     pName:doc.data()[KProductsName],
                     quantity: doc.data()[KProductQuantity],
                     pCategory: doc.data()[KProductsCategory]
                   ));
                 }
               return Column(
                 children: [
                   Expanded(
                     child: ListView.builder(
                       itemBuilder: (context,index)=>Padding(
                         padding: const EdgeInsets.all(20),
                         child: Container(
                           decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/darkbg.jpg'),fit: BoxFit.cover
                           ),
                             borderRadius: BorderRadius.circular(20),
                             color: KSeconddaryColor,),
                           height: MediaQuery.of(context).size.height*.2,

                           child: Padding(
                             padding: const EdgeInsets.all(10),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text('product name : ${products[index].pName}',style: TextStyle(color: Colors.white,
                                     fontWeight:FontWeight .bold
                                 ),),
                                 SizedBox(height: 10,),
                                 Text('Quantity : ${products[index].quantity}',style: TextStyle(color: Colors.white,
                                     fontWeight:FontWeight .bold
                                 ),),
                                 SizedBox(height: 10,),
                                 Text('Product Category : ${products[index].pCategory}',style: TextStyle(color: Colors.white,
                                     fontWeight:FontWeight .bold
                                 ),),
                               ],
                             ),
                           ),
                         ),
                       ),
                       itemCount: products.length,
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20 ,),
                     child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,

                       children: [
                         Expanded(
                           child: ButtonTheme(
                             buttonColor:KMainColor,
                             child: RaisedButton(onPressed: (){},
                             child:Text('Confirm Order'),
                               ),
                           ),
                         ),
                         SizedBox(width: 10,),
                         Expanded(
                           child: ButtonTheme(
                             buttonColor: KMainColor,
                             child: RaisedButton(onPressed: (){store.deleteOrder(documentId);Navigator.pop(context);},
                             child:Text('Delete Order')
                               ,),
                           ),
                         ),
                       ],
                     ),
                   )
                 ],
               );
          }else
            {
              return Center(child: Text('Loading Order Details'),);
            }
          return Container(

          );
        }
      ),
    );
  }
}
