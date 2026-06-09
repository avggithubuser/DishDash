import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadiusSlider extends StatefulWidget {
  final Function(double) onRadiusChanged;

  const RadiusSlider({required this.onRadiusChanged, super.key});

  @override
  State<RadiusSlider> createState() => _RadiusSliderState();
}

class _RadiusSliderState extends State<RadiusSlider> {
  double _radius = 50; // default radius in km

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          'Radius: ${_radius.toStringAsFixed(1)} km',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Slider(
          value: _radius,
          min: 1,
          max: 50,
          divisions: 49,
          label: '${_radius.toStringAsFixed(1)} km',
          onChanged: (value) {
            setState(() {
              _radius = value;
            });
            widget.onRadiusChanged(_radius);
          },
        ),
      ],
    );
  }
}
