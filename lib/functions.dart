import 'package:e_commerce/models/User.dart';

import 'models/product.dart';

List<Product> getProductByCategory(String pcategory,List<Product>allproduct)
{
  List<Product>products=[];
  try{
  for(var product in allproduct)
  {
    if(product.pCategory==pcategory)
    {
      products.add(product);
    }
  }} on Error catch(ex){print(ex);}
  return products;
}
List<User> getUserByCategory(String ucategory,List<User>allUsers)
{
  List<User>users=[];
  try{
    for(var user in allUsers)
    {
      if(user.uRole==ucategory)
      {
        users.add(user);
      }
    }} on Error catch(ex){print(ex);}
  return users;
}
List<User> getUser(String mail,List<User>allUsers)
{
  List<User>users=[];
  try{
    for(var user in allUsers)
    {
      if(user.uMail==mail)
      {
        users.add(user);
      }
    }} on Error catch(ex){print(ex);}
  return users;
}