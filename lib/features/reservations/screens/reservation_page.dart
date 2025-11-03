import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:dish_dash/features/reservations/widgets/wheel_dials.dart';
// 🔸 COMMENTED OUT FOR OFFLINE MODE
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dish_dash/methods/firebase_methods.dart';

class ReservationPage extends StatefulWidget {
  final Map<String, dynamic> restaurantData;

  const ReservationPage({super.key, required this.restaurantData});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _selectedGuests = 2;
  int _selectedHour = DateTime.now().hour;
  int _selectedMinute = (DateTime.now().minute ~/ 5) * 5;
  String _amPm = DateTime.now().hour >= 12 ? "PM" : "AM";

  final List<int> minutesList = List.generate(12, (i) => i * 5);
  final List<int> hoursList = List.generate(12, (i) => i + 1);

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _showGuestPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return guestWheelPicker(
          title: "Select Guests",
          itemCount: 30,
          selectedValue: _selectedGuests,
          onSelected: (index) => setState(() => _selectedGuests = index + 1),
        );
      },
    );
  }

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                "Select Time",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: timeWheel(
                        title: "Hours",
                        items: hoursList,
                        selectedValue: _selectedHour,
                        onSelected: (index) =>
                            setState(() => _selectedHour = hoursList[index]),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: timeWheel(
                        title: "Minutes",
                        items: minutesList,
                        selectedValue: _selectedMinute, // ⚡ fix here
                        onSelected: (index) => setState(
                          () => _selectedMinute = minutesList[index],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: amPmWheel(
                        selectedValue: _amPm,
                        onSelected: (value) => setState(() => _amPm = value),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _confirmReservation() {
    // 🔹 Simple validation
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields."),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final phone = _phoneController.text.trim();
    final phoneRegExp = RegExp(r'^(?:\+92|0)?3[0-9]{9}$'); // Pakistani format

    if (!phoneRegExp.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid phone number."),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final reservationData = {
      "name": _nameController.text,
      "phone": _phoneController.text,
      "date": DateFormat('dd/MM/yyyy').format(_selectedDate),
      "guests": _selectedGuests,
      "time":
          "${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} $_amPm",
      "restaurant": widget.restaurantData["name"],
    };

    // 🔸 COMMENTED OUT FOR OFFLINE MODE
    // FirebaseMethods().addReservation(reservationData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Reservation request sent to ${reservationData['restaurant']}, please wait for in-app confirmation",
        ),
        duration: const Duration(seconds: 5), // ⏳ Longer duration
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurantData;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🍽️ Banner with Go Back Button overlay
                Stack(
                  children: [
                    ClipRRect(
                      // borderRadius: const BorderRadius.only(
                      //   bottomLeft: Radius.circular(30),
                      //   bottomRight: Radius.circular(30),
                      // ),
                      child: Image.network(
                        restaurant["imageUrl"] ?? "",
                        width: double.infinity,
                        height: 200.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 200.h,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.restaurant,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  color: Color.fromRGBO(184, 196, 169, 1),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Text(
                    "Reserve at ${restaurant['name']}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                      color: Colors.white,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25.h),

                      _outlinedField("Full Name", _nameController),
                      SizedBox(height: 16.h),

                      _outlinedField(
                        "Phone Number",
                        _phoneController,
                        isPhone: true, // 🔹 Added flag for numeric keyboard
                      ),
                      SizedBox(height: 16.h),

                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(
                              text: DateFormat(
                                'dd/MM/yyyy',
                              ).format(_selectedDate),
                            ),
                            style: const TextStyle(color: Colors.black),
                            decoration: _inputDecoration("Date"),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      GestureDetector(
                        onTap: _showGuestPicker,
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(
                              text: "$_selectedGuests Guests",
                            ),
                            style: const TextStyle(color: Colors.black),
                            decoration: _inputDecoration("Guests"),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      GestureDetector(
                        onTap: _showTimePicker,
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(
                              text:
                                  "${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} $_amPm",
                            ),
                            style: const TextStyle(color: Colors.black),
                            decoration: _inputDecoration("Time"),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),

                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _confirmReservation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            "Request Reservation",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.montserrat(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r)),
      floatingLabelStyle: GoogleFonts.montserrat(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _outlinedField(
    String label,
    TextEditingController controller, {
    bool isPhone = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isPhone
          ? TextInputType
                .phone // 🔹 Numeric-only keyboard for phone field
          : TextInputType.text,
      style: const TextStyle(color: Colors.black),
      decoration: _inputDecoration(label),
    );
  }
}
