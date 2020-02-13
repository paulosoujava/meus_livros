import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:meus_livros/bloc/book_bloc.dart';
import 'package:meus_livros/db/book_dao.dart';
import 'package:meus_livros/entity/Book.dart';
import 'package:meus_livros/utils/bezierContainer.dart';
import 'package:meus_livros/utils/event_bus.dart';
import 'package:meus_livros/utils/util.dart';
import 'package:meus_livros/widgets/back_button.dart';
import 'package:meus_livros/widgets/input.dart';
import 'package:meus_livros/widgets/my_title.dart';
import 'package:nice_button/nice_button.dart';

class CreateBook extends StatefulWidget {

  Book book;
  String action;

  CreateBook(this.action, {this.book});

  @override
  _CreateBookState createState() => _CreateBookState();
}

class _CreateBookState extends State<CreateBook> {
  var _tTitulo = TextEditingController();
  var _tCategory = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool isShow = false;
  File _image;
  String titleBtn;
  final BookBloc _bloc = BookBloc();

  @override
  void initState() {
    super.initState();
    titleBtn = widget.action;
    isEdit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _header(),
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
                margin: EdgeInsets.only(top: 70, left: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          child: _setImage(),
                          padding: EdgeInsets.all(10),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.only(right: 16, left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Divider(
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Novo livro:",
                              style: GoogleFonts.portLligatSans(
                                textStyle: Theme.of(context).textTheme.display1,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyInputText(
                              "Título",
                              "digite o título do livro",
                              _tTitulo,
                              validateTitle,
                              TextInputType.text,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyInputText(
                              "Categoria",
                              "qual o a categoria deste livro",
                              _tCategory,
                              validateTitle,
                              TextInputType.text,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _submitButton(),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MyBackButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  String validateTitle(String str) {
    if (str.isEmpty) {
      return "ops digite um titulo.";
    } else {
      return null;
    }
  }

  String validateCategory(String str) {
    if (str.isEmpty)
      return "qual a categoria deste livro";
    else {
      return null;
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  _setImage() {
    return InkWell(
      onTap: () {
        getImage();
      },
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: _image == null
                ? Image.asset(
                    "assets/images/photo.png",
                    width: 120,
                    height: 120,
                  )
                : Image.file(
                    _image,
                    width: 120,
                    height: 120,
                  ),
          ),
          Text(" ${widget.book == null ? "adicionar" : "atualizar "} image ")
        ],
      ),
    );
  }

  _header() {
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyTitle(),
        ],
      ),
    );
  }

  _loading(bool isShow) {
    setState(() {
      isShow = isShow;
    });
  }

   _submitButton() {
    return Stack(
      children: <Widget>[
        NiceButton(
          width: 410,
          elevation: 8,
          radius: 10,
          gradientColors: [Color(0xfffbb448), Color(0xfff7892b)],
          text: isShow ? "" : titleBtn,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              if(_image == null) {
                opsAlert(context, "Por favor cadastre a foto");
                return;
              }
            _actions();
            } else {
              return null;
            }
          },
        ),
        isShow
            ? Center(
                child: LoadingBouncingLine.square(
                  borderColor: Colors.cyan,
                  size: 50.0,
                ),
              )
            : Container()
      ],
    );
  }

  void isEdit() {
    if (widget.book != null) {
      titleBtn = "Atualizar";
      _tTitulo.text = widget.book.title;
      _tCategory.text = widget.book.category;
      _image = File(widget.book.url);
    }
  }

   _actions() async {
     _loading(true);
     bool isOk;

     switch(titleBtn){
       case "Cadastrar":
         isOk = await _bloc.saveBook(Book(
             title: _tTitulo.text,
             category: _tCategory.text,
             isLeading: "false",
             reading: "false",
             isBuy: "false",
             url: _image.path));
         _image = null;
         _tCategory.clear();
         _tTitulo.clear();
         break;
       case"Atualizar":
         widget.book.title = _tTitulo.text;
         widget.book.category = _tCategory.text;
         isOk = await _bloc.saveBook(widget.book);
          break;
       case "Comprar":
         isOk = await _bloc.saveBook(Book(
             title: _tTitulo.text,
             category: _tCategory.text,
             isLeading: "false",
             reading: "false",
             isBuy: "true",
             url: _image.path));
         _image = null;
         _tCategory.clear();
         _tTitulo.clear();
         EventBus.get(context)
             .sendEvent(BookEvent("event_create_buy"));
         break;

       default:
         isOk = false;

     }

     if (isOk) {
       opsAlert(context, "Ação realizada com sucesso", ops: "Opaa");
       EventBus.get(context).sendEvent(BookEvent("event_create"));
     } else
       opsAlert(context, "Erro ao cadastrar", ops: "Opss");


  }
}
