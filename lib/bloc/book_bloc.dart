import 'package:meus_livros/bloc/generic_bloc.dart';
import 'package:meus_livros/db/book_dao.dart';
import 'package:meus_livros/entity/Book.dart';

class BookBloc extends GenericBloc<List<Book>> {
  Future<List<Book>> fetch({bool isBuy = false }) async {
    try {

        return await getBookisBuy(isBuy ? "true" : "false");

    } catch (e) {
      addError(
          "Desculpe, estava lendo e esqueci de programar esta parte, por favor tente mais tarde.");
    }
  }
  Future<List<Book>> find() async  {
    for (Book k in  await BookDAO().findAll()) {
      print(k);
    }
  }
  Future<List<Book>> getBookisBuy(String isBuy) async {
    List<Book> books;
    books = await BookDAO().findAllBy(isBuy);
    add(books);
    return books;
  }
  
  Future<List<Book>> getBooks() async {
    List<Book> books;
    books = await BookDAO().findAll();
    add(books);
    return books;
  }

  Future<bool> saveBook(Book b) async {
    int ok;
      ok = await BookDAO().save(b);
    if (ok > 0) {
      return true;
    }
    return false;
  }
}
