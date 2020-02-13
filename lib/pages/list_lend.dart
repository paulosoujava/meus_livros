//name
//contacts
//new futures [ vender, trocar, seguir leitores]
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:meus_livros/utils/event_bus.dart';
import 'package:meus_livros/widgets/error.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meus_livros/db/book_dao.dart';
import 'package:meus_livros/db/user_dao.dart';
import 'package:meus_livros/entity/Book.dart';
import 'package:meus_livros/entity/User.dart';
import 'package:meus_livros/utils/bezierContainer.dart';
import 'package:meus_livros/widgets/back_button.dart';
import 'package:meus_livros/widgets/my_title.dart';
import 'package:nice_button/nice_button.dart';
import 'package:share/share.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  List<User> users;
  bool isShow;

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
      isShow
          ? Center(
              child: LoadingRotating.square(
                borderColor: Color(0xfffbb448),
                backgroundColor: Colors.black,
                size: 50.0,
              ),
            )
          : (users == null || users.length == 0)
              ? Container(
                  margin: EdgeInsets.only(top: 210),
                  child: Center(child: Error( "Nenhum livro emprestado",title: "Opa", )),
                )
              : _buildContainer()
    ]));
  }

  Container _buildContainer() {
    return Container(
        margin: EdgeInsets.only(top: 110),
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: users == null ? 0 : users.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: Column(
                    children: <Widget>[
                      Material(
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
                                      child: users[index].book != null
                                          ? Image.file(
                                              File(users[index].book.url),
                                              width: 90,
                                            )
                                          : Image.asset(
                                              "assets/images/book.png")),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${users[index].name}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        users[index].book != null
                                            ? Text(
                                                "${users[index].book.title}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : SizedBox(),
                                        Text(
                                          "Empréstimo:\n ${users[index].dateLend}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
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
                            Divider(
                              color: Color(0xffe46b10),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                NiceButton(
                                  width: 40,
                                  mini: true,
                                  icon: Icons.archive,
                                  background: Color(0xffe46b10),
                                  onPressed: () {
                                    _deletar(context, users[index].id, users[index].book);
                                  },
                                ),
                                NiceButton(
                                  width: 40,
                                  mini: true,
                                  icon: Icons.call,
                                  background: Color(0xffe46b10),
                                  onPressed: () {
                                    launch("tel://${users[index].phone}");
                                  },
                                ),
                                NiceButton(
                                  width: 40,
                                  mini: true,
                                  icon: Icons.email,
                                  background: Color(0xffe46b10),
                                  onPressed: () {
                                    launch("mailto:${users[index].email}");
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
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
    users = await UserDAO().findAllByLend();
    for (User u in users) {
      u.book = await BookDAO().findBookId(int.parse(u.idBook));
    }
    _isProgess(false);
  }

  void _isProgess(bool isOk) {
    setState(() {
      isShow = isOk;
    });
  }

  _deletar(context, int id, Book book) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Devolvido?"),
            content: Text("Este livro foi devolvido?"),
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
                  book.isLeading = "false";
                  await BookDAO().save(book);
                  EventBus.get(context).sendEvent(BookEvent("event_create"));
                  await UserDAO().delete(id);

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
