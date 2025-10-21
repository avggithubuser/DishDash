import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceTagSlider extends StatefulWidget {
  final Function(List<String>) onPriceChanged;

  const PriceTagSlider({super.key, required this.onPriceChanged});

  @override
  State<PriceTagSlider> createState() => _PriceTagSliderState();
}

class _PriceTagSliderState extends State<PriceTagSlider> {
  final List<String> priceTags = [
    '\$',
    '\$\$',
    '\$\$\$',
    '\$\$\$\$',
    '\$\$\$\$\$',
  ];
  double _sliderValue = 1;

  @override
  Widget build(BuildContext context) {
    int selectedIndex = _sliderValue.round() - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: AutoSizeText(
            "Price range",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        // slider
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Slider(
            value: _sliderValue,
            min: 1,
            max: 5,
            divisions: 4,
            label: priceTags[selectedIndex],
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
              widget.onPriceChanged(priceTags.sublist(0, value.round()));
            },
          ),
        ),
        // label under slider
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(priceTags.length, (index) {
              bool isSelected = index <= selectedIndex;
              return AutoSizeText(
                priceTags[index],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue : Colors.grey,
                  fontSize: 14,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
