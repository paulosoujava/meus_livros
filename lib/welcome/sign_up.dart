import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:meus_livros/api/api_response.dart';
import 'package:meus_livros/api/firebase_service.dart';
import 'package:meus_livros/pages/home_book.dart';
import 'package:meus_livros/utils/bezierContainer.dart';
import 'package:meus_livros/utils/prefs.dart';
import 'package:meus_livros/utils/util.dart';
import 'package:meus_livros/widgets/back_button.dart';
import 'package:meus_livros/widgets/input.dart';
import 'package:meus_livros/widgets/my_title.dart';
import 'package:nice_button/nice_button.dart';

class SignUp extends StatefulWidget {
  SignUp({this.title});

  final String title;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _tSenha = TextEditingController();
  var _tLembrar = TextEditingController();
  var _tLogin = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  var _focusPass = FocusNode();
  var _focusRepPass = FocusNode();

  bool isShow = false;


  Widget _submitButton() {
    return Stack(
      children: <Widget>[
        NiceButton(
          width: 410,
          elevation: 8,
          radius: 10,
          gradientColors: [Color(0xfffbb448), Color(0xfff7892b)],
          text: isShow ? "" : "Login",
          onPressed: () {
            if (_formKey.currentState.validate()) {
              setState(() {
                isShow = true;
              });
              _doLogin();
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
                  Container(
                    padding: EdgeInsets.all(6),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Cadastro",
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
                                nextFocus: _focusPass, ),
                            SizedBox(
                              height: 10,
                            ),
                            MyInputText("Rep. a senha", "repita a senha",
                                _tSenha, validateSenha, TextInputType.number,
                                isPass: true,
                                textInputAction: TextInputAction.next,
                                focusNode: _focusPass,
                                nextFocus: _focusRepPass),
                            SizedBox(
                              height: 10,
                            ),
                            MyInputText(
                              "Rep. a senha",
                              "repita a senha",
                              _tLembrar,
                              validateRepSenha,
                              TextInputType.number,
                              isPass: true,
                              focusNode: _focusRepPass,
                              textInputAction: TextInputAction.done,
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

  String validateSenha(String str) {
    if (str.isEmpty)
      return "ai ai ai cade a senha";
    else if (str.length < 6)
      return "senha menor que 6 caracteres";
    else {
      return null;
    }
  }

  String validateRepSenha(String str) {
    print("$str ${_tLembrar.text}");
    if (_tSenha.text != _tLembrar.text)
      return "senhas não conferem";
    else {
      return null;
    }
  }

  void _doLogin() async {
    final service = FirebaseService();
    ApiResponse response = await service.doCreateUser(_tLogin.text, _tSenha.text);
    if (response.ok) {
      Prefs.getBool("LOGIN");
      alert(context, "Seu cadastro foi efetuado com sucesso, vamos redirecionar você", redirect: true);
    } else {
      setState(() {
        isShow = false;
      });
      alert(context, response.msg);
    }
  }

  alert(BuildContext context, String msg, {bool redirect = false}) {
    if( msg.contains("ERROR_USER_NOT_FOUN"))
      msg = "Usuário não encontrado, por favor cadastre-se";
    if( msg.contains("ERROR_EMAIL_ALREADY"))
      msg = "Eita, você já está cadastrado faça o seu login.";

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
                  if( redirect )
                    push(context, HomeBook(), replace: true);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
