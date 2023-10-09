import 'package:collab/custom_widget/my_button.dart';
import 'package:collab/private_component/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'private_component/dash.dart';
import 'login.dart';
import 'services/auth.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Auth(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: Navigation(),
      ),
    );
  }
}

// class Navigation extends StatelessWidget {
//   const Navigation({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<Auth>(context);
//     print(auth.isAuth);
//     if (auth.isAuth) {
//       return const MyHomePage();
//     } else {
//       return const LoginPage();
//     }
//   }
// }

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    if (auth.isAuth) {
      return const DashboardPage();
    } else {
      return const LoginPage();
    }
  }
}
