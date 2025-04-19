import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime currentDay;
  DateTime? selectedDay;
  CalendarFormat calendarFormat;

  CalendarWidget({Key? key, required this.currentDay,  this.selectedDay, required this.calendarFormat}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2100, 3, 14),
      focusedDay: widget.currentDay,
      currentDay: widget.currentDay,
      rowHeight: 32,
      calendarFormat: widget.calendarFormat,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        leftChevronPadding: EdgeInsets.zero,
        leftChevronMargin: EdgeInsets.zero,
        rightChevronPadding: EdgeInsets.zero,
        rightChevronMargin: EdgeInsets.zero,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: CustomColors.gray900,
        ),
      ),
      daysOfWeekHeight: 24,
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: CustomColors.colorFromHex("#0E1339"),
        ),
        weekendStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: CustomColors.colorFromHex("#0E1339"),
        ),
      ),
      calendarStyle: CalendarStyle(
        todayTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CustomColors.primary,
        ),
        withinRangeDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CustomColors.colorFromHex("#F4F5FB"),
        ),
        defaultTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CustomColors.colorFromHex("#34405E"),
        ),
        outsideTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CustomColors.colorFromHex("#AEB2BF"),
        ),
        weekendTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CustomColors.colorFromHex("#34405E"),
        ),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CustomColors.colorFromHex("#F4F5FB"),
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CustomColors.colorFromHex("#F4F5FB"),
        ),
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CustomColors.primaryLight,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        selectedTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ), //
      ),
      selectedDayPredicate: (day) {
        return isSameDay(widget.selectedDay, day);
      },
      onDaySelected: (selectedDay, currentDay) {
        if (selectedDay.isBefore(DateTime.now())) {
          Get.snackbar(
            "Error",
            "Selected day cannot be in the past",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
            backgroundColor: CustomColors.white,
            colorText: CustomColors.black,
          );
        } else if (!isSameDay(widget.selectedDay, selectedDay)) {
          setState((() {
            widget.selectedDay = selectedDay;
            //closeMenu();
          }));
        }
      },
      onFormatChanged: (format) {
        if (widget.calendarFormat != format) {
          setState(() {
            widget.calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {},
    );
  }
}
