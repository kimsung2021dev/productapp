import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String id, title, desc, imgUrl;
  String price;
  bool isFav;

  Product(
      {required this.id,
      required this.title,
      required this.desc,
      required this.price,
      required this.imgUrl,
      this.isFav = false});

  Future<void> toggleFavorite() async {
    isFav = !isFav;
    notifyListeners();
    String url =
        "https://productapp-64dc7-default-rtdb.firebaseio.com/product/$id.json";
    final response = await http.patch(Uri.parse(url),
        body: json.encode({'isFavourite': isFav}));
  }
}
