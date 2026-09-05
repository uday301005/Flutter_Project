// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CatalogModel {

  static List<Item> items = [];

  // Get Item By ID

  Item getById(int id) =>
      items.firstWhere((element) => element.id == id, orElse: null);

  // Get Item By position

 Item getByPosition(int pos) => items[pos];
}

class Item {
  final int id;
  final String name;
  final String desc;
  final String color;
  final String imgUrl;
  final num price;

  Item({
    required this.id,
    required this.name,
    required this.desc,
    required this.color,
    required this.imgUrl,
    required this.price,
  });
  Item copyWith({
    int? id,
    String? name,
    String? desc,
    String? color,
    String? imgUrl,
    num? price,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      color: color ?? this.color,
      imgUrl: imgUrl ?? this.imgUrl,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'desc': desc,
      'color': color,
      'image': imgUrl,
      'price': price,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      desc: map['desc'],
      color: map['color'],
      imgUrl: map['image'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Item(id: $id, name: $name, desc: $desc, color: $color, imgUrl: $imgUrl, price: $price)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.desc == desc &&
        other.color == color &&
        other.imgUrl == imgUrl &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        desc.hashCode ^
        color.hashCode ^
        imgUrl.hashCode ^
        price.hashCode;
  }
}
