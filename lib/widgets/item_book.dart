import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meus_livros/db/book_dao.dart';
import 'package:meus_livros/db/user_dao.dart';
import 'package:meus_livros/entity/Book.dart';
import 'package:meus_livros/pages/create_book.dart';
import 'package:meus_livros/pages/lend_book.dart';
import 'package:meus_livros/pages/next_read.dart';
import 'package:meus_livros/pages/next_to_buy_list.dart';
import 'package:meus_livros/utils/event_bus.dart';
import 'package:meus_livros/utils/util.dart';
import 'package:nice_button/nice_button.dart';

class ItemBook extends StatelessWidget {
  List<Book> items;

  ItemBook(this.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: items != null ? items.length : 0,
        itemBuilder: (context, idx) {
          Book b = items[idx];
          print(b);
          return Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            margin: EdgeInsets.only(bottom: 20.0),
            height: 300,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: b.url == ""
                              ? ExactAssetImage("assets/images/book.png")
                              : FileImage(File(b.url))),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(5.0, 5.0),
                            blurRadius: 10.0)
                      ]),
                )),
                Expanded(
                  child: Container(
                    height: 260,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.list),
                                tooltip: 'Menu de opções',
                                onPressed: () {
                                  _bottom(context, b);
                                }),
                          ],
                        ),
                        Text("Título: ",
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        Text(
                          " ${b.title}",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.portLligatSans(
                            textStyle: Theme.of(context).textTheme.display1,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("Categoria: ",
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        Text(
                          " ${b.category}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.portLligatSans(
                            textStyle: Theme.of(context).textTheme.display1,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        b.isLeading == "true"
                            ? Text(
                                "EMPRESTADO",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.portLligatSans(
                                  textStyle:
                                      Theme.of(context).textTheme.display1,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                ),
                              )
                            : SizedBox(),
                        b.reading == "true"
                            ? Text(
                                "LENDO",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.portLligatSans(
                                  textStyle:
                                      Theme.of(context).textTheme.display1,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: b.reading == "true"
                                  ? Colors.amber
                                  : b.isLeading == "true"
                                      ? Colors.red
                                      : Colors.grey,
                              offset: Offset(5.0, 5.0),
                              blurRadius: 10.0)
                        ]),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _bottom(BuildContext context, Book b) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "O que deseja fazer com este livro?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      letterSpacing: 1,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  (b.isBuy == "false")
                      ? ListTile(
                          leading: new Icon(Icons.chrome_reader_mode),
                          title: Text(
                            b.reading == "true"
                                ? "Finalizar Leitura"
                                : "Iniciar Leitura deste",
                            style: GoogleFonts.portLligatSans(
                              textStyle: Theme.of(context).textTheme.display1,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () async {
                            pop(context);
                            if (b.reading == "true")
                              b.reading = "false";
                            else
                              b.reading = "true";

                            await BookDAO().save(b);
                            opsAlert(context, "Ação realizada com sucesso",
                                ops: "Opaa");
                            EventBus.get(context)
                                .sendEvent(BookEvent("event_create"));
                          },
                        )
                      : SizedBox(),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: new Icon(Icons.edit),
                    title: Text(
                      b.isBuy == "true" ? "Já comprei" : "Editar",
                      style: GoogleFonts.portLligatSans(
                        textStyle: Theme.of(context).textTheme.display1,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      pop(context);
                      if (b.isBuy == "true") {
                        b.isBuy = "false";
                        b.photo = "assets/images/book.png";
                        await BookDAO().save(b);
                        opsAlert(context, "Ação realizada com sucesso",
                            ops: "Opaa");
                        EventBus.get(context)
                            .sendEvent(BookEvent("event_create_buy"));
                        EventBus.get(context)
                            .sendEvent(BookEvent("event_create"));
                      } else {
                        push(context, CreateBook("Atualizar", book: b));
                      }
                    },
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: new Icon(Icons.delete),
                    title: Text(
                      "Deletar",
                      style: GoogleFonts.portLligatSans(
                        textStyle: Theme.of(context).textTheme.display1,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      pop(context);
                      _deletar(b, context);
                    },
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  if (b.isBuy == "false") _containerBottom(context, b),
                ],
              ),
            ),
          );
        });
  }

  _deletar(Book b, context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Deletar"),
            content: Text("Desejas deletar: ${b.title}"),
            actions: <Widget>[
              FlatButton(
                child: Text("Não"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  Navigator.pop(context);
                  BookDAO().delete(b.id);
                  UserDAO().deleteLend(b.id);
                  if (b.isBuy == "true")
                    EventBus.get(context)
                        .sendEvent(BookEvent("event_create_buy"));
                  else
                    EventBus.get(context).sendEvent(BookEvent("event_create"));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _containerBottom(context, Book b) {
    return Column(
      children: <Widget>[
        _isLeanding(context, b),
        ListTile(
          leading: new Icon(Icons.format_indent_decrease),
          title: Text(
            "Próximo a ler",
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          onTap: () {
            pop(context);
            b.witchPage = "next";
            BookDAO().save(b);
            push(context, NextToRead());
          },
        ),
      ],
    );
  }

  _isLeanding(context, Book b) {
    if (b.isLeading == "false") {
      return Column(
        children: <Widget>[
          ListTile(
            leading: new Icon(Icons.perm_contact_calendar),
            title: Text(
              "Emprestar",
              style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.display1,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            onTap: () {
              pop(context);
              push(
                context,
                LendBook(
                  b,
                ),
              );
            },
          ),
          Divider(
            height: 1,
            color: Colors.black,
          ),
        ],
      );
    }
    return Container();
  }
}

/*
Image.asset("assets/images/back.jpg", fit: BoxFit.cover,
           height: double.infinity,
           width: double.infinity,
           alignment: Alignment.center),
 */
