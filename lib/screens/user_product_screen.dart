import 'package:flutter/material.dart';
import 'package:product_app/provider/Products.dart';
import 'package:product_app/screens/edit_product.dart';
import 'package:product_app/widgets/app_drawer.dart';
import 'package:product_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final prdData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Product'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProduct.routeName,arguments: "" );
              }),
        ],
      ),
      drawer: AppDrawer(key: UniqueKey()),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemBuilder: (ctx, i) => Column(
                    children: [
                      UserProductItem(prdData.items[i].title,
                          prdData.items[i].imgUrl, prdData.items[i].id),
                      Divider(),
                    ],
                  ),
              itemCount: prdData.items.length),
        ),
      ),
    );
  }
}
