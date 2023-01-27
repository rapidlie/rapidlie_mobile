import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/components/button_template.dart';
import 'package:rapidlie/components/text_field_template.dart';
import 'package:rapidlie/constants/color_constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  static const String routeName = "events";

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List eventsCreated = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int bottomSheetContentIndex = 0;
  String dateText = 'Date';
  late PageController _pageViewController;
  late GlobalKey _keyDate;
  late GlobalKey _keyStartTime;
  late GlobalKey _keyEndTime;
  bool isMenuOpen = false;
  late Offset buttonPosition;
  late Size buttonSize;
  late OverlayEntry? _overlayEntry;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  //DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime _currentDay = DateTime.now();

  @override
  void initState() {
    _pageViewController = PageController();
    _keyDate = LabeledGlobalKey("button_icon");
    _keyStartTime = LabeledGlobalKey("button_icon");
    _keyEndTime = LabeledGlobalKey("button_icon");
    super.initState();
  }

  findButton(GlobalKey _key) {
    RenderBox? renderBox =
        _key.currentContext!.findRenderObject() as RenderBox?;
    buttonSize = renderBox!.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    isMenuOpen = !isMenuOpen;
  }

  void openMenu(StateSetter setState, GlobalKey _key) {
    findButton(_key);
    _overlayEntry = _overlayEntryBuilder(setState);
    Overlay.of(context)!.insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder(StateSetter setState) {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: tableCalendar(setState),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: eventsCreated.length == 0
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You have not created any event. Click on the button below to add your event',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.charcoalBlack,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          isScrollControlled: true,
                          builder: (context) {
                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return SingleChildScrollView(
                                  primary: true,
                                  child: bottomSheetLayout(setState),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.primary,
                        ),
                        child: Icon(
                          Icons.add,
                          color: ColorConstants.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: Text(
                          "Events screen",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget bottomSheetLayout(StateSetter setState) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: ColorConstants.colorFromHex("#F2F4F5"),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Create event',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: ColorConstants.charcoalBlack,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      closeMenu();
                      Get.back();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorConstants.colorFromHex("#FFFFFF"),
                      ),
                      child: Icon(
                        Icons.close,
                        color: ColorConstants.closeButtonColor,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                color: ColorConstants.lightGray,
                height: 1,
                width: Get.width,
              ),
            ),
            Container(
              height: 470,
              child: PageView(
                controller: _pageViewController,
                pageSnapping: true,
                children: [
                  firstSheetContent(),
                  secondSheetContent(setState),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  firstSheetContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event title',
            style: TextStyle(
              fontSize: 14.0,
              color: ColorConstants.charcoalBlack,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          TextFieldTemplate(
            hintText: 'Title',
            controller: titleController,
            obscureText: false,
            width: Get.width,
            height: 50,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enabled: true,
            textFieldColor: Colors.white,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Upload flyer',
            style: TextStyle(
              fontSize: 14.0,
              color: ColorConstants.charcoalBlack,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 200,
            width: Get.width,
            decoration: BoxDecoration(
                color: ColorConstants.colorFromHex("#FFFFFF"),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: ColorConstants.colorFromHex("#C6CDD3"))),
            child: Icon(
              Icons.add_photo_alternate,
              size: 100,
              color: ColorConstants.gray,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ButtonTemplate(
              buttonName: "next",
              buttonColor: ColorConstants.primary,
              buttonWidth: Get.width,
              buttonHeight: 50,
              buttonAction: () {},
              fontColor: Colors.white,
              textSize: 10,
              buttonBorderRadius: 10,
            ),
          ),
        ],
      ),
    );
  }

  secondSheetContent(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select date',
            style: TextStyle(
              fontSize: 14.0,
              color: ColorConstants.charcoalBlack,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              if (isMenuOpen) {
                closeMenu();
              } else {
                openMenu(setState, _keyDate);
              }
              //dateController.text = 'Hello';
            },
            child: Container(
              key: _keyDate,
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      convertDate(_selectedDay) ?? 'Date',
                      style: TextStyle(
                        color: ColorConstants.black,
                        fontSize: 17.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorConstants.colorFromHex("#C6CDD3"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start time',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: ColorConstants.charcoalBlack,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isMenuOpen) {
                          //closeMenu();
                        } else {
                          //openMenu(setState, _keyStartTime);
                        }
                        //dateController.text = 'Hello';
                      },
                      child: Container(
                        key: _keyStartTime,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Start time',
                                style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 17.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorConstants.colorFromHex("#C6CDD3"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End time',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: ColorConstants.charcoalBlack,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isMenuOpen) {
                          //closeMenu();
                        } else {
                          //openMenu(setState, _keyEndTime);
                        }
                        //dateController.text = 'Hello';
                      },
                      child: Container(
                        key: _keyEndTime,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'End time',
                                style: TextStyle(
                                  color: ColorConstants.black,
                                  fontSize: 17.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorConstants.colorFromHex("#C6CDD3"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0),
            child: ButtonTemplate(
              buttonName: "next",
              buttonColor: ColorConstants.primary,
              buttonWidth: Get.width,
              buttonHeight: 50,
              buttonAction: () {},
              fontColor: Colors.white,
              textSize: 10,
              buttonBorderRadius: 10,
            ),
          ),
        ],
      ),
    );
  }

  tableCalendar(StateSetter setState) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2100, 3, 14),
      focusedDay: _currentDay,
      currentDay: _currentDay,
      rowHeight: 32,
      calendarFormat: _calendarFormat,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        leftChevronPadding: EdgeInsets.zero,
        leftChevronMargin: EdgeInsets.zero,
        rightChevronPadding: EdgeInsets.zero,
        rightChevronMargin: EdgeInsets.zero,
        titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorConstants.gray900,
            fontFamily: "Metropolis"),
      ),
      daysOfWeekHeight: 24,
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: "Metropolis",
          color: ColorConstants.colorFromHex("#0E1339"),
        ),
        weekendStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Metropolis",
          fontWeight: FontWeight.w500,
          color: ColorConstants.colorFromHex("#0E1339"),
        ),
      ),
      calendarStyle: CalendarStyle(
        todayTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Metropolis",
          fontWeight: FontWeight.w600,
          color: ColorConstants.gray900,
        ),
        withinRangeDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.colorFromHex("#F4F5FB"),
        ),
        defaultTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Metropolis",
          fontWeight: FontWeight.w600,
          color: ColorConstants.colorFromHex("#34405E"),
        ),
        outsideTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Metropolis",
          fontWeight: FontWeight.w600,
          color: ColorConstants.colorFromHex("#AEB2BF"),
        ),
        weekendTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Metropolis",
          fontWeight: FontWeight.w600,
          color: ColorConstants.colorFromHex("#34405E"),
        ),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.colorFromHex("#F4F5FB"),
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.colorFromHex("#F4F5FB"),
        ),
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.colorFromHex("#ADDBFB"),
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.primary,
        ),
        selectedTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Metropolis",
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ), //
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, currentDay) {
        if (selectedDay.isBefore(DateTime.now())) {
          Get.snackbar(
            "Error",
            "Selected day cannot be in the past",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
            backgroundColor: ColorConstants.white,
            colorText: ColorConstants.black,
          );
        } else if (!isSameDay(_selectedDay, selectedDay)) {
          setState((() {
            _selectedDay = selectedDay;
            closeMenu();
          }));
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {},
    );
  }

  String convertDate(DateTime? dateToConvert) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    if (dateToConvert == null) {
      return 'Date';
    } else {
      return dateFormat.format(dateToConvert);
    }
  }
}
