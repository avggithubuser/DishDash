import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTags extends StatefulWidget {
  final String filterType;
  final List<String> tags;
  final Function(Set<String>) onSelectionChanged;

  MyTags({
    super.key,
    required this.filterType,
    required this.onSelectionChanged,
    required this.tags,
  });

  @override
  State<MyTags> createState() => _MyTagsState();
}

class _MyTagsState extends State<MyTags> {
  Map<String, Set<String>> selectedFilters = {};
  //
  final List<Color> _tagColors = [
    Colors.blueAccent,
    Colors.amberAccent,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.cyanAccent,
  ];

  Widget _tagChip(String label, Color color, ColorScheme colorScheme) {
    selectedFilters[widget.filterType] ??= Set<String>();

    bool isSelected =
        selectedFilters[widget.filterType]?.contains(label) ??
        false; // Check if the label is selected

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      selected: isSelected,
      backgroundColor: colorScheme.primary.withOpacity(0.5),
      selectedColor: colorScheme.primary.withOpacity(0.55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: color.withOpacity(0.4)),
      ),
      onSelected: (isSelected) {
        setState(() {
          // Update the selected tags based on their selection state
          if (isSelected) {
            selectedFilters[widget.filterType]?.add(label);
          } else {
            selectedFilters[widget.filterType]?.remove(label);
          }
        });
        // Notify SearchScreen about the updated selection
        widget.onSelectionChanged(selectedFilters[widget.filterType]!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     colorScheme.primary.withOpacity(0.2),
        //     colorScheme.secondary.withOpacity(0.2),
        //   ],
        // ),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: AutoSizeText(
              "${widget.filterType} category",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: List.generate(
              widget.tags.length,
              (index) => _tagChip(
                widget.tags[index],
                _tagColors[index % _tagColors.length],
                colorScheme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
