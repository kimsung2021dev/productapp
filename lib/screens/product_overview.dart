import 'package:flutter/material.dart';
import 'package:product_app/models/card.dart';
import 'package:product_app/provider/Products.dart';
import 'package:product_app/screens/card_screen.dart';
import 'package:product_app/widgets/app_drawer.dart';
import 'package:product_app/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../widgets/ProductsGrid.dart';

enum FilterOption { All, Favourites }

class ProductOverviewScreen extends StatefulWidget {
  // ProductOverviewScreen({Key key, title}) : super(key: key);

  ProductOverviewScreen(this.title);

  final String title;

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavourite = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context)
          .fetchAndSetProducts()
          .then((value) => _isLoading = false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            // PopupMenuButton(
            //   onSelected: (FilterOption selectedValue) {
            //     setState(() {
            //       if (selectedValue == FilterOption.All) {
            //         print('ALL');
            //         _showFavourite = false;
            //       } else {
            //         print('Fav');
            //         _showFavourite = true;
            //       }
            //     });
            //   },
            //   icon: Icon(Icons.more_vert),
            //   itemBuilder: (_) => [
            //     PopupMenuItem(
            //       child: Text("Only Favourites"),
            //       value: FilterOption.Favourites,
            //     ),
            //     PopupMenuItem(
            //       child: Text("Show All"),
            //       value: FilterOption.All,
            //     ),
            //   ],
            // ),
            Consumer<CardProvider>(
              builder: (_, cardData, ch) => Badge(
                value: cardData.itemCount.toString(),
                key: UniqueKey(),
                color: Colors.blue,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CardScreen.routeName);
                  },
                ),
              ),
            )
          ],
        ),
        drawer: AppDrawer(
          key: UniqueKey(),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showFavourite));
  }
}
