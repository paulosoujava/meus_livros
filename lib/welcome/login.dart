import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:meus_livros/api/api_response.dart';
import 'package:meus_livros/api/firebase_service.dart';
import 'package:meus_livros/pages/home_book.dart';
import 'package:meus_livros/utils/bezierContainer.dart';
import 'package:meus_livros/utils/util.dart';
import 'package:meus_livros/widgets/back_button.dart';
import 'package:meus_livros/widgets/input.dart';
import 'package:meus_livros/widgets/my_title.dart';
import 'package:nice_button/nice_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _tSenha = TextEditingController();
  var _tLogin = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _focusPass = FocusNode();
  var _tForgetLogin = TextEditingController();
  var _formKeyForgetPass = GlobalKey<FormState>();
  bool isShowLogin = false;
  bool isShowForget = false;



  Widget _submitButton() {
    return isShowLogin
        ? Center(
            child: LoadingBouncingLine.square(
              borderColor: Color(0xfffbb448),
              backgroundColor: Colors.white,
              size: 50.0,
            ),
          )
        : NiceButton(
            width: 410,
            elevation: 8,
            radius: 10,
            gradientColors: [Color(0xfffbb448), Color(0xfff7892b)],
            text: "Login",
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                ApiResponse response = await FirebaseService().doLogin(_tLogin.text, _tSenha.text);
                if( response.ok ){
                  push(context, HomeBook(), replace: true);
                }else{
                  alert(context,response.msg);
                }


              } else {
                return null;
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: MyTitle(),
            ),
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 130,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Login",
                              style: GoogleFonts.portLligatSans(
                                textStyle: Theme.of(context).textTheme.display1,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            MyInputText("Login", "digite o login", _tLogin,
                                validateLogin, TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                nextFocus: _focusPass),
                            SizedBox(
                              height: 10,
                            ),
                            MyInputText("Senha", "digite a senha", _tSenha,
                                validatePass, TextInputType.number,
                                isPass: true,
                                textInputAction: TextInputAction.done,
                                focusNode: _focusPass),
                            SizedBox(
                              height: 20,
                            ),
                            _submitButton(),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.centerRight,
                                      child: Stack(
                                        children: <Widget>[
                                          isShowForget
                                              ? Center(
                                                  child: LoadingBouncingLine
                                                      .square(
                                                    borderColor: Color(0xfffbb448),
                                                    backgroundColor: Colors.white,
                                                    size: 50.0,
                                                  ),
                                                )
                                              : Text('esqueceu a senha?',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black)),
                                        ],
                                      )),
                                  onTap: () {
                                    setState(() {
                                      isShowForget = true;
                                    });
                                    _inputDialog(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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

  String validateLogin(String str) {
    if (str.isEmpty) {
      return "ops cade o login?";
    } else if (!str.contains("@") || !(str.contains(".com"))) {
      return "login inválido";
    } else {
      return null;
    }
  }

  String validatePass(String str) {
    if (str.isEmpty)
      return "ai ai ai cade a senha";
    else if (str.length < 6)
      return "senha inválida.";
    else {
      return null;
    }
  }

  Future<String> _inputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Esqueceu a senha?'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: Form(
                child: MyInputText(
                  "Emal",
                  "digite o seu email",
                  _tForgetLogin,
                  validateForgetpass,
                  TextInputType.emailAddress,
                ),
                key: _formKeyForgetPass,
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
                setState(() {
                  isShowForget = false;
                });
              },
            ),
            FlatButton(
              child: Text('enviar'),
              onPressed: () async {
                if (_formKeyForgetPass.currentState.validate()) {
                  pop(context);
                  ApiResponse response =
                      await FirebaseService().doResetLogin(_tForgetLogin.text);
                  _alert(response.msg);
                } else {
                  return null;
                }
              },
            ),
          ],
        );
      },
    );
  }

  String validateForgetpass(String value) {
    if (value.isEmpty || !value.contains("@")) return "Ops, email inválido.";
    return null;
  }

  alert(BuildContext context, String msg) {

    if( msg.contains("ERROR_USER_NOT_FOUN"))
      msg = "Usuário não encontrado, por favor cadastre-se";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Ops"),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _alert(String msg) {
    alert(context, msg);
    setState(() {
      isShowForget = false;
    });
  }
}
