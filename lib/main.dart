import 'package:expense/provider/theme_provider.dart';
import 'package:expense/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'db/app_db.dart';
import 'exp_bloc/expense_bloc.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: BlocProvider<ExpenseBloc>(
        create: (context) => ExpenseBloc(db: AppDataBase.instance),
        child: const MyApp(),
      )
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    context.read<ThemeProvider>().updateThemeOnStart();

    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: context.watch<ThemeProvider>().themeValue ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}