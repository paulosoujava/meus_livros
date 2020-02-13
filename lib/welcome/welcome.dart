import 'package:loading_animations/loading_animations.dart';
import 'package:meus_livros/api/api_response.dart';
import 'package:meus_livros/api/firebase_service.dart';
import 'package:meus_livros/db/db_helper.dart';
import 'package:meus_livros/pages/home_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meus_livros/utils/prefs.dart';
import 'package:meus_livros/utils/util.dart';
import 'package:meus_livros/welcome/login.dart';
import 'package:meus_livros/welcome/sign_up.dart';
import 'package:meus_livros/widgets/my_title.dart';
import 'package:nice_button/nice_button.dart';

class Welcome extends StatefulWidget {
  bool isGoogleLogin = false;

  @override
  _WelcomeState createState() => _WelcomeState();
}


class _WelcomeState extends State<Welcome> {
  final _auth = LocalAuthentication();


  Widget _submitButton(String name) {
    return NiceButton(
      width: 410,
      elevation: 8,
      radius: 10,
      gradientColors: [Color(0xfffbb448), Color(0xfff7892b)],
      text: name,
      onPressed: () {
        if (name == "Login") push(context, Login());
      },
    );
  }

  Widget _signUpWithGoogleButton() {
    return Stack(
      children: <Widget>[
        NiceButton(
          width: 410,
          elevation: 8,
          radius: 10,
          gradientColors: [Color(0xfffbb448), Color(0xfff7892b)],
          text: widget.isGoogleLogin ? "" : "Login com o Google",
          onPressed: () async {
            setState(() {
              widget.isGoogleLogin = true;
            });
            final service = FirebaseService();
            ApiResponse response = await service.loginGoogle();

            if (response.ok) {
              push(context, HomeBook(), replace: true);
            } else {
              opsAlert(context, response.msg);
              setState(() {
                widget.isGoogleLogin = false;
              });
            }
          },
        ),
        widget.isGoogleLogin
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

  Widget _signUpButton() {
    return NiceButton(
      width: 410,
      elevation: 8,
      radius: 10,
      background: Colors.black,
      text: "Registrar",
      onPressed: () {
        push(context, SignUp());
      },
    );
  }

  Widget _label() {
    return InkWell(
      onTap: () {
        var localAuth = LocalAuthentication();
        _touchID();
      },
      child: Container(
          margin: EdgeInsets.only(top: 40, bottom: 20),
          child: Column(
            children: <Widget>[
              Text(
                'Login rápido com  Touch ID',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              SizedBox(
                height: 20,
              ),
              Icon(Icons.fingerprint, size: 90, color: Colors.white),
              SizedBox(
                height: 20,
              ),
              Text(
                'Touch ID',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper.getInstance().db;
    _checkLogin();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfffbb448), Color(0xffe46b10)])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyTitle(
                    cor: false,
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  _submitButton("Login"),
                  SizedBox(
                    height: 20,
                  ),
                  _signUpWithGoogleButton(),
                  SizedBox(
                    height: 20,
                  ),
                  _signUpButton(),
                  SizedBox(
                    height: 20,
                  ),
                  _label()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _touchID() async {
    try {
      const androidString = const AndroidAuthMessages(
          fingerprintHint: 'Vamos registrar sua impressão digital',
          fingerprintSuccess: 'Sucesso',
          cancelButton: 'cancelar',
          goToSettingsButton: 'Configurações',
          goToSettingsDescription: 'Por favor configure seu Touch ID.',
          signInTitle: "Biometria",
          fingerprintRequiredTitle: 'Por favor reative seu Touch ID');

      bool isAuthenticated = await _auth.authenticateWithBiometrics(
        localizedReason: 'Por favor clique abaixo para acessar',
        useErrorDialogs: true,
        androidAuthStrings: androidString,
        stickyAuth: false,
      );
      if (isAuthenticated) {
        push(context, HomeBook());
      } else {
        print("NOT OK");
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  _checkLogin() async {
    if (await Prefs.getBool("LOGIN")) push(context, HomeBook(), replace: true);
  }
}
