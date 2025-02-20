import 'package:_3gx_application/main_screens/item_page.dart';
import 'package:flutter/material.dart';
import 'package:_3gx_application/main_screens/Item_screen.dart';
import 'package:_3gx_application/profile.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ItemlistPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 80,
            color: Colors.red.shade800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                _buildSidebarButton(Icons.person, "Profile", 1),
                _buildSidebarButton(Icons.inventory, "Inventory", 0),
              ],
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarButton(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        children: [
          SizedBox(height: 10),
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(height: 4),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: isSelected ? 30 : 0,
            height: 3,
            color: isSelected ? Colors.white : Colors.transparent,
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
