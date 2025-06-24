// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:invo/pages/add_new_batch_page.dart';
import 'package:invo/pages/buyers_page.dart';
import 'package:invo/pages/due_page.dart';
import 'package:invo/pages/home_page.dart';
import 'package:invo/pages/reports_page.dart';
import 'package:invo/pages/sell_piece_page.dart';

final GlobalKey<_MainPageState> mainPageKey = GlobalKey<_MainPageState>();

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: mainPageKey);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    AddNewBatchPage(),
    SellPiecePage(),
    BuyersPage(),
    DuePage(),
    ReportsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF101124),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                filledIcon: Icons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.add_circle_outline,
                filledIcon: Icons.add_circle,
                label: 'Add',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.shopping_cart_outlined,
                filledIcon: Icons.shopping_cart,
                label: 'Sell',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.people_outline,
                filledIcon: Icons.people,
                label: 'Buyers',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.credit_card_outlined,
                filledIcon: Icons.credit_card,
                label: 'Credit',
                index: 4,
              ),
              _buildNavItem(
                icon: Icons.assessment_outlined,
                filledIcon: Icons.assessment,
                label: 'Reports',
                index: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData filledIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        width: MediaQuery.of(context).size.width / 7,
        decoration: BoxDecoration(
          // color:
          //     isSelected ? Colors.purple.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border:
              isSelected
                  ? Border.all(color: Color(0xFFB39CD0), width: 2)
                  : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : icon,
              color: isSelected ? Color(0xFFB67CFF) : Colors.grey[600],
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Color(0xFFB39CD0) : Colors.grey[600],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
