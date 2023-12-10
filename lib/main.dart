import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
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


   final fcmToken = await FirebaseMessaging.instance.getToken();
  print('fcmToken: $fcmToken');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   late final FirebaseMessaging _messaging;
   late final int totalNotifications;
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

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
 
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }
  
}
