import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vikn/views/filterpage.dart';
import 'package:vikn/views/home.dart';
import 'package:vikn/views/profile.dart';
import 'package:vikn/views/saleslist.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Home(),
    SaleListPage(),
    FilterPage(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIconWithDot('assets/icons/home.svg', _selectedIndex == 0),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithDot('assets/icons/route-square.svg', _selectedIndex == 1),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithDot('assets/icons/notification-bing.svg', _selectedIndex == 2),
            label: '', // Empty label
          ),
          BottomNavigationBarItem(
            icon: _buildIconWithDot('assets/icons/profile.svg', _selectedIndex == 3),
            label: '', // Empty label
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white10,
        selectedFontSize: 0,  // Prevents any text size changes
        unselectedFontSize: 0, // Prevents any text size changes
        iconSize: 24,          // Keeps icon size consistent
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 24), // Consistent icon size when selected
        unselectedIconTheme: const IconThemeData(color: Colors.white10, size: 24), // Consistent icon size when not selected
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildIconWithDot(String iconPath, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconPath,
          color: isSelected ? Colors.white : Colors.white10,
          width: 24, // Make sure the icon width is consistent
          height: 24, // Make sure the icon height is consistent
        ),
        if (isSelected)
          SizedBox(height: 4), // Add space between icon and dot
        if (isSelected)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
