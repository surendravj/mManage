// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mmanage/backend/chitti_service.dart';
import 'package:mmanage/backend/planning_service.dart';
import 'package:mmanage/constants/colors.dart';
import 'package:mmanage/constants/styles.dart';
import 'package:mmanage/modules/Chitti/chitti_screen.dart';
import 'package:mmanage/modules/Expenses/expenses_screen.dart';
import 'package:mmanage/modules/Planning/planning_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ChittiService(),
        ),
        ChangeNotifierProvider.value(
          value: PlanningService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mManage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  static const List<Widget> screens = [
    ExpensesScreen(),
    PlanningScreen(),
    ChittiScreen(),
  ];

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.account_circle,
              size: 30,
            ),
          )
        ],
        elevation: 0,
        title: Text(
          "Hi, Vadaparthy",
          style: Styles.textDecoration(),
        ),
        backgroundColor: AppTheme.filler,
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.filler,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.attach_money_outlined,
            ),
            label: "Expenses",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.manage_accounts_outlined,
            ),
            label: "Planning",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.savings,
            ),
            label: "Chitti",
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: AppTheme.secondaryText,
        unselectedItemColor: AppTheme.primaryText,
        selectedIconTheme: IconThemeData(color: AppTheme.secondaryText),
        selectedLabelStyle: Styles.textDecoration(fontSize: 12),
        unselectedLabelStyle: Styles.textDecoration(fontSize: 12),
        onTap: onTap,
      ),
    );
  }
}
