import 'package:firebase_auth/firebase_auth.dart';
import 'package:meus_livros/db/book_dao.dart';
import 'package:meus_livros/utils/event_bus.dart';
import 'package:meus_livros/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<EventBus>(
            builder: (context) => EventBus(),
            dispose: (context, bus) => bus.dispose(),
          )
        ],
        child: MaterialApp(
          title: 'Meus Livros',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Welcome(),
        ));
  }
}
