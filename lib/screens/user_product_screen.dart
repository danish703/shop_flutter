import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';
import 'package:shop/screens/edit_product_screen.dart';

class UserProduct extends StatelessWidget {
  const UserProduct({Key key}) : super(key: key);
  static const routeName = '/user-product';
  Future<void> _refreshProduct(BuildContext context) async{
    await Provider.of<Products>(context).fetchAndSetData();
  }
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Product"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProduct(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, i) => Column(
                    children: <Widget>[
                      UserProductItem(
                        id: productsData.items[i].id,
                        title: productsData.items[i].title,
                        imageUrl: productsData.items[i].imageUrl,
                      ),
                      Divider(
                        thickness: 1.0,
                      )
                    ],
                  )),
        ),
      ),
    );
  }
}
