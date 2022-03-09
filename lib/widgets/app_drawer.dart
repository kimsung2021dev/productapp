import 'package:flutter/material.dart';
import 'package:product_app/screens/order_screen.dart';
import 'package:product_app/screens/user_product_screen.dart';
import 'package:product_app/widgets/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: COLOR_DRAWER_BG,
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Kimsung'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
