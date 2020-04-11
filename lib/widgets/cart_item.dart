import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
class CartItem extends StatelessWidget {
  final String title;
  final String id;
  final String productKey;
  final double price;
  final int quantity;
  CartItem(this.id,this.productKey, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 4.0),
        child: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 8.0),
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context,builder: (ctx)=>AlertDialog(
          title: Text("Are you sure ?"),
          content: Text("Do you really want to remove item from cart ?"),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: Text("No")),
            FlatButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: Text("Yes"))
          ],
        ));
      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(productKey);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("$price"),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Total:Rs.${price * quantity}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
