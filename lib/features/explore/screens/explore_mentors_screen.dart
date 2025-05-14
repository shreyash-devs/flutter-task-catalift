import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/common/custom_app_bar.dart';
import '../../../widgets/common/search_bar_widget.dart';

class ExploreMentorsScreen extends StatefulWidget {
  const ExploreMentorsScreen({Key? key}) : super(key: key);

  @override
  State<ExploreMentorsScreen> createState() => _ExploreMentorsScreenState();
}

class _ExploreMentorsScreenState extends State<ExploreMentorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Explore Mentors'),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: (value) {
              // Handle search
            },
            onAddTap: () {
              // Handle add tap
            },
          ),

          // Content
          Expanded(
            child: Center(
              child: Text(
                'Explore Mentors Screen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
