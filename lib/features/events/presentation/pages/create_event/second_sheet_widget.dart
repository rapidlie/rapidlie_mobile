import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/autocomplete_predictions.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/getUserCurrentLocation.dart';
import 'package:rapidlie/core/utils/location_utils.dart';
import 'package:rapidlie/core/utils/table_calendar_widget.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/events/presentation/widgets/overlay_utils.dart';
import 'package:rapidlie/features/events/provider/create_event_provider.dart';

class SecondSheetContentWidget extends StatefulWidget {
  final dynamic language;
  final PageController pageViewController;

  SecondSheetContentWidget({
    required this.language,
    required this.pageViewController,
  });

  @override
  _SecondSheetContentWidgetState createState() =>
      _SecondSheetContentWidgetState();
}

class _SecondSheetContentWidgetState extends State<SecondSheetContentWidget> {
  DateTime _selectedDay = DateTime.now();
  String selectedStartTime = '00:00 am';
  String selectedEndTime = '00:00 pm';
  TextEditingController venueController = TextEditingController();
  LatLng? latLngOfUserLocation;
  String mapId = '';
  bool locationVisibility = false;
  List<AutocompletePrediction> predictionList = [];
  bool isMenuOpen = false;
  bool allDay = false;
  final GlobalKey _keyDate = GlobalKey();
  final GlobalKey _keyStartTime = GlobalKey();
  final GlobalKey _keyEndTime = GlobalKey();
  String dateText = 'Date';
  List eventTimeOfDay = ['am', 'pm'];
  int selectedStartTimeOfDayChecker = 0;
  int selectedEndTimeOfDayChecker = 1;
  int selectedStartTimeChecker = 1000000000;
  int selectedEndTimeChecker = 1000000000;
  String? idOfSelectedCategory;
  String nameOfSelectedCategory = "Select category";
  late Offset buttonPosition;
  late Size buttonSize;
  OverlayEntry? _overlayEntry;

  String selectedStartTimeOfDay = "am";

  String selectedEndTimeOfDay = "pm";
  List eventTimes = [
    '12:00',
    '1:00',
    '2:00',
    '3:00',
    '4:00',
    '5:00',
    '6:00',
    '7:00',
    '8:00',
    '9:00',
    '10:00',
    '11:00',
  ];

  findButton(GlobalKey _key) {
    RenderBox? renderBox =
        _key.currentContext!.findRenderObject() as RenderBox?;
    buttonSize = renderBox!.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  closeMenu() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    isMenuOpen = !isMenuOpen;
  }

  startTimeDropDown(GlobalKey _key) {
    return Container(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                itemCount: eventTimes.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStartTimeChecker = index;
                        selectedStartTime =
                            eventTimes[index] + " " + selectedStartTimeOfDay;
                        closeMenu();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        eventTimes[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: selectedStartTimeChecker == index
                              ? Colors.black
                              : CustomColors.colorFromHex("#AEB2BF"),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: NeverScrollableScrollPhysics(),
                itemCount: eventTimeOfDay.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStartTimeOfDayChecker = index;
                          selectedStartTimeOfDay = eventTimeOfDay[index];
                          closeMenu();
                          openStartTimeMenu(_key);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: selectedStartTimeOfDayChecker == index
                                ? CustomColors.black
                                : CustomColors.white,
                            border: Border.all(
                              color: selectedStartTimeOfDayChecker == index
                                  ? CustomColors.black
                                  : CustomColors.colorFromHex("#AEB2BF"),
                            )),
                        child: Text(
                          eventTimeOfDay[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: selectedStartTimeOfDayChecker == index
                                ? CustomColors.white
                                : CustomColors.colorFromHex("#AEB2BF"),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  endTimeDropDown(GlobalKey _key) {
    return Container(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                itemCount: eventTimes.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedEndTimeChecker = index;
                        selectedEndTime =
                            eventTimes[index] + " " + selectedEndTimeOfDay;
                        closeMenu();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        eventTimes[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: selectedEndTimeChecker == index
                              ? Colors.black
                              : CustomColors.colorFromHex("#AEB2BF"),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                physics: NeverScrollableScrollPhysics(),
                itemCount: eventTimeOfDay.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedEndTimeOfDayChecker = index;
                          selectedEndTimeOfDay = eventTimeOfDay[index];
                          closeMenu();
                          openEndTimeMenu(_key);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: selectedEndTimeOfDayChecker == index
                                ? Colors.black
                                : CustomColors.white,
                            border: Border.all(
                              color: selectedEndTimeOfDayChecker == index
                                  ? CustomColors.black
                                  : CustomColors.colorFromHex("#AEB2BF"),
                            )),
                        child: Text(
                          eventTimeOfDay[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: selectedEndTimeOfDayChecker == index
                                ? CustomColors.white
                                : CustomColors.colorFromHex("#AEB2BF"),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openDateMenu(GlobalKey _key) {
    findButton(_key);
    _overlayEntry = OverlayUtils.createOverlayEntry(
      TableCalendarWidget(
        selectedDay: _selectedDay,
        onDaySelected: (selectedDay) {
          setState(() {
            _selectedDay = selectedDay;
          });
          closeMenu();
        },
        closeMenu: closeMenu,
      ),
      buttonPosition,
      buttonSize,
      buttonPosition.dx,
      buttonSize.width,
      null,
    );
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  void openStartTimeMenu(GlobalKey _key) {
    findButton(_key);

    _overlayEntry = OverlayUtils.createOverlayEntry(
        startTimeDropDown(_key),
        buttonPosition,
        buttonSize,
        null,
        buttonSize.width / 1.2,
        buttonPosition.dx);
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  void openEndTimeMenu(GlobalKey _key) {
    findButton(_key);

    _overlayEntry = OverlayUtils.createOverlayEntry(
        endTimeDropDown(_key),
        buttonPosition,
        buttonSize,
        null,
        buttonSize.width / 1.2,
        buttonPosition.dx);
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.language.selectDate + '*',
            style: inter12CharcoalBlack400(),
          ),
          extraSmallHeight(),
          GestureDetector(
            onTap: () {
              if (isMenuOpen) {
                closeMenu();
              } else {
                openDateMenu(_keyDate);
              }
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
                      convertDateDotFormat(_selectedDay),
                      style: GoogleFonts.inter(
                        color: CustomColors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: CustomColors.colorFromHex("#C6CDD3"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          smallHeight(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.language.startTime + '*',
                      style: inter12CharcoalBlack400(),
                    ),
                    extraSmallHeight(),
                    GestureDetector(
                      onTap: () {
                        if (isMenuOpen) {
                          closeMenu();
                        } else {
                          if (allDay) {
                          } else {
                            openStartTimeMenu(_keyEndTime);
                          }
                        }
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
                                allDay ? "00:00 am" : selectedStartTime,
                                style: GoogleFonts.inter(
                                  color: allDay
                                      ? CustomColors.colorFromHex("#C6CDD3")
                                      : CustomColors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: CustomColors.colorFromHex("#C6CDD3"),
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
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.language.endTime + '*',
                      style: inter12CharcoalBlack400(),
                    ),
                    extraSmallHeight(),
                    GestureDetector(
                      onTap: () {
                        if (isMenuOpen) {
                          closeMenu();
                        } else {
                          if (allDay) {
                          } else {
                            openEndTimeMenu(_keyStartTime);
                          }
                        }
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
                                allDay ? "00:00 pm" : selectedEndTime,
                                style: GoogleFonts.inter(
                                  color: allDay
                                      ? CustomColors.colorFromHex("#C6CDD3")
                                      : CustomColors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: CustomColors.colorFromHex("#C6CDD3"),
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
          smallHeight(),
          Text(
            widget.language.location + '*',
            style: inter12CharcoalBlack400(),
          ),
          extraSmallHeight(),
          TextFieldTemplate(
            hintText: 'Straße 123, Germany',
            controller: venueController,
            obscureText: false,
            width: Get.width,
            height: 50,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enabled: true,
            textFieldColor: Colors.white,
            suffixIcon: GestureDetector(
              onTap: () async {
                Map locationItems = await getLocation();
                String currentLocation = locationItems['loc'];

                setState(
                  () {
                    venueController.text = currentLocation;
                    latLngOfUserLocation =
                        LatLng(locationItems['lat'], locationItems['lng']);
                    mapId = latLngOfUserLocation.toString();
                    locationVisibility = false;
                  },
                );
              },
              child: Icon(
                Icons.my_location,
                size: 20,
              ),
            ),
            onChanged: (value) async {
              predictionList = await LocationUtils.placeAutoComplete(value);
              setState(() {
                locationVisibility = true;
              });
            },
          ),
          Visibility(
            visible: locationVisibility,
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                itemCount: predictionList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      latLngOfUserLocation = await LocationUtils.getLatLong(
                          predictionList[index].placeId!);
                      setState(
                        () {
                          venueController.text =
                              predictionList[index].description!;
                          mapId = latLngOfUserLocation.toString();

                          locationVisibility = false;
                        },
                      );
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Text(
                        predictionList[index].description!,
                        style: inter12CharcoalBlack400(),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ButtonTemplate(
            buttonName: widget.language.next,
            buttonWidth: Get.width,
            buttonAction: () {
              if (venueController.text.isEmpty ||
                  selectedStartTime == '00:00 am' ||
                  selectedEndTime == '00:00 pm') {
                Get.snackbar("Error", "All fields are required");
                return;
              } else {
                context.read<CreateEventProvider>().updateEvent(
                      date: convertDateDashFormat(_selectedDay),
                      startTime: selectedStartTime.toString(),
                      endTime: selectedEndTime.toString(),
                      venue: venueController.text,
                      mapLocation: mapId,
                    );
                widget.pageViewController.nextPage(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
