import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Common text style for non-selected items
TextStyle _itemStyle(bool selected) => GoogleFonts.montserrat(
  fontSize: selected ? 22 : 17,
  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
  color: selected ? Colors.black87 : Colors.grey.shade500,
);

/// 🔹 Generic number wheel picker with title
Widget buildWheelPicker({
  required String title,
  required int itemCount,
  required int selectedValue,
  required ValueChanged<int> onSelected,
}) {
  final items = List.generate(itemCount, (i) => (i + 1).toString());
  return _buildWheelContainer(
    title: title,
    child: DynamicWheel(
      items: items,
      initialIndex: selectedValue - 1,
      onSelected: (index) => onSelected(index + 1),
    ),
  );
}

/// 🔹 Hour/Minute Wheel
Widget timeWheel({
  required String title,
  required List<int> items,
  required int selectedValue,
  required ValueChanged<int> onSelected,
}) {
  final itemStrings = items.map((e) => e.toString().padLeft(2, '0')).toList();
  return _buildWheelContainer(
    title: title,
    child: DynamicWheel(
      items: itemStrings,
      initialIndex: items.indexOf(selectedValue),
      onSelected: (index) => onSelected(items[index]),
    ),
  );
}

/// 🔹 AM/PM Wheel
Widget amPmWheel({
  required String selectedValue,
  required ValueChanged<String> onSelected,
}) {
  final items = ["AM", "PM"];
  return _buildWheelContainer(
    title: "AM/PM",
    child: DynamicWheel(
      items: items,
      initialIndex: items.indexOf(selectedValue),
      onSelected: (index) => onSelected(items[index]),
    ),
  );
}

/// 🔹 Generic number wheel for guests
Widget guestWheelPicker({
  required String title,
  required int itemCount,
  required int selectedValue,
  required ValueChanged<int> onSelected,
  VoidCallback? onDone,
}) {
  final items = List.generate(itemCount, (i) => (i + 1).toString());

  return _buildWheelContainer(
    title: title,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DynamicWheel(
          items: items,
          initialIndex: selectedValue - 1,
          onSelected: (index) => onSelected(index + 1),
        ),
        const SizedBox(height: 10),
        if (onDone != null)
          ElevatedButton(
            onPressed: onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: Text(
              "Done",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
      ],
    ),
  );
}

/// 🔹 Internal helper for wheel with title and highlight lens
Widget _buildWheelContainer({
  required String title,
  required Widget child,
  Color titleColor = Colors.black,
}) {
  const double itemExtent = 48; // must match DynamicWheel’s itemExtent
  const double visibleItemCount = 5; // 2 above, 2 below + 1 selected
  final double wheelHeight = itemExtent * visibleItemCount;
  const double lensHeight = itemExtent; // ✅ exactly 1 item tall

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (title.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: titleColor,
            ),
          ),
        ),
      SizedBox(
        height: wheelHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🔹 Perfectly centered highlight lens (now exactly matches wheel)
            Align(
              alignment: Alignment.center,
              child: Container(
                height: lensHeight,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
              ),
            ),
            // 🔹 Wheel
            child,
          ],
        ),
      ),
    ],
  );
}

/// 🔹 Dynamic wheel widget for highlighting selected item
class DynamicWheel extends StatefulWidget {
  final List<String> items;
  final int initialIndex;
  final ValueChanged<int> onSelected;

  const DynamicWheel({
    super.key,
    required this.items,
    required this.initialIndex,
    required this.onSelected,
  });

  @override
  State<DynamicWheel> createState() => _DynamicWheelState();
}

class _DynamicWheelState extends State<DynamicWheel> {
  late FixedExtentScrollController _controller;
  late int _currentIndex;

  static const double _itemExtent = 48;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = FixedExtentScrollController(initialItem: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _itemExtent * 5, // ✅ 5 visible items (center one is lens)
      child: ListWheelScrollView.useDelegate(
        controller: _controller,
        physics: const FixedExtentScrollPhysics(),
        itemExtent: _itemExtent,
        diameterRatio: 1.6,
        perspective: 0.004,
        squeeze: 1.0,
        overAndUnderCenterOpacity: 0.5,
        onSelectedItemChanged: (index) {
          setState(() => _currentIndex = index);
          widget.onSelected(index);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final isSelected = index == _currentIndex;
            return Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 120),
                style: GoogleFonts.montserrat(
                  fontSize: isSelected ? 22 : 17,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.black87 : Colors.grey.shade500,
                ),
                child: Text(widget.items[index]),
              ),
            );
          },
          childCount: widget.items.length,
        ),
      ),
    );
  }
}
