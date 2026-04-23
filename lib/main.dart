import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaction.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Expense Tracker',
      theme: ThemeData(
        // Warna Pastel
        primaryColor: const Color(0xFFA7C7E7), // Pastel Blue
        scaffoldBackgroundColor: const Color(0xFFFDFCF0), // Off-white pastel
        
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFA7C7E7),
          foregroundColor: Colors.blueGrey[800],
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.blueGrey[800],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA7C7E7),
          primary: const Color(0xFFA7C7E7),
          secondary: const Color(0xFFC3B1E1), // Pastel Purple
        ),
      ),
      home: const MainNavigation(),
    );
  }
}