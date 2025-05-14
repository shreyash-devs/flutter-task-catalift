import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import 'logo_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfileIcon;
  final bool showNotificationIcon;
  final bool showMessageIcon;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMessageTap;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    this.title = 'CATALIFT',
    this.showProfileIcon = true,
    this.showNotificationIcon = true,
    this.showMessageIcon = true,
    this.onProfileTap,
    this.onNotificationTap,
    this.onMessageTap,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      titleSpacing: 0,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: LogoWidget(fontSize: 22.0, color: Colors.white),
        ),
      ),
      actions: [
        if (showProfileIcon)
          IconButton(
            icon: const Icon(LucideIcons.user, color: Colors.white, size: 23),
            splashRadius: 26,
            onPressed: onProfileTap,
          ),
        if (showNotificationIcon)
          IconButton(
            icon: const Icon(LucideIcons.bell, color: Colors.white, size: 23),
            splashRadius: 26,
            onPressed: onNotificationTap,
          ),
        if (showMessageIcon)
          IconButton(
            icon: const Icon(
              LucideIcons.messageCircle,
              color: Colors.white,
              size: 23,
            ),
            splashRadius: 26,
            onPressed: onMessageTap,
          ),
        if (actions != null) ...actions!,
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.white.withOpacity(0.1)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
