import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dish_dash/features/auth/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get(),
        builder: (context, future) {
          if (future.hasData) {
            Map<String, dynamic>? userData = future.data?.data();

            if (userData!.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // before divider
                          Column(
                            children: [
                              // USERNAME
                              Row(
                                children: [
                                  AutoSizeText(
                                    userData['username'],
                                    style: theme.textTheme.displayLarge
                                        ?.copyWith(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 40.sp,
                                        ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: AutoSizeText(
                                            "Edit Username",
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 25.sp,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),

                              // ACCOUNT DETAILS
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: AutoSizeText(
                                        "Go to account details page",
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    AutoSizeText(
                                      "Account details  ",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.black.withOpacity(
                                              0.8,
                                            ),
                                            fontSize: 15.sp,
                                          ),
                                    ),
                                    Icon(
                                      Icons.arrow_outward_rounded,
                                      size: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // divider
                          Divider(thickness: 0.5),
                          SizedBox(height: 30.h),
                          // details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.favorite_border, size: 25.sp),
                                  SizedBox(width: 10.w),
                                  AutoSizeText(
                                    (userData["rightSwipes"] != null &&
                                            (userData["rightSwipes"] as List)
                                                .isNotEmpty)
                                        ? "${(userData["rightSwipes"] as List).length} liked restaurant(s)"
                                        : "No liked restaurants",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),

                              Row(
                                children: [
                                  Icon(Icons.bookmark_outline, size: 25.sp),
                                  SizedBox(width: 10.w),
                                  AutoSizeText(
                                    (userData["favourites"] != null &&
                                            (userData["favourites"] as List)
                                                .isNotEmpty)
                                        ? "${(userData["favourites"] as List).length} saved restaurant(s)"
                                        : "No saved restaurants",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),

                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: AutoSizeText(
                                        "Go to account reservation page",
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.room_service_outlined,
                                      size: 25.sp,
                                    ),
                                    SizedBox(width: 10.w),
                                    AutoSizeText(
                                      "Reservations History ",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.black.withOpacity(
                                              0.8,
                                            ),
                                            fontSize: 20.sp,
                                          ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // logout button
                      MyButton(
                        width: 500.w,
                        title: "L O G O U T",
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return AutoSizeText("loading");
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
        },
      ),
    );
  }
}
