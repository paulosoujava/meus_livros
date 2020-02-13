import 'package:meus_livros/db/entity.dart';
import 'dart:convert' as convert;

import 'package:meus_livros/utils/event_bus.dart';


class BookEvent extends Event{
  String action;

  BookEvent(this.action);

  @override
  String toString() {
    return 'BookEvent{action: $action}';
  }


}
class Book extends Entity{

  int id;
  String title;
  String photo;
  String url;
  String reading;
  String isLeading;
  String isBuy;
  String witchPage;
  String category;


  Book({this.id, this.title, this.isBuy, this.photo,  this.url, this.reading,
      this.isLeading, this.witchPage, this.category});


  Book.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title']?? "";
    isBuy = map['isBuy']?? "";
    photo = map['photo']?? "";
    url = map['url']?? "";
    reading = map['reading']?? "";
    isLeading = map['isLeading']?? "";
    witchPage = map['witchPage']?? "";
    category = map['category']?? "";

  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title?? "";
    map['photo'] = this.photo?? "";
    map['url'] = this.url?? "";
    map['reading'] = this.reading?? "";
    map['isLeading'] = this.isLeading?? "";
    map['witchPage'] = this.witchPage?? "";
    map['category'] = this.category?? "";
    map['isBuy'] = this.isBuy?? "";
    return map;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, isBuy: $isBuy, photo: $photo,  url: $url, reading: $reading, isLeading: $isLeading, witchPage: $witchPage, category $category}';
  }


}