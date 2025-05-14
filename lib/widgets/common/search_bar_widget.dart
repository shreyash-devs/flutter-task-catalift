import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

// Custom painter for the add icon
class AddIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  AddIconPainter({required this.color, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Simple horizontal line
    canvas.drawLine(
      Offset(size.width * 0.25, centerY),
      Offset(size.width * 0.75, centerY),
      paint,
    );

    // Simple vertical line
    canvas.drawLine(
      Offset(centerX, size.height * 0.25),
      Offset(centerX, size.height * 0.75),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SearchBarWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onAddTap;
  final String hintText;
  final bool autofocus;

  const SearchBarWidget({
    Key? key,
    this.controller,
    this.onChanged,
    this.onAddTap,
    this.hintText = 'Search posts, people, and topics...',
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_onFocusChange);

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = 48.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(height / 2),
                border: Border.all(
                  color:
                      _hasFocus
                          ? AppColors.primaryColor.withOpacity(0.3)
                          : Colors.grey[300]!,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color:
                        _hasFocus ? AppColors.primaryColor : Colors.grey[400],
                    size: 20,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 50,
                    minHeight: 50,
                  ),
                  suffixIcon:
                      _controller.text.isNotEmpty
                          ? IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 16,
                            icon: const Icon(Icons.clear),
                            color: Colors.grey[500],
                            onPressed: () {
                              _controller.clear();
                              if (widget.onChanged != null) {
                                widget.onChanged!('');
                              }
                            },
                          )
                          : null,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),

          // Add Button
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              height: height,
              width: height,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(height / 2),
                child: InkWell(
                  borderRadius: BorderRadius.circular(height / 2),
                  onTap: widget.onAddTap,
                  child: Center(
                    child: Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
