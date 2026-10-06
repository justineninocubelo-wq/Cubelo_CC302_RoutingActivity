import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'sample_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen ({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// index 0 = Sample, 1 = Home, 2 = Profile
class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 1;

  final List<Widget> _pages = [
    const SamplePage(),
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 1 ? 'Home' : _currentIndex == 2 ? 'Profile' : 'Sample',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
        elevation: 2, 
        surfaceTintColor: Colors.transparent,
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },

        child: _pages[_currentIndex],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        height: 65,

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article),
            selectedIcon: Icon(Icons.article_outlined),
            label: 'Sample',
          ),

          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(Icons.home_outlined),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}