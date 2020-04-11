import 'dart:convert';

import './cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/configration/urls.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.products,
    @required this.amount,
    @required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItem = [];

  List<OrderItem> get items {
    return [..._orderItem];
  }

  Future<void> fetchAndSetData() async {
    final url = orderUrl;
    final response = await http.get(url);
    List<OrderItem> loadedOrderItem = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData==null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrderItem.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          datetime: DateTime.parse(orderData['datetime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ))
              .toList()));
    });
    _orderItem=loadedOrderItem.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url = orderUrl;
    print("add order called");
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': timeStamp.toIso8601String(),
          'products': cartProduct
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList()
        }));
    _orderItem.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            products: cartProduct,
            amount: total,
            datetime: timeStamp));
    notifyListeners();
  }
}
