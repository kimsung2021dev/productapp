import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_app/models/card.dart';
import 'package:product_app/provider/orders.dart';
import 'package:product_app/widgets/card_widget.dart';
import 'package:provider/provider.dart';

class CardScreen extends StatelessWidget {
  static const routeName = '/card';

  @override
  Widget build(BuildContext context) {
    final card = Provider.of<CardProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Card"),
        ),
        body: Column(children: [
          Card(
              margin: EdgeInsets.all(10.0),
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(children: [
                    Text("Total", style: TextStyle(fontSize: 20.0)),
                    Spacer(),
                    Chip(
                        label: Text(
                          '\$${card.totalAmount}',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Theme.of(context).primaryColor),
                    TextButton(
                        onPressed: () {
                          Provider.of<Orders>(context, listen: false).addOrder(
                              card.items.values.toList(), card.totalAmount);
                          card.clear();
                        },
                        child: Text(
                          'ORDER NOW',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ]))),
          Expanded(
            child: ListView.builder(
                itemCount: card.itemCount,
                itemBuilder: (ctx, i) => CardWidget(
                    card.items.values.toList()[i].id,
                    card.items.values.toList()[i].price,
                    card.items.values.toList()[i].qty,
                    card.items.values.toList()[i].title,
                    card.items.keys.toList()[i])),
          )
        ]));
  }
}
