import 'dart:ui';

import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:path/path.dart';
// Ce fichier est déplacé dans presentation/pages/home_page.dart selon la Clean Architecture.
class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final results = PlatformDispatcher.instance.locale.languageCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(results);
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(

    );
  }
}