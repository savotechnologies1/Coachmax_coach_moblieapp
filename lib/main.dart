import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'bloc/cubit/auth_cubit.dart';
import 'core/theme/app_theme.dart';
import 'repository/auth_repository.dart';
import 'ui/auth/SplashScreen.dart';
import 'utils/constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    BlocProvider(
      create: (_) => AuthCubit(AuthRepository()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: navigatorKey,
    title: Constants.appName,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    builder: (context, child) =>
        GlobalLoaderOverlay(overlayColor: Colors.black26, child: child!),
    home: SplashScreen(),
  );
}
