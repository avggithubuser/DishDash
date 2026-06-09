import 'dart:ui'; // for ImageFilter.blur
import 'package:auto_size_text/auto_size_text.dart';
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
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color.fromRGBO(230, 216, 195, 1),
                const Color.fromRGBO(230, 216, 195, 1),
              ],
            ),
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
                padding: EdgeInsets.all(15.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close button
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.w),
                          child: Image.network(
                            data['imageUrl'] ?? '',
                            width: double.infinity,
                            height: 250.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 24.sp,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    AutoSizeText(
                      data['name'] ?? "Unknown",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    // foodpanda, instagram, res, menu, contact
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (data['instagram'] != null &&
                              data['instagram'].toString().isNotEmpty)
                            GestureDetector(
                              onTap: () async {
                                final url = data['instagram'];
                                if (url != null && url.toString().isNotEmpty) {
                                  debugPrint("Opening Instagram: $url");
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                              child: FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.pink,
                              ),
                            ),
                          //
                          SizedBox(width: 15.w),
                          //
                          GestureDetector(
                            child: Icon(
                              Icons.menu_book_outlined,
                              color: Colors.pink,
                            ),

                            onTap: () {
                              // handle menu tap
                            },
                          ),
                          //
                          SizedBox(width: 15.w),
                          GestureDetector(
                            onTap: () async {
                              final phoneNumber = data['contact'][0];
                              if (phoneNumber != null &&
                                  phoneNumber.toString().isNotEmpty) {
                                debugPrint("Calling: $phoneNumber");
                                await launchUrl(
                                  Uri(scheme: 'tel', path: phoneNumber),
                                );
                              }
                            },
                            child: FaIcon(
                              FontAwesomeIcons.phone,
                              size: 20.w,
                              color: Colors.pink,
                            ),
                          ),
                          SizedBox(width: 15.w),

                          if (data['hasFoodpanda'] == true)
                            GestureDetector(
                              child: SizedBox(
                                height: 20.w,
                                child: Image.asset(
                                  color: Colors.pink,

                                  "assets/foodpanda.png",
                                ),
                              ),
                              onTap: () async {
                                final url = data['foodpandaUrl'] ?? '';
                                if (url.isNotEmpty) {
                                  debugPrint("Opening Foodpanda: $url");
                                  await launchUrl(Uri.parse(url));
                                }
                              },
                            ),
                          //
                        ],
                      ),
                    ),
                    // rating
                    RatingBarIndicator(
                      rating: double.tryParse(data['rating']) ?? 0.0,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemSize: 24.sp,
                    ),
                    SizedBox(height: 8.h),
                    AutoSizeText(
                      data['desc'] ?? "No description.",
                      maxLines: 4,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        color: colorScheme.onSurface,
                      ),
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
