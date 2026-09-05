// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shopping/models/catalog.dart';
import 'package:shopping/widgets/home_widgets/add_to_cart.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeDetailsPage extends StatelessWidget {

  final Item catalog;
  
    const HomeDetailsPage({ super.key, required this.catalog});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(backgroundColor: context.canvasColor),
      backgroundColor: context.canvasColor,
      bottomNavigationBar: Container(
        color: context.cardColor,
        child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "\$${catalog.price}".text.bold.xl4.red800.make(),
                  AddToCart(catalog)
                ],
                ).p32(),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Hero(
              tag: Key(catalog.id.toString()),
              child: Image.network(catalog.imgUrl)).h32(context).p16(),
              Expanded(child: VxArc(
                height: 30.0,
                arcType: VxArcType.convey,
                edge: VxEdge.top,
                child: Container(
                  width: context.screenWidth,
                   color: context.cardColor,
                   child:Column(
                    children: [
            catalog.name.text.xl4.color(Theme.of(context).colorScheme.secondary).bold.make(),
            catalog.desc.text.xl.textStyle(context.captionStyle).make(),
            10.heightBox,
            "Brand of mobile ${catalog.name} having the model ${catalog.desc} which under the price \$${catalog.price}".text.textStyle(context.captionStyle).make().px32() 
                   ],
                   ).py64()
                ),
              )
              )
          ],
        ),
      ),
    );
  }
}
