import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_app/provider/Products.dart';
import 'package:product_app/widgets/BorderIcon.dart';
import 'package:product_app/widgets/OptionButton.dart';
import 'package:product_app/widgets/ProductsGrid.dart';
import 'package:product_app/widgets/app_drawer.dart';
import 'package:product_app/widgets/constants.dart';
import 'package:product_app/widgets/widget_function.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  // ProductOverviewScreen({Key key, title}) : super(key: key);
  static const routeName = "/user-products";
  ProductScreen(this.title);

  final String title;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _showFavourite = false;
  bool _isInit = true;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
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
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
      child: Scaffold(
          drawer: AppDrawer(key:UniqueKey()),
          key: _key,
          body: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _key.currentState!.openDrawer(),
                            // <-- Opens drawer
                            child: BorderIcon(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.all(10.0),
                              key: UniqueKey(),
                              child: Icon(
                                Icons.menu,
                                color: COLOR_BLACK,
                              ),
                            ),
                          ),
                          Padding(
                            padding: sidePadding,
                            child: Text(
                              "ES STORE KH",
                              style: themeData.textTheme.bodyText2,
                            ),
                          ),
                          BorderIcon(
                            key: UniqueKey(),
                            padding: EdgeInsets.all(10.0),
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.settings,
                              color: COLOR_BLACK,
                            ),
                          ),
                        ],
                      ),
                    ),
                    addVerticalSpace(5),

                    Container(
                        // padding: sidePadding,
                        child: Divider(
                      height: 25,
                      color: COLOR_GREY,
                    )),
                    addVerticalSpace(10),
                    Expanded(
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator(),)
                          : ProductsGrid(_showFavourite),
                    ),
                  ],
                ),


              ],
            ),
          )),
    );
  }
}
