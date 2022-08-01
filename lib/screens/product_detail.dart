import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/Products.dart';

// ignore: must_be_immutable
class ProductDetailScreen extends StatelessWidget {
  late String title;

  // ProductDetailScreen(this.title);
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false)
        .items
        .firstWhere((prod) => prod.id == productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height:10),
            Text('\$${loadedProduct.price}',style: TextStyle(color: Colors.grey,fontSize: 20),),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(loadedProduct.desc,textAlign: TextAlign.center ,softWrap: true,))
          ],
        ),
      )
    );
  }
}
