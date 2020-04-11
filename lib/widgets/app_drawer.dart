import 'package:flutter/material.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/user_product_screen.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Shop Now"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.red,
              ),
              title: Text("Home"),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.red,
              ),
              title: Text("Order"),
              onTap: () {
                Navigator.of(context).pushNamed(OrderScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.red,
              ),
              title: Text("Your Product"),
              onTap: () {
                Navigator.of(context).pushNamed(UserProduct.routeName);
              }),
        ],
      ),
    );
  }
}
