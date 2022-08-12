import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  // List<Product> _items = [];
  var showFavouriteOnly = false;
  List<Product> _items = [
    // Product(
    //     title: "Ice Latte",
    //     id: "1",
    //     desc: "Tube Cafe",
    //     price: 2.5,
    //     imgUrl:
    //         "https://www.browncoffee.com.kh/uploads/ximg/item_menus/2020111209575908bca42ec2946c1e896c5a10224ca7d8.jpg"),
    // Product(
    //     title: "Frappe",
    //     id: "2",
    //     desc: "Tube Cafe",
    //     price: 1.5,
    //     imgUrl:
    //         "https://i.picsum.photos/id/744/200/300.jpg?hmac=QB_puLFiEKiOkiVJXMeY6ie3KJ4AgggamJiRa4kobOo"),
    // Product(
    //     title: "Cappuccino",
    //     id: "3",
    //     desc: "Tube Cafe",
    //     price: 3.5,
    //     imgUrl:
    //         "https://i.picsum.photos/id/744/200/300.jpg?hmac=QB_puLFiEKiOkiVJXMeY6ie3KJ4AgggamJiRa4kobOo"),
    // Product(
    //     title: "Milk Tea",
    //     id: "4",
    //     desc: "Tube Cafe",
    //     price: 2.5,
    //     imgUrl:
    //         "https://i.picsum.photos/id/744/200/300.jpg?hmac=QB_puLFiEKiOkiVJXMeY6ie3KJ4AgggamJiRa4kobOo"),
    // Product(
    //     title: "Green Tea",
    //     id: "5",
    //     desc: "Tube Cafe",
    //     price: 2.5,
    //     imgUrl:
    //         "https://i.picsum.photos/id/744/200/300.jpg?hmac=QB_puLFiEKiOkiVJXMeY6ie3KJ4AgggamJiRa4kobOo"),
    // Product(
    //     title: "Black Tea",
    //     id: "6",
    //     desc: "Tube Cafe",
    //     price: 1.5,
    //     imgUrl:
    //         "https://i.picsum.photos/id/744/200/300.jpg?hmac=QB_puLFiEKiOkiVJXMeY6ie3KJ4AgggamJiRa4kobOo"),
    // Product(
    //     title: "Coffee",
    //     id: "1",
    //     desc: "Tube Cafe",
    //     price: 2.5,
    //     imgUrl:
    //         "https://i.picsum.photos/id/744/200/300.jpg?hmac=QB_puLFiEKiOkiVJXMeY6ie3KJ4AgggamJiRa4kobOo"),
    // Product(
    //     title: "Coffee",
    //     id: "7",
    //     desc: "Tube Cafe",
    //     price: 2.5,
    //     imgUrl:
    //         "https://i.picsum.photos/id/744/200/300.jpg?hmac=QB_puLFiEKiOkiVJXMeY6ie3KJ4AgggamJiRa4kobOo"),
  ];

  // getProductFromFirebase(){
  //   final dbRef = Firebase.app().child("pets");
  // }

  Future<void> fetchAndSetProducts() async {
    const url =
        "https://productapp-64dc7-default-rtdb.firebaseio.com/product.json";
    final response = await http.get((Uri.parse(url)));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadProducts = [];
    extractedData.forEach((prodId, prdData) {
      loadProducts.add(Product(
          id: prodId,
          title: prdData['title'],
          desc: prdData['desc'],
          price: prdData['price'],
          imgUrl: prdData['imgUrl'],
          isFav: prdData['isFavourite']));
    });
    _items = loadProducts;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prodItem) => prodItem.isFav).toList();
  }

// void showFavOnly(){
//   showFavouriteOnly=true;
//   notifyListeners();
// }
// void showAll(){
//   showFavouriteOnly=false;
//   notifyListeners();
// }

  Future<void> addProduct(Product prd) async {
    const url =
        "https://productapp-64dc7-default-rtdb.firebaseio.com/product.json";
    return http
        .post(Uri.parse(url),
            body: json.encode({
              'title': prd.title,
              'desc': prd.desc,
              'imgUrl': prd.imgUrl,
              'price': prd.price,
              'isFavourite': prd.isFav
            }))
        .then((value) {
      print(json.decode(value.body));
      final newProduct = Product(
          title: prd.title,
          price: prd.price,
          desc: prd.desc,
          imgUrl: prd.imgUrl,
          id: json.decode(value.body)['name']);
      print(newProduct.id);
      _items.add(newProduct);
      notifyListeners();
    });
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateExistingProduct(String id, Product newPrd) async {
    final prdIndex = _items.indexWhere((prd) => prd.id == id);
    if (prdIndex >= 0) {
      String url =
          "https://productapp-64dc7-default-rtdb.firebaseio.com/product/$id.json";
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newPrd.title,
            'desc': newPrd.desc,
            'price': newPrd.price,
            'isFavourite': newPrd.isFav,
            'imgUrl': newPrd.imgUrl
          }));
      _items[prdIndex] = newPrd;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProduct(String id) async {
    String url =
        "https://productapp-64dc7-default-rtdb.firebaseio.com/product/$id.json";
    final existingPrdIndex = _items.indexWhere((prd) => prd.id == id);
    final existingPrd = _items[existingPrdIndex];
    _items.removeAt(existingPrdIndex);
    notifyListeners();
    http
        .delete(Uri.parse(url))
        .then((value) => existingPrd == null)
        .catchError((_) {
      _items.insert(existingPrdIndex, existingPrd);
      notifyListeners();
    });
  }
}
