import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:meus_livros/api/firebase_service.dart';
import 'package:meus_livros/bloc/book_bloc.dart';
import 'package:meus_livros/db/book_dao.dart';
import 'package:meus_livros/entity/Book.dart';
import 'package:meus_livros/pages/list_lend.dart';
import 'package:meus_livros/pages/create_book.dart';
import 'package:meus_livros/pages/next_to_buy_list.dart';
import 'package:meus_livros/utils/assets.dart';
import 'package:meus_livros/utils/event_bus.dart';
import 'package:meus_livros/utils/prefs.dart';
import 'package:meus_livros/utils/util.dart';
import 'package:meus_livros/welcome/welcome.dart';
import 'package:meus_livros/widgets/error.dart';
import 'package:meus_livros/widgets/item_book.dart';
import 'package:nice_button/nice_button.dart';

class HomeBook extends StatefulWidget {
  @override
  _HomeBookState createState() => _HomeBookState();
}

class _HomeBookState extends State<HomeBook> {
  final BookBloc _bloc = BookBloc();
  StreamSubscription<Event> subscription;

  @override
  void initState() {
    super.initState();
    _bloc.fetch();
    //listen
    final bus = EventBus.get(context);
    subscription = bus.stream.listen((Event e) {
      print("Event $e");
      BookEvent bookEvent = e;
      if (bookEvent.action == "event_create") _bloc.fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    print( _bloc.find() );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          _buildPopupMenuButton(),
        ],
        backgroundColor: Color(0xfffbb448),
        leading: Icon(Icons.library_books),
        title: Text(
          'Meus Livros',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 16,
      ),
      body: SafeArea(
          child: StreamBuilder(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          return _container(snapshot);
        },
      )),
    );
    ;
  }

  _buildPopupMenuButton() {
    return PopupMenuButton<String>(
      onSelected: _onClickPopupMenu,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: "1",
            child: Text("Cadastrar"),
          ),
          PopupMenuItem(
            value: "2",
            child: Text("Comprar"),
          ),
          PopupMenuItem(
            value: "4",
            child: Text("Emprestado"),
          ),
          PopupMenuItem(
            value: "3",
            child: Text("Logout"),
          ),
        ];
      },
    );
  }

  _onClickPopupMenu(String value) {
    switch (value) {
      case "1":
        push(context, CreateBook("Cadastrar"));
        break;
      case "2":
        push(context, NextToBuyList());
        break;
      case "3":
        logout(context);
        break;
      case "4":
        push(context, About());
        break;
    }
  }

  logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Logout"),
            content: Text("Deseja fazer logout do sistema?"),
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
                  Prefs.setBool("LOGIN", false);
                  FirebaseService().logout();
                  Navigator.pop(context);
                  push(context, Welcome(), replace: true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _container(snapshot) {
    if (snapshot.data.toString().length == 2)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Error("Nenhum livro cadastrado", title: "Ops ", isEmpty: true),
            _createFirstBook(),
          ],
        ),
      );

    if (snapshot.hasError)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Error(snapshot.error),
          ],
        ),
      );
    if (!snapshot.hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Por favor aguarde...",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                decoration: TextDecoration.none,
              ),
            ),
            LoadingBouncingLine.circle(
              size: 45,
              backgroundColor: Color(0xfffbb448),
              duration: Duration(milliseconds: 900),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Colors.green,
      child: ItemBook(snapshot.data),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Future<void> _onRefresh() {
    return _bloc.fetch();
  }

  _createFirstBook() {
    return NiceButton(
      width: 410,
      elevation: 8,
      radius: 10,
      gradientColors: [Color(0xfffbb448), Color(0xfff7892b)],
      text: "Cadastrar",
      onPressed: () {
        push(context, CreateBook("Cadastrar"));
      },
    );
  }
}
