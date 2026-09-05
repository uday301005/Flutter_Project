import 'package:flutter/material.dart';
import 'package:shopping/models/catalog.dart';
import 'package:shopping/pages/home_details.dart';
import 'package:shopping/widgets/home_widgets/catalog_Item.dart';

class CatalogList extends StatelessWidget {
  const CatalogList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: CatalogModel.items.length,
      itemBuilder: (context, index) {
        final catalog = CatalogModel.items[index];
        return InkWell(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeDetailsPage(catalog: catalog) )),
          child: CatalogItem(catalog: catalog));
      },
    );
  }
}
