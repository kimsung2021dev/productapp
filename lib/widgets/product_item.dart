import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_app/models/card.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/screens/product_detail.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final Product prd;
  //
  // ProductItem(this.prd);

  @override
  Widget build(BuildContext context) {
    // final prd = Provider.of<Product>(context);
    final cardItem = Provider.of<CardProvider>(context, listen: false);
    // return Consumer<Product>(UniqueKey(),builder: (context, value, child) =>  ,)
    return Consumer<Product>(
      builder: ( context, prd,  child) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: prd.id),
          child: GridTile(
            child: Image.network(
              prd.imgUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
                backgroundColor: Colors.black45,
                leading: IconButton(
                  icon: prd.isFav
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_outline),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    prd.toggleFavorite();
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    cardItem.addItem(prd.id, prd.price, prd.title);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Add item to card'),
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () {
                            cardItem.removeSingleItem(prd.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
                title: Text(
                  prd.title,
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      ),
    );
  }
}
