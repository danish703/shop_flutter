import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/product_grid.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/providers/products_provider.dart';

enum FilterOptions { Favorite, All }

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetData().then((_) {
        setState(() {
          _isLoading = false; 
        });
      });

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  var _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop App"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedOption) {
              setState(() {
                if (selectedOption == FilterOptions.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Favorites"),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text("All"),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                  color: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                  value: cart.itemCount.toString()))
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavoriteOnly),
    );
  }
}
