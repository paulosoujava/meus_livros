import 'dart:async';

import 'package:meus_livros/db/base_dao.dart';
import 'package:meus_livros/entity/Book.dart';

// Data Access Object
class BookDAO extends BaseDAO<Book> {
  @override
  String get tableName => "book";

  @override
  Book fromMap(Map<String, dynamic> map) {
    return Book.fromMap(map);
  }

  Future<List<Book>> findAllByTipo(String category) {
    return query('select * from $tableName where category =? ', [category]);
  }

  Future<List<Book>> findAllBy(String isBuy) {
    return query('select * from book where isBuy  =? ', [isBuy]);
  }

  Future<List<Book>> findAllByReading() {
    return query('select * from book where witchPage  != "" ');
  }

  Future<Book> findBookId(int id) {
    return findById(id);
  }

}
