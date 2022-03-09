import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_app/models/card.dart';
import 'package:product_app/provider/Products.dart';
import 'package:product_app/provider/orders.dart';
import 'package:product_app/screens/card_screen.dart';
import 'package:product_app/screens/edit_product.dart';
import 'package:product_app/screens/order_screen.dart';
import 'package:product_app/screens/product_detail.dart';
import 'package:product_app/screens/product_overview.dart';
import 'package:product_app/screens/product_screen.dart';
import 'package:product_app/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(child: Text("ERROR SNAPSHOT"));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: Text("ERROR SNAPSHOT"));
      },
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => CardProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme:CustomTheme.lightTheme,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.cyan,

          // Define the default font family.
          fontFamily: 'Georgia',
          scaffoldBackgroundColor: Colors.white,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan),
          // fontFamily: 'Montserrat',
          // buttonTheme: ButtonThemeData(
          //   shape:
          //   RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          //   buttonColor: Colors.purpleAccent,
          // ),

          // textTheme: const TextTheme(
          //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          // ),
        ),
        home: ProductOverviewScreen("ES STORE"),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CardScreen.routeName: (ctx) => CardScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProduct.routeName: (ctx) => EditProduct(),
        },
      ),
    );
  }
}
