import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home/home_cubit.dart';
import '../../bloc/profile/profile_cubit.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import 'home_tab_screen.dart';
import 'add_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  void changeTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<HomeCubit>(create: (_) => HomeCubit()..fetchClasses()),
      BlocProvider<ProfileCubit>(
        create: (_) => ProfileCubit()..fetchMyProfile(),
      ),
    ],
    child: Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeTabScreen(),
          AddScreen(),
          ChatScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        index: _currentIndex,
        onChanged: changeTab,
      ),
    ),
  );
}
