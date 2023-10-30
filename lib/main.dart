import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';
import 'package:trash_collector/configs/routes.dart';
import 'package:trash_collector/screens/home_screen_navigator.dart';
import 'package:trash_collector/screens/login_screen.dart';
import 'package:trash_collector/screens/user_information_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc()..add(AuthenticationCheck())),
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
            } else if (state is AuthenticationLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
