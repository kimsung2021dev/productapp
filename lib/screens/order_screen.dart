import 'package:flutter/material.dart';
import 'package:product_app/provider/orders.dart' show Orders;
import 'package:product_app/widgets/app_drawer.dart';
import 'package:product_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("You Orders"),
      ),
      drawer: AppDrawer(
        key: UniqueKey(),
      ),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
      ),
    );
  }
}
