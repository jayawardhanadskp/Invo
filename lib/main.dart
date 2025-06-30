import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invo/blocs/auth/auth_bloc.dart';
import 'package:invo/blocs/batch/batch_bloc.dart';
import 'package:invo/blocs/buyer/buyer_bloc.dart';
import 'package:invo/blocs/due/due_bloc.dart';
import 'package:invo/blocs/purchase/purchase_bloc.dart';
import 'package:invo/firebase_options.dart';
import 'package:invo/pages/signin_page.dart';
import 'package:invo/repositories/auth_repository.dart';
import 'package:invo/repositories/batch_repository.dart';
import 'package:invo/repositories/buyer_repository.dart';
import 'package:invo/repositories/due_repository.dart';
import 'package:invo/repositories/purchases_repository.dart';
import 'package:invo/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  await Hive.openBox('settings');

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
        RepositoryProvider<BatchRepository>(create: (context) => BatchRepository()),
        RepositoryProvider<PurchasesRepository>(create: (context) => PurchasesRepository()),
        RepositoryProvider<BuyerRepository>(create: (context) => BuyerRepository()),
        RepositoryProvider<DueRepository>(create: (context) => DueRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => AuthBloc(AuthRepository())),
          BlocProvider<BatchBloc>(create: (_) => BatchBloc(BatchRepository())),
          BlocProvider<PurchaseBloc>(create: (_) => PurchaseBloc(PurchasesRepository())),
          BlocProvider<BuyerBloc>(create: (_) => BuyerBloc(BuyerRepository())),
          BlocProvider<DueBloc>(create: (_) => DueBloc(DueRepository())),
        ],
        child: MaterialApp(
          title: 'Invo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: SigninPage(),
        ),
      ),
    );
  }
}
