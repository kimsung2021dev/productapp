import 'package:flutter/material.dart';
import 'package:product_app/models/card.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int qty;
  final String title;

  CardWidget(this.id, this.price, this.qty, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to remove the item from the card?'),
                  actions: [
                    TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }),
                    TextButton(
                        onPressed: () {
                          Provider.of<CardProvider>(context, listen: false).removeItem(productId);
                          Navigator.of(context).pop(true);

                          },
                        child: Text('Yes'))
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<CardProvider>(context, listen: false).removeItem(productId);
      },
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Text('\$$price'),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * qty}'),
            trailing: Text('$qty x'),
          ),
        ),
      ),
    );
  }
}
