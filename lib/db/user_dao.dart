import 'dart:async';

import 'package:meus_livros/db/base_dao.dart';
import 'package:meus_livros/entity/Book.dart';
import 'package:meus_livros/entity/User.dart';


// Data Access Object
class UserDAO extends BaseDAO<User> {

  @override
  String get tableName => "user";

  @override
  User fromMap(Map<String, dynamic> map) {
    return User.fromMap(map);
  }

  Future<List<User>> findAllByLend() {
    return query('select * from user');
  }

  Future<int> deleteLend(int id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from $tableName where idBook = ?', [id]);
  }
}