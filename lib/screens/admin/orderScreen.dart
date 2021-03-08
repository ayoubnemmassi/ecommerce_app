import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/models/order.dart';
import 'package:e_commerce/services/store.dart';
import 'package:flutter/material.dart';

import 'order_details.dart';
class OrdersScreen extends StatelessWidget {
  static String id ='orderscreen';
  final Store store =Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){Navigator.pop(context);},
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Text('Orders',style: TextStyle(color: Colors.black),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: store.loadOrders(),
        builder: (context,snapshot)
        {
            if(!snapshot.hasData)
            {
              return Center(
                child: Text('there is no orders'),
              );
            }else
              {
                List<Order> orders=[];
                for(var doc in snapshot.data.docs)
                {

                  orders.add(Order(
                      documentId: doc.id,
                      totalPrice: doc.data()[KTotalPrice],
                      address:  doc.data()[KAddress]
                  ));

                }
                return ListView.builder(
                    itemBuilder: (context,index)=>
                       Padding(
                         padding: const EdgeInsets.all(20),
                         child: GestureDetector(
                           onTap: ()
                           {
                             Navigator.pushNamed(context, OrderDetails.id,arguments:orders[index].documentId);
                           },
                           child: Container(
                             alignment: Alignment.center,
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
                                   Text('Total Price =${orders[index].totalPrice}\$',style: TextStyle(color: Colors.white,
                               fontWeight:FontWeight .bold
                               ),),
                                   SizedBox(height: 10,),
                                   Text('Address is ${orders[index].address}',style: TextStyle(color: Colors.white,
                                     fontWeight:FontWeight .bold
                                   ),),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                  itemCount: orders.length,
                );
              }
        }
      ),
    );
  }
}
