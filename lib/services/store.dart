import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Constants.dart';
import 'package:e_commerce/models/User.dart';
import 'package:e_commerce/models/product.dart';

class Store {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  addProduct(Product product) {
    firestore.collection(KProductsCollection).add({
      KProductsName: product.pName,
      KProductsDescription: product.pDescription,
      KProductsCategory: product.pCategory,
      KProductsPrice: product.pPrice,
      KProductsLocation: product.pLocation,
    });
  }
  addUser(User user) {
    firestore.collection(KUsers).add({
      KUsersName: user.uName,
      KUsersPrenom: user.uPrenom,
      KUsersMail: user.uMail,
      KUserMdp: user.uMdp,
      KUsersImage: user.uImage,
      KUsersRole:user.uRole
    });
  }

  Stream<QuerySnapshot> loadProduct()  {


        return firestore.collection(KProductsCollection).snapshots();

}
  deleteProduct(String documentid)
  {
    firestore.collection(KProductsCollection).doc(documentid).delete();
  }
  deleteOrder(String documentid)
  {
    firestore.collection(KOrders).doc(documentid).delete();
  }
  deleteUser(String documentid)
  {
    firestore.collection(KUsers).doc(documentid).delete();
  }
  editProduct(data,documentid)
  {
    firestore.collection(KProductsCollection).doc(documentid).update(data);
  }
  storeOrders(data,List<Product>products)
  {
        var documentRef=  firestore.collection(KOrders).doc();
        documentRef.set(data);
        for(var product in products)
        {
          documentRef.collection(KOrdersDetails).doc().set(
              {
                KProductsName:product.pName,
                KProductsPrice:product.pPrice,
                KProductQuantity:product.quantity,
                KProductsLocation:product.pLocation,
                KProductsCategory:product.pCategory
              });
        }

  }
  Stream<QuerySnapshot>loadOrders()
  {
    return firestore.collection(KOrders).snapshots();
  }
  Stream<QuerySnapshot>loadUsers()
  {
    return firestore.collection(KUsers).snapshots();
  }
  Stream<QuerySnapshot>loadUsersDetails(domcumentId)
  {
    return firestore.collection(KUsers).doc(domcumentId).collection(KOrdersDetails).snapshots();
  }
  Stream<QuerySnapshot>loadOrderDetails(domcumentId)
  {
    return firestore.collection(KOrders).doc(domcumentId).collection(KOrdersDetails).snapshots();
  }
}