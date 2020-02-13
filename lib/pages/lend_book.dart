import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:meus_livros/db/book_dao.dart';
import 'package:meus_livros/db/user_dao.dart';
import 'package:meus_livros/entity/Book.dart';
import 'package:meus_livros/entity/User.dart';
import 'package:meus_livros/utils/bezierContainer.dart';
import 'package:meus_livros/utils/util.dart';
import 'package:meus_livros/widgets/back_button.dart';
import 'package:meus_livros/widgets/input.dart';
import 'package:meus_livros/widgets/my_title.dart';
import 'package:nice_button/nice_button.dart';

class LendBook extends StatefulWidget {
  Book book;

  LendBook(this.book);

  @override
  _LendBookState createState() => _LendBookState();
}

class _LendBookState extends State<LendBook> {
  var _tname = TextEditingController();
  var _tEmail = TextEditingController();
  var _tPhone = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool isShow = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _header(),
          Positioned(
            top: -MediaQuery.of(context).size.height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: BezierContainer(),
          ),
          Container(
            margin: EdgeInsets.only(top: _keyboardIsVisible()? 110: 10, left: 10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 110,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        child: _image(widget.book.url),
                        padding: EdgeInsets.all(10),
                      ),
                      SizedBox(
                        width: 170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.book.title,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Text(
                              widget.book.category,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Emprestar para:",
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyInputText(
                            "Nome",
                            "digite o nome",
                            _tname,
                            validateName,
                            TextInputType.text,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyInputText(
                            "Email",
                            "qual o email",
                            _tEmail,
                            validateEmail,
                            TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MyInputText(
                            "Tel.",
                            "qual o num. de telefone",
                            _tPhone,
                            validatePhone,
                            TextInputType.phone,
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
              SizedBox(height: 80,),
              MyBackButton(),
            ],
          )
        ],
      ),
    );
  }

  String validateName(String str) {
    if (str.isEmpty) {
      return "ops digite o nome";
    } else {
      return null;
    }
  }

  String validateEmail(String str) {
    if (str.isEmpty)
      return "digite um email";
    else {
      return null;
    }
  }

  String validatePhone(String str) {
    if (str.isEmpty)
      return "digite um telefone";
    else {
      return null;
    }
  }

  _image(image) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(image)),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(5.0, 5.0),
                  blurRadius: 10.0)
            ]),
      ),
      height: 180,
      width: 120,
    );
  }

  _header() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MyTitle(),
          Text(
            "Emprestar este livro",
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

  _submitButton() {
    return Stack(
      children: <Widget>[
        NiceButton(
          width: 410,
          elevation: 8,
          radius: 10,
          gradientColors: [Color(0xfffbb448), Color(0xfff7892b)],
          text: "Emprestar",
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              if (_image == null) {
                opsAlert(context, "Por favor cadastre a foto");
                return;
              }
              if (await UserDAO().save(User(
                  name: _tname.text,
                  email: _tEmail.text,
                  phone: _tPhone.text,
                  dateLend: _today(),
                  dateBackBook: "",
                  idBook: widget.book.id.toString())) >
                  0) {
                opsAlert(context, "Emprestado com sucesso", ops: "Opaa");
                widget.book.isLeading = "true";
                BookDAO().save(widget.book);
              }
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

  _today() {
    var now = DateTime.now();
    return ("${now.day} / ${now.month} / ${now.year} ${now.hour} : ${now.minute}");
  }


  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
}
