import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:meus_livros/db/book_dao.dart';
import 'package:meus_livros/entity/Book.dart';
import 'package:meus_livros/utils/bezierContainer.dart';
import 'package:meus_livros/widgets/back_button.dart';
import 'package:meus_livros/widgets/error.dart';
import 'package:meus_livros/widgets/my_title.dart';
import 'package:nice_button/nice_button.dart';

class NextToRead extends StatefulWidget {
  @override
  _NextToReadState createState() => _NextToReadState();
}

class _NextToReadState extends State<NextToRead> {
  bool isShow = false;
  List<Book> books;

  @override
  void initState() {
    _isProgess(true);
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Positioned(
        top: -MediaQuery.of(context).size.height * .15,
        right: -MediaQuery.of(context).size.width * .4,
        child: BezierContainer(),
      ),
      _header(context),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            height: 90,
          ),
          MyBackButton(),
        ],
      ),
      Container(
          margin: EdgeInsets.only(top: 110, left: 10),
          child: (books == null || books.length == 0)
              ? Container(
                  margin: EdgeInsets.only(top: 210),
                  child: Center(
                      child: Error(
                    "Nenhum livro emprestado",
                    title: "Opa",
                  )),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: books == null ? 0 : books.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
                          child: Column(
                            children: <Widget>[
                              isShow
                                  ? Center(
                                      child: LoadingRotating.square(
                                        borderColor: Color(0xfffbb448),
                                        backgroundColor: Colors.black,
                                        size: 50.0,
                                      ),
                                    )
                                  : Material(
                                      borderRadius: BorderRadius.circular(5.0),
                                      elevation: 3.0,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  height: 80,
                                                  child: Image.file(
                                                      File(books[index].url)),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "${books[index].title}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "${books[index].category}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),

                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 15,
                          child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              padding: EdgeInsets.all(0.0),
                              color: Color(0xffe46b10),
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _deletar(context, books[index]);
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ))
    ]));
  }

  _header(context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyTitle(),
          Text(
            "Livros emprestados",
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _loadData() async {
    books = await BookDAO().findAllByReading();
    _isProgess(false);
  }

  void _isProgess(bool isOk) {
    setState(() {
      isShow = isOk;
    });
  }

  _deletar(context, Book book) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Remover?"),
            content: Text("Desejas remover da lista?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Não"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: () async {
                  Navigator.pop(context);
                  _isProgess(true);
                  book.witchPage = "";
                  await BookDAO().save(book);

                  _loadData();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
