import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orders;
  OrderItem(this.orders);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expaned = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Rs.${widget.orders.amount}"),
            subtitle: Text(widget.orders.datetime.toString()),
            trailing: IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expaned = !_expaned;
                  });
                }),
          ),
          if (_expaned)
            Container(
              height: min(widget.orders.products.length * 20 + 100.0, 180.0),
              child: ListView(
                children: widget.orders.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${prod.price} X ${prod.quantity}",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
