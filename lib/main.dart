import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_bloc/blocs/blocs.dart';
import 'package:insta_bloc/blocs/simple_bloc_observer.dart';
import 'package:insta_bloc/config/custom_router.dart';
import 'package:insta_bloc/repositories/auth/auth_repository.dart';
import 'package:insta_bloc/repositories/repositories.dart';
import 'package:insta_bloc/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (_) => StorageRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>()))
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Insta',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[50],
              appBarTheme: AppBarTheme(
                  brightness: Brightness.light,
                  color: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                  textTheme: TextTheme(
                      headline6: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600))),
              visualDensity: VisualDensity.adaptivePlatformDensity),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
