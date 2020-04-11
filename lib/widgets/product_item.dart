import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/screens/product_details_screen.dart';
import 'package:shop/providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              ProductDetails.routeName,
              arguments: product.id,
            ),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor),
              onPressed: () {
                product.toggleFavorite(product.id);
              },
              hoverColor: Colors.red,
              tooltip: "Favorite",
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  cart.addItem(product.id, product.title, product.price);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Item Added to Cart",
                      textAlign: TextAlign.center,
                    ),
                    action: SnackBarAction(label: "Undo", onPressed: () {
                      cart.removeSingleItem(product.id);
                    }),
                  ));
                }),
          )),
    );
  }
}
