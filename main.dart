import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import '../helper/themes.dart';
import '../screens/splash_screen.dart';
import '../providers/text_type_provider.dart';

SharedPreferences? sharedPrefs;
Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();
  print("\n\nFirebase initialiazed................");

  sharedPrefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

late Size mq;

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => TextTypeProvider(selectedTextType: 'Sen')),
      ],
      child: Consumer<TextTypeProvider>(
        builder: (_, value, __) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Chat App',
              theme: ThemeData(
                fontFamily: value.getselectedTextType,
                primarySwatch: Colors.deepOrange,
                appBarTheme: AppBarTheme(
                    elevation: 1,
                    iconTheme: IconThemeData(color: Colors.black),
                    titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      fontFamily: value.getselectedTextType,
                    ),
                    backgroundColor: Colors.white),
                textTheme: Themes.myTextTheme,
              ),
              home: SplashScreen());
        },
      ),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var notificationChannel = FlutterNotificationChannel();

  var result = await notificationChannel.registerNotificationChannel(
    description: 'For showing message notifications',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  print("========> Notification channel result : $result");
}

class TextThemeClass {
  static String? textType = sharedPrefs!.getString('textType') ?? null;
}
