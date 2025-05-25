import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invo/blocs/auth/auth_bloc.dart';
import 'package:invo/firebase_options.dart';
import 'package:invo/pages/main_page.dart';
import 'package:invo/pages/signin_page.dart';
import 'package:invo/repositories/auth_repository.dart';
import 'package:invo/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => AuthBloc(AuthRepository())),
        ],
        child: MaterialApp(
          title: 'Invo',
          theme: AppTheme.darkTheme,
          home: MainPage()
        ),
      ),
    );
  }
}

