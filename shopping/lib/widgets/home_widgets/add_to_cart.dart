import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:shopping/core/store.dart';
import 'package:shopping/models/cart.dart';
import 'package:shopping/models/catalog.dart';
import 'package:velocity_x/velocity_x.dart';

class AddToCart extends StatelessWidget {
  final Item catalog;

  const AddToCart(this.catalog, {super.key});

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on : [AddMutation,RemoveMutation]);

    final CartModel _cart = (VxState.store as MyStore).cart;
    bool isInCart = _cart.items.contains(catalog) ? true : false;
    return ElevatedButton(
      onPressed: () {
        if (!isInCart) {
          AddMutation(catalog);
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.primary,
        ),
      ),
      child: isInCart
          ? Icon(Icons.done, color: Colors.white)
          : Icon(CupertinoIcons.cart_badge_plus, color: Colors.white),
    );
  }
}
