import 'package:bazi_app_frontend/firebase_options.dart';
import 'package:bazi_app_frontend/screens/auth_handler_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'configs/theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  await GoogleSignIn.instance.initialize(
    serverClientId: dotenv.env['FIREBASE_WEB_CLIENT_ID']
  );
  initializeDateFormatting('th_TH').then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: appTheme, home: const AuthHandlerScreen());
  }
}
