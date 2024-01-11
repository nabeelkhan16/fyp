import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/blocs/bin/bins_bloc.dart';
import 'package:trash_collector/configs/routes.dart';
import 'package:trash_collector/models/bin_model.dart';
import 'package:trash_collector/screens/colllectors/bloc/collector_bloc.dart';
import 'package:trash_collector/screens/home_screen_navigator.dart';
import 'package:trash_collector/screens/login_screen.dart';
import 'package:trash_collector/screens/user_information_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

//request permission to use firebase messaging
    messaging
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        )
        .then((value) => log(value.toString()));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('A new onMessage event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'ic_launcher',

                
              ),
            ));
      }

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('A new onMessageOpenedApp event was published!');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name, channelDescription: channel.description, icon: 'ic_launcher'),
              ));
        }
      });
    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc()..add(AuthenticationCheck())),
        BlocProvider(create: (_) => CollectorBloc()),
        BlocProvider(create: (_) => BinsBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.blue.shade900,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade900,
          ),
          useMaterial3: true,
        ),
        onGenerateRoute: Routes().generateRoute,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is InCompleteUserProfiling) {
              return const UserInformationForm();
            } else if (state is AuthenticationAuthenticated) {
              return const HomeScreenNavigator();
            } else if (state is AuthenticationUnauthenticated) {
              return const LoginScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) {
    log('A new onMessageOpenedApp event was published!');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, channelDescription: channel.description, icon: 'ic_launcher'),
          ));
    }

    return Future<void>.value();
  }
}
