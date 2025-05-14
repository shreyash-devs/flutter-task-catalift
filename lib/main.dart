import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/home_screen.dart';
import 'features/explore/screens/explore_mentors_screen.dart';
import 'features/courses/screens/courses_screen.dart';
import 'widgets/common/bottom_nav_bar.dart';
import 'features/splash/screens/splash_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  // Keep splash screen until app is fully loaded
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());

  // Remove splash screen once app is ready
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CataLift',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class AppContainer extends StatefulWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _currentIndex = 0;

  // List of screens corresponding to each tab index
  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreMentorsScreen(),
    const CoursesScreen(),
  ];

  void _handleNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _handleNavBarTap,
      ),
    );
  }
}
