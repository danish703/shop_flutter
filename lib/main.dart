import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/product_details_screen.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/providers/order.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/user_product_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/providers/auth.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth,Products>(
            value
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Orders(),
          ),
          ChangeNotifierProvider.value(
            value: Auth(),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "My Shop",
            theme: ThemeData(
                primarySwatch: Colors.red,
                accentColor: Colors.pink,
                fontFamily: 'Lato'),
            home: auth.isAuth ? ProductOverview():AuthScreen(),
            routes: {
              ProductDetails.routeName: (ctx) => ProductDetails(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProduct.routeName: (ctx) => UserProduct(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
