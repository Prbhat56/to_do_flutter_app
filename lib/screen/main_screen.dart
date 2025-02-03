import 'package:flutter/material.dart';

import 'package:to_do_flutter_app/screen/profile_screen.dart';
import 'package:to_do_flutter_app/screen/to_do_edit_screen.dart';
import 'package:to_do_flutter_app/screen/to_do_list_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to the Home screen

  // List of screens for the Bottom Navigation Bar
  final List<Widget> _screens = [
    const TodoListScreen(),  // Home - Todo List Screen
    const CreateEditTodoScreen(),   // Add Todo Screen
    const ProfileScreen(),   // Profile Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
      ),
      body: _screens[_selectedIndex], // Displays the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,  // Current index of selected screen
        onTap: _onItemTapped,  // Handle tab selection
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
