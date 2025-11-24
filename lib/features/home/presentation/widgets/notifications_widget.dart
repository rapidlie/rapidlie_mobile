import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';

class FlashNotificationsTemplate extends StatelessWidget {
  
  final String noificationTitle;
  final String noificationBody;

  const FlashNotificationsTemplate({super.key, required this.noificationTitle, required this.noificationBody});

  @override
  Widget build(BuildContext context) {
    
    return Container(
          margin: EdgeInsets.only(left: 10),
          height: 120,
          width: MediaQuery.of(context).size.width - 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            
            color: CustomColors.colorFromHex("#25272E"),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColors.colorFromHex(
                                  "#29EBD0")),
                        ),
                        SizedBox(width: 8),
                        Text(
                          noificationTitle,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                    /* Icon(
                      Icons.close,
                      size: 18,
                      color: const Color.fromARGB(
                          255, 158, 158, 158),
                    ), */
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  noificationBody,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.inter(
                    color: const Color.fromARGB(
                        255, 192, 192, 192),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    
                  ),
                ),
              ],
            ),
          ),
        );
  }
}