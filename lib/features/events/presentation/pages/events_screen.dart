import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/general_event_list_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/categories/models/category_model.dart';
import 'package:rapidlie/features/contacts/models/contact_details.dart';
import 'package:rapidlie/features/contacts/presentation/pages/contact_list_screen.dart';
import 'package:rapidlie/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:rapidlie/features/events/bloc/create_event_bloc.dart';
import 'package:rapidlie/features/events/bloc/event_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/events/provider/create_event_provider.dart';
import 'package:rapidlie/features/file_upload/bloc/file_upload_bloc.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  static const String routeName = "events";

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List eventsCreated = [""];
  //List eventsCreated = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  int bottomSheetContentIndex = 0;
  String dateText = 'Date';
  late PageController _pageViewController;
  late GlobalKey _keyDate;
  late GlobalKey _keyStartTime;
  late GlobalKey _keyEndTime;
  bool isMenuOpen = false;
  late Offset buttonPosition;
  late Size buttonSize;
  OverlayEntry? _overlayEntry;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _currentDay = DateTime.now();
  String selectedStartTime = '00:00 am';
  String selectedStartTimeOfDay = "am";
  String selectedEndTime = '00:00 pm';
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

  List eventTimeOfDay = ['am', 'pm'];
  int selectedStartTimeOfDayChecker = 0;
  int selectedEndTimeOfDayChecker = 1;
  int selectedStartTimeChecker = 1000000000;
  int selectedEndTimeChecker = 1000000000;
  bool allDay = false;
  bool publicEvent = false;
  int showBackButton = 0;
  File? imageFile;
  var language;
  List<ContactDetails> selectedContacts = [];
  CategoryModel? selectedCategory;

  @override
  void initState() {
    _pageViewController = PageController(keepPage: false);
    _keyDate = LabeledGlobalKey("button_icon");
    _keyStartTime = LabeledGlobalKey("button_icon");
    _keyEndTime = LabeledGlobalKey("button_icon");
    context.read<EventBloc>().add(GetEvents());
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: language.events,
            isSubPage: false,
          ),
        ),
        backgroundColor: Colors.white,
        floatingActionButton:
            eventsCreated.length == 0 ? SizedBox() : buttonToShowModal(),
        body: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is InitialEventState) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonToShowModal(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      language.noEventCreated,
                      textAlign: TextAlign.center,
                      style: poppins13black400(),
                    ),
                  ],
                ),
              );
            } else if (state is EventLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is EventLoaded) {
              return buildBody(state.events);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Container buildBody(List<EventDataModel> eventDataModel) {
    return Container(
      child: eventsCreated.length == 0
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonToShowModal(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(language.noEventCreated,
                      textAlign: TextAlign.center, style: poppins13black400()),
                ],
              ),
            )
          : Container(
              height: Get.height,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 70),
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                itemCount: eventDataModel.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => EventDetailsScreeen(
                          isOwnEvent: true,
                        ),
                        arguments: eventDataModel[index],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: GeneralEventListTemplate(
                        eventName: eventDataModel[index].name,
                        eventImageString: eventDataModel[index].image,
                        eventDay: getDayName(eventDataModel[index].date),
                        eventDate: convertDateDotFormat(
                            DateTime.parse(eventDataModel[index].date)),
                        trailingWidget: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.favorite_outline_outlined,
                                    color: Colors.grey.shade600,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "456M",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            /* Icon(
                              Icons.ios_share,
                              color: Colors.grey.shade600,
                              size: 20,
                            ), */
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/send.svg",
                                    color: Colors.grey.shade700,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "45",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  buttonToShowModal() {
    return GestureDetector(
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
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  primary: true,
                  child: GestureDetector(
                    onTap: () => closeMenu(),
                    child: bottomSheetLayout(setState),
                  ),
                );
              },
            );
          },
        ).whenComplete(() {
          closeMenu();
          showBackButton = 0;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

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

  void openDateMenu(StateSetter setState, GlobalKey _key) {
    findButton(_key);
    _overlayEntry = _overlayEntryBuilder(
        tableCalendar(setState), buttonPosition.dx, buttonSize.width, null);
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  void openStartTimeMenu(StateSetter setState, GlobalKey _key) {
    findButton(_key);
    _overlayEntry = _overlayEntryBuilder(startTimeDropDown(setState, _key),
        null, buttonSize.width / 1.2, buttonPosition.dx);
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  void openEndTimeMenu(StateSetter setState, GlobalKey _key) {
    findButton(_key);
    _overlayEntry = _overlayEntryBuilder(endTimeDropDown(setState, _key), null,
        buttonSize.width / 1.2, buttonPosition.dx);
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder(
      Widget overlayToOpen, double? left, double width, double? right) {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: left,
          right: right,
          width: width,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: overlayToOpen,
              ),
            ),
          ),
        );
      },
    );
  }

  _getFromGallery(StateSetter setstate) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 200,
        maxWidth: Get.width,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        final File? convertedImagefile = File(pickedFile.path);
        setstate(() {
          imageFile = File(convertedImagefile!.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print("Error converting image to Base64: $e");
      return null;
    }
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      closeMenu();
                      setState(() {
                        showBackButton = showBackButton - 1;
                      });
                      _pageViewController.previousPage(
                        duration: new Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                    },
                    child: showBackButton > 0
                        ? Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorConstants.colorFromHex("#FFFFFF"),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: ColorConstants.closeButtonColor,
                              size: 20,
                            ),
                          )
                        : SizedBox(
                            width: 10,
                          ),
                  ),
                  Text(
                    language.createEvent,
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
                      setState(() {
                        showBackButton = 0;
                      });
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
                  ),
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
                physics: NeverScrollableScrollPhysics(),
                children: [
                  firstSheetContent(setState),
                  secondSheetContent(setState),
                  thirdSheetContent(setState),
                  fourthSheetContent(setState),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  firstSheetContent(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.eventTitle,
            style: poppins14CharcoalBlack400(),
          ),
          extraSmallHeight(),
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
          smallHeight(),
          Text(
            language.uploadFlyer,
            style: poppins14CharcoalBlack400(),
          ),
          extraSmallHeight(),
          GestureDetector(
            onTap: () {
              _getFromGallery(setState);
            },
            child: Container(
              height: 160,
              width: Get.width,
              decoration: BoxDecoration(
                  color: ColorConstants.colorFromHex("#FFFFFF"),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorConstants.colorFromHex("#C6CDD3"))),
              child: imageFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: 100,
                      color: ColorConstants.gray,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: ButtonTemplate(
              buttonName: language.next,
              buttonWidth: Get.width,
              buttonAction: () async {
                setState(() {
                  showBackButton = showBackButton + 1;
                });
                context.read<CreateEventProvider>().updateEvent(
                      name: titleController.text,
                      file: imageFile,
                    );
                _pageViewController.animateTo(
                  MediaQuery.of(context).size.width,
                  duration: new Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
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
            language.selectDate,
            style: poppins14CharcoalBlack400(),
          ),
          extraSmallHeight(),
          GestureDetector(
            onTap: () {
              if (isMenuOpen) {
                closeMenu();
              } else {
                openDateMenu(setState, _keyDate);
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
          smallHeight(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.startTime,
                      style: poppins14CharcoalBlack400(),
                    ),
                    extraSmallHeight(),
                    GestureDetector(
                      onTap: () {
                        if (isMenuOpen) {
                          closeMenu();
                        } else {
                          if (allDay) {
                          } else {
                            openStartTimeMenu(setState, _keyEndTime);
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
                                style: TextStyle(
                                  color: allDay
                                      ? ColorConstants.colorFromHex("#C6CDD3")
                                      : ColorConstants.black,
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
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.endTime,
                      style: poppins14CharcoalBlack400(),
                    ),
                    extraSmallHeight(),
                    GestureDetector(
                      onTap: () {
                        if (isMenuOpen) {
                          closeMenu();
                        } else {
                          if (allDay) {
                          } else {
                            openEndTimeMenu(setState, _keyStartTime);
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
                                style: TextStyle(
                                  color: allDay
                                      ? ColorConstants.colorFromHex("#C6CDD3")
                                      : ColorConstants.black,
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
          smallHeight(),
          Text(
            language.location,
            style: poppins14CharcoalBlack400(),
          ),
          Text(
            language.locationDescription,
            style: poppins12CharcoalBlack500(),
          ),
          extraSmallHeight(),
          TextFieldTemplate(
            hintText: 'eg. Club 250',
            controller: venueController,
            obscureText: false,
            width: Get.width,
            height: 50,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enabled: true,
            textFieldColor: Colors.white,
          ),
          SizedBox(
            height: 32,
          ),
          ButtonTemplate(
            buttonName: language.next,
            buttonWidth: Get.width,
            buttonAction: () {
              showBackButton = showBackButton + 1;
              context.read<CreateEventProvider>().updateEvent(
                    date: convertDateDashFormat(_selectedDay),
                    startTime: selectedStartTime.toString(),
                    endTime: selectedEndTime.toString(),
                    venue: venueController.text,
                  );
              _pageViewController.animateTo(
                MediaQuery.of(context).size.width * 2,
                duration: new Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
          ),
        ],
      ),
    );
  }

  thirdSheetContent(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.description,
            style: poppins14CharcoalBlack400(),
          ),
          Text(
            "Only 150 characters allowed",
            style: poppins12CharcoalBlack500(),
          ),
          extraSmallHeight(),
          TextFieldTemplate(
            hintText: '',
            controller: aboutController,
            obscureText: false,
            width: Get.width,
            height: 100,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enabled: true,
            textFieldColor: Colors.white,
            numberOfLines: 10,
            //maxLength: 250,
          ),
          smallHeight(),
          Text(
            "Category",
            style: poppins14CharcoalBlack400(),
          ),
          extraSmallHeight(),
          Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorConstants.gray,
                  width: 2,
                ),
                color: Colors.white),
            child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
              if (state is CategoryLoadingState) {
                return CircularProgressIndicator();
              }
              if (state is CategoryLoadedState) {
                List<CategoryModel> categories = state.categories;
                return DropdownButton<CategoryModel>(
                  value: selectedCategory, // Current selected value
                  hint: Text(
                    'Choose an item',
                    style: poppins14black500(),
                  ), // Hint text before selection
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  borderRadius: BorderRadius.circular(8),
                  isExpanded: true, // Make dropdown cover the width of parent
                  icon: Icon(Icons.arrow_drop_down),
                  underline: SizedBox.shrink(),
                  items: categories.map((CategoryModel category) {
                    return DropdownMenuItem<CategoryModel>(
                      value: category,
                      child: Text(
                        category.name,
                        style: poppins14black500(),
                      ),
                    );
                  }).toList(),
                  onChanged: (CategoryModel? newValue) {
                    setState(() {
                      selectedCategory = newValue; // Update the selected value
                    });
                  },
                );
              }
              if (state is CategoryErrorState) {
                return Center(
                    child: Text(
                  'Error loading categories',
                  style: poppins14black500(),
                ));
              }
              return Container();
            }),
          ),
          smallHeight(),
          GestureDetector(
            onTap: () {
              setState(() {
                publicEvent = !publicEvent;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.publicEvent,
                  style: poppins14CharcoalBlack400(),
                ),
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    color: ColorConstants.white,
                    border: Border.all(
                      color: ColorConstants.black,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        shape: BoxShape.rectangle,
                        color: publicEvent
                            ? ColorConstants.black
                            : ColorConstants.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ButtonTemplate(
              buttonName: language.next,
              buttonWidth: Get.width,
              buttonAction: () {
                setState(() {
                  showBackButton = showBackButton + 1;
                });
                context.read<CreateEventProvider>().updateEvent(
                      description: aboutController.text,
                      eventType: publicEvent ? "public" : "private",
                      category: selectedCategory!.id,
                    );
                _pageViewController.animateTo(
                  MediaQuery.of(context).size.width * 3,
                  duration: new Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  fourthSheetContent(StateSetter setState) {
    void _navigateAndSelectContacts() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactListScreen()),
      );

      if (result != null && result is List<ContactDetails>) {
        setState(() {
          selectedContacts = result;
        });
      }
    }

    return BlocConsumer<FileUploadBloc, FileUploadState>(
      listener: (context, state) {
        if (state is FileUploadSuccessState) {
          debugPrint("File uploaded successfully");

          context.read<CreateEventProvider>().updateEvent(
                image: state.fileName,
              );
          print(Provider.of<CreateEventProvider>(context, listen: false).event);
          BlocProvider.of<CreateEventBloc>(context).add(
            SubmitCreateEventEvent(
              image: state.fileName,
              name: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .name!,
              eventType:
                  Provider.of<CreateEventProvider>(context, listen: false)
                      .event
                      .eventType!,
              category: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .category!,
              description:
                  Provider.of<CreateEventProvider>(context, listen: false)
                      .event
                      .description!,
              date: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .date!,
              startTime:
                  Provider.of<CreateEventProvider>(context, listen: false)
                      .event
                      .startTime!,
              endTime: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .endTime!,
              venue: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .venue!,
              mapLocation:
                  Provider.of<CreateEventProvider>(context, listen: false)
                      .event
                      .mapLocation!,
              guests: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .guests!,
            ),
          );
        } else if (state is FileUploadFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File upload Failed: ${state.error}')),
          );

          print(state.error);
        }
      },
      builder: (context, fileUploadState) {
        return BlocConsumer<CreateEventBloc, CreateEventState>(
          listener: (context, state) {
            if (state is CreateEventSuccessful) {
              // Event creation was successful, display success message
              debugPrint("Event created successfully");
            } else if (state is CreateEventError) {
              // Event creation failed, display error message
              debugPrint("Event creation faled");
            }
          },
          builder: (context, eventState) {
            if (eventState is CreateEventLoading) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator during event creation
            }
            return Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20, right: 20, bottom: 40),
              child: selectedContacts.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _navigateAndSelectContacts();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: ColorConstants.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: ColorConstants.white,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          language.inviteFriends,
                          style: poppins13black400(),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 8,
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: selectedContacts.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ContactListItem(
                                    contactName: selectedContacts[index].name,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedContacts.removeAt(index);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonTemplate(
                                buttonName: "Add",
                                buttonWidth: width * 0.43,
                                buttonAction: () {
                                  _navigateAndSelectContacts();
                                },
                              ),
                              ButtonTemplate(
                                buttonName: "Finish",
                                buttonWidth: width * 0.43,
                                buttonAction: () {
                                  context
                                      .read<CreateEventProvider>()
                                      .updateEvent(
                                        guests: selectedContacts
                                            .map(
                                                (contact) => contact.telephone!)
                                            .toList(),
                                        mapLocation: "somewhere in Africa",
                                      );
                                  BlocProvider.of<FileUploadBloc>(context).add(
                                    FileUploadEvent(
                                      file: Provider.of<CreateEventProvider>(
                                              context,
                                              listen: false)
                                          .fileUpload
                                          .file!,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  startTimeDropDown(StateSetter setState, GlobalKey _key) {
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
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: selectedStartTimeChecker == index
                              ? ColorConstants.primary
                              : ColorConstants.colorFromHex("#AEB2BF"),
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
                          openStartTimeMenu(setState, _key);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: selectedStartTimeOfDayChecker == index
                                ? ColorConstants.primary
                                : ColorConstants.white,
                            border: Border.all(
                              color: selectedStartTimeOfDayChecker == index
                                  ? ColorConstants.primary
                                  : ColorConstants.colorFromHex("#AEB2BF"),
                            )),
                        child: Text(
                          eventTimeOfDay[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedStartTimeOfDayChecker == index
                                ? ColorConstants.white
                                : ColorConstants.colorFromHex("#AEB2BF"),
                            fontSize: 14,
                            fontFamily: "Poppins",
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

  endTimeDropDown(StateSetter setState, GlobalKey _key) {
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
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: selectedEndTimeChecker == index
                              ? ColorConstants.primary
                              : ColorConstants.colorFromHex("#AEB2BF"),
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
                          openEndTimeMenu(setState, _key);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: selectedEndTimeOfDayChecker == index
                                ? ColorConstants.primary
                                : ColorConstants.white,
                            border: Border.all(
                              color: selectedEndTimeOfDayChecker == index
                                  ? ColorConstants.primary
                                  : ColorConstants.colorFromHex("#AEB2BF"),
                            )),
                        child: Text(
                          eventTimeOfDay[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedEndTimeOfDayChecker == index
                                ? ColorConstants.white
                                : ColorConstants.colorFromHex("#AEB2BF"),
                            fontSize: 15,
                            fontFamily: "Poppins",
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
          fontFamily: "Popppins",
        ),
      ),
      daysOfWeekHeight: 24,
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: "Poppins",
          color: ColorConstants.colorFromHex("#0E1339"),
        ),
        weekendStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
          color: ColorConstants.colorFromHex("#0E1339"),
        ),
      ),
      calendarStyle: CalendarStyle(
        todayTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          color: ColorConstants.primary,
        ),
        withinRangeDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.colorFromHex("#F4F5FB"),
        ),
        defaultTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          color: ColorConstants.colorFromHex("#34405E"),
        ),
        outsideTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          color: ColorConstants.colorFromHex("#AEB2BF"),
        ),
        weekendTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins",
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
          color: ColorConstants.primaryLight,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.primary,
        ),
        selectedTextStyle: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins",
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
}
