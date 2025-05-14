import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            0,
            Icons.home_filled,
            Icons.home_outlined,
            'Home',
          ),
          _buildNavItem(
            context,
            1,
            Icons.people,
            Icons.people_outline,
            'Mentors',
          ),
          _buildNavItem(
            context,
            2,
            Icons.menu_book,
            Icons.menu_book_outlined,
            'Courses',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData selectedIcon,
    IconData unselectedIcon,
    String label,
  ) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:
              isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                  isSelected ? selectedIcon : unselectedIcon,
                  color:
                      isSelected
                          ? AppColors.primaryColor
                          : AppColors.textSecondary,
                  size: 24,
                )
                .animate(target: isSelected ? 1 : 0)
                .scale(
                  duration: 300.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color:
                    isSelected
                        ? AppColors.primaryColor
                        : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
