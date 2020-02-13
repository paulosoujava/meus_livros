import 'package:meus_livros/db/entity.dart';
import 'dart:convert' as convert;

import 'package:meus_livros/entity/Book.dart';

class User extends Entity{

  int id;
  String name;
  String email;
  String phone;
  String dateLend;
  String dateBackBook;
  String idBook;
  Book book;

  User({this.id, this.name, this.email, this.phone, this.dateLend, this.dateBackBook,
      this.idBook});


  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name']?? "";
    email = map['email']?? "";
    phone = map['phone']?? "";
    dateLend = map['dateLend']?? "";
    dateBackBook = map['dateBackBook']?? "";
    idBook = map['idBook']?? "";


  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['email'] = this.email;
    map['dateLend'] = this.dateLend;
    map['phone'] = this.phone;
    map['dateBackBook'] = this.dateBackBook;
    map['idBook'] = this.idBook;
    return map;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, phone: $phone, dateLend: $dateLend, dateBackBook: $dateBackBook, idBook: $idBook, book: $book}';
  }


}