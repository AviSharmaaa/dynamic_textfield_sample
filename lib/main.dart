import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'dynamic_texfields.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
          title: 'Dynamic TextFields Sample',
          theme: AppTheme().buildTheme(),
          debugShowCheckedModeBanner: false,
          home: DynamicTextFieldSample()),
    );
  }
}
