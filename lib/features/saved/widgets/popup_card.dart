import 'dart:ui'; // for ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Widget restaurantPopupCard(
  BuildContext context,
  Map<String, dynamic> data,
  ColorScheme colorScheme,
) {
  return Center(
    child: SizedBox(
      width: 320.w,
      height: 540.h,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                colorScheme.secondary.withOpacity(0.4),
                colorScheme.primary.withOpacity(0.4),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.secondary.withOpacity(0.8),
                blurRadius: 20,
                spreadRadius: 3,
                offset: const Offset(-6, 0),
              ),
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.8),
                blurRadius: 20,
                spreadRadius: 3,
                offset: const Offset(6, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.w),
                  color: Colors.white.withOpacity(0.35),
                  border: Border.all(
                    color: Colors.grey.shade300.withOpacity(0.5),
                    width: 1.2.w,
                  ),
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close, size: 24.sp),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.w),
                      child: Image.network(
                        data['image'] ?? '',
                        width: double.infinity,
                        height: 250.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      data['name'] ?? "Unknown",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    RatingBarIndicator(
                      rating: data['rating'] ?? 0.0,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemSize: 24.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      data['desc'] ?? "No description.",
                      maxLines: 4,
                      style: GoogleFonts.lora(
                        fontSize: 12.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        if (data['hasFoodpanda'] == true)
                          IconButton(
                            icon: SizedBox(
                              height: 20.h,
                              child: Image.asset("assets/foodpanda.png"),
                            ),
                            onPressed: () async {
                              final url = data['foodpandaUrl'] ?? '';
                              if (url.isNotEmpty) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                          ),
                        if (data['instagram'] != null &&
                            data['instagram'].toString().isNotEmpty)
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.instagram),
                            color: Colors.pink,
                            onPressed: () async {
                              final url = data['instagram'];
                              if (url != null && url.isNotEmpty) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                          ),
                        if (data['hasReservations'] == true)
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              debugPrint(
                                "Reservation tapped for ${data['name']}",
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
