import 'package:flutter/foundation.dart';

class CardItem {
  String id, title;
  int qty;
  String price;

  CardItem(
      {required this.id,
      required this.title,
      required this.qty,
      required this.price});
}

class CardProvider with ChangeNotifier {
  Map<String, CardItem> _items = {};

  Map<String, CardItem> get items {
    return {..._items};
  }

  int get itemCount {
    if (_items.isEmpty) {
      return 0;
    } else {
      return _items.length;
    }
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cardItem) {
      total += double.parse(cardItem.price) * cardItem.qty;
    });
    return total;
  }

  void addItem(String prdId, String prdPrice, String prdItem) {
    if (_items.containsKey(prdId)) {
      _items.update(
          prdId,
          (existingItem) => CardItem(
              id: existingItem.id,
              title: prdItem,
              qty: existingItem.qty + 1,
              price: prdPrice));
    } else {
      _items.putIfAbsent(
          prdId,
          () => CardItem(
              id: DateTime.now().toString(),
              title: prdItem,
              qty: 1,
              price: prdPrice));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String prdID) {
    if (!_items.containsKey(prdID)) {
      return;
    }
    if (_items[prdID]!.qty > 1) {
      _items.update(
          prdID,
          (ext) => CardItem(
              id: ext.id,
              title: ext.title,
              qty: ext.qty - 1,
              price: ext.price));
    }else{
      _items.remove(prdID);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
