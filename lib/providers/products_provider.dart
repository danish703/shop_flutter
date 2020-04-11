import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop/configration/urls.dart';

class Products with ChangeNotifier {
  var token;
  void settoken(t){
    token=t;
  }
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetData() async {
    try {
      final response = await http.get(productUrl);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProduct = [];
      extractedData.forEach((key, value) {
        loadedProduct.insert(
            0,
            Product(
                id: key,
                title: value['title'],
                description: value['description'],
                price: value['price'],
                isFavorite: value['isFavorite'],
                imageUrl: value['imageUrl']));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(productUrl,
          body: json.encode({
            'title': product.title,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'description': product.description,
            'isFavorite': product.isFavorite
          }));
      var newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> get favoriteOnly {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = singleProductUrl(id);
    final index = _items.indexWhere((pro) => pro.id == id);
    if (index >= 0) {
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
              'isFavorite': newProduct.isFavorite
            }));
        _items[index] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  void deleteProduct(String id) async {
    final url = singleProductUrl(id);
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete");
    }
    existingProduct = null;
    notifyListeners();
  }
}
