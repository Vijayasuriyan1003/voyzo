import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomerBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      elevation: 5,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home_page');
            break;
          case 1:
            context.go('/customer_booking_history');
            break;
          case 2:
            context.go('/customer_profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
