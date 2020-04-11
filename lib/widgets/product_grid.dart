import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final _showFav;

  ProductGrid(this._showFav);

  @override
  Widget build(BuildContext context) { 
    final productsData = Provider.of<Products>(context);
    final loadedProduct = _showFav ? productsData.favoriteOnly : productsData.items;
    return GridView.builder(
      itemCount: loadedProduct.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value:loadedProduct[i],
        child: ProductItem(),
      ),
    );
  }
}
