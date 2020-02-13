import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:meus_livros/bloc/book_bloc.dart';
import 'package:meus_livros/entity/Book.dart';
import 'package:meus_livros/pages/create_book.dart';
import 'package:meus_livros/utils/assets.dart';
import 'package:meus_livros/utils/bezierContainer.dart';
import 'package:meus_livros/utils/event_bus.dart';
import 'package:meus_livros/utils/util.dart';
import 'package:meus_livros/widgets/back_button.dart';
import 'package:meus_livros/widgets/error.dart';
import 'package:meus_livros/widgets/item_book.dart';
import 'package:meus_livros/widgets/my_title.dart';
import 'package:nice_button/nice_button.dart';

class NextToBuyList extends StatefulWidget {
  NextToBuyList({this.map});

  final Map map;

  @override
  _NextToBuyListState createState() => _NextToBuyListState();
}

class _NextToBuyListState extends State<NextToBuyList> {
  final BookBloc _bloc = BookBloc();

  StreamSubscription<Event> subscription;

  @override
  void initState() {
    super.initState();
    _bloc.fetch(isBuy: true);
    //listen
    final bus = EventBus.get(context);
    subscription = bus.stream.listen((Event e) {
      print("Event $e");
      BookEvent bookEvent = e;
      if (bookEvent.action == "event_create_buy") _bloc.fetch(isBuy: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -MediaQuery.of(context).size.height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: BezierContainer(),
          ),
          _header(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 90,
              ),
              MyBackButton(),
              IconButton(
                  padding: EdgeInsets.all(2),
                  icon: Icon(Icons.add_circle),
                  color: Colors.white,
                  tooltip: 'Adicionar livro',
                  onPressed: () {
                    push(context, CreateBook("Comprar"));
                  }),
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 120),
            child: StreamBuilder(
              stream: _bloc.stream,
              builder: (context, snapshot) {
                return _container(snapshot);
              },
            ),
          ),
        ],
      ),
    );
    ;
  }

  _header() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyTitle(),
          Text(
            "Prox. a comprar ",
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

  _container(snapshot) {
    if (snapshot.data.toString().length == 2)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Error("Qual quer comprar?",
                title: "Ouvi novo livro? ", isEmpty: true),
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
    return _bloc.fetch(isBuy: true);
  }

  _createFirstBook() {
    return NiceButton(
      width: 410,
      elevation: 8,
      radius: 10,
      gradientColors: [Color(0xfffbb448), Color(0xfff7892b)],
      text: "Cadastrar",
      onPressed: () {
        push(context, CreateBook("Comprar"));
      },
    );
  }
}
