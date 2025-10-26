import 'dart:math';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
// 🔸 COMMENTED OUT FOR OFFLINE MODE
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/methods/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dish_dash/core/widgets/icon_button.dart';
import 'package:dish_dash/core/widgets/text_button.dart';
import 'package:dish_dash/core/services/theme_service.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  // Mock reservation data (offline) with OTP
  final List<Map<String, dynamic>> reservations = [
    {
      'restaurant': 'Cafe Royale',
      'name': 'John Doe',
      'date': '26/10/2025',
      'guests': 4,
      'contact': '+92 300 1234567',
      'otp': '4827',
    },
    {
      'restaurant': 'Bistro 21',
      'name': 'Jane Smith',
      'date': '27/10/2025',
      'guests': 2,
      'contact': '+92 300 7654321',
      'otp': '1953',
    },
    {
      'restaurant': 'The Green Leaf',
      'name': 'Ali Khan',
      'date': '28/10/2025',
      'guests': 3,
      'contact': '+92 300 5555555',
      'otp': '8372',
    },
  ];

  // Optional: function to generate random 4-digit OTP
  String generateOtp({int length = 4}) {
    final random = Random();
    String otp = '';
    for (int i = 0; i < length; i++) {
      otp += random.nextInt(10).toString();
    }
    return otp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RESERVATIONS",
          style: GoogleFonts.montserrat(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(184, 196, 169, 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final data = reservations[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.w),
              ),
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 6.h),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant name
                    Text(
                      "Restaurant: ${data['restaurant'] ?? 'Unknown'}",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Person name
                    Text(
                      "Name: ${data['name'] ?? 'Unknown'}",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Date
                    Text(
                      "Date: ${data['date'] ?? 'Unknown'}",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 4.h),

                    // Guests
                    Text(
                      "Guests: ${data['guests'] ?? 'Unknown'}",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 4.h),

                    // Contact
                    Text(
                      "Contact: ${data['contact'] ?? 'Unknown'}",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 4.h),

                    // OTP display
                    Text(
                      "OTP: ${data['otp'] ?? generateOtp()}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      // Firebase comments for future integration
      /*
      // Cloud Function for OTP generation on reservation creation
      // Firebase Firestore structure:
      // Collection: reservations
      // Fields: restaurant, name, date, guests, contact, otp, checkedIn
      //
      // Example Cloud Function:
      //
      // exports.generateReservationOtp = functions.firestore
      //   .document('reservations/{reservationId}')
      //   .onCreate((snap, context) => {
      //       const otp = Math.floor(1000 + Math.random() * 9000).toString();
      //       return snap.ref.update({ otp });
      //   });
      //
      // Then in Flutter:
      // StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance.collection('reservations')
      //         .orderBy('date', descending: true).snapshots(),
      //   builder: (context, snapshot) { ... }
      // )
      */
    );
  }
}
