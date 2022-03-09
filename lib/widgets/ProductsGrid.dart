import 'package:flutter/widgets.dart';
import 'package:product_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../provider/Products.dart';

// ignore: must_be_immutable
class ProductsGrid extends StatelessWidget {
  bool _showFavourite;

  ProductsGrid(this._showFavourite);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Products>(context);
    final products = _showFavourite ? provider.favItems : provider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: products[i], child: ProductItem()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: products.length,
    );
  }
}
