import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/autocomplete_predictions.dart';
import 'package:rapidlie/core/utils/autocomplete_response.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/getUserCurrentLocation.dart';
import 'package:rapidlie/core/utils/network_utility.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/epmty_list_view.dart';
import 'package:rapidlie/core/widgets/general_event_list_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/categories/models/category_model.dart';
import 'package:rapidlie/features/contacts/models/contact_details.dart';
import 'package:rapidlie/features/contacts/presentation/pages/contact_list_screen.dart';
import 'package:rapidlie/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:rapidlie/features/events/blocs/create_bloc/create_event_bloc.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_bloc.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_state.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/events/provider/create_event_provider.dart';
import 'package:rapidlie/features/file_upload/bloc/file_upload_bloc.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsScreen extends StatefulWidget {
  static const String routeName = "events";

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with AutomaticKeepAliveClientMixin {
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
  late GlobalKey _keyCategory;
  bool isMenuOpen = false;
  late Offset buttonPosition;
  late Size buttonSize;
  OverlayEntry? _overlayEntry;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
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
  String? idOfSelectedCategory;
  String nameOfSelectedCategory = "Select category";
  List<AutocompletePrediction> predictionList = [];
  LatLng latLngOfUserLocation = LatLng(0.0, 0.0);
  String mapId = "";
  bool locationVisibility = false;

  @override
  void initState() {
    _pageViewController = PageController(keepPage: false);
    _keyDate = LabeledGlobalKey("button_icon");
    _keyStartTime = LabeledGlobalKey("button_icon");
    _keyEndTime = LabeledGlobalKey("button_icon");
    _keyCategory = LabeledGlobalKey("button_icon");
    final bloc = context.read<PrivateEventBloc>();
    if (bloc.state is! PrivateEventLoaded) {
      bloc.add(GetPrivateEvents());
    }
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void clearFields() {
    titleController.dispose();
    dateController.dispose();
    locationController.dispose();
    venueController.dispose();
    aboutController.dispose();
    imageFile = null;
    mapId = "";
    latLngOfUserLocation = LatLng(0.0, 0.0);
    selectedStartTime = '00:00 am';
    selectedEndTime = '00:00 pm';
    selectedContacts = [];
    showBackButton = 0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        floatingActionButton: buttonToShowModal(),
        body: SingleChildScrollView(
          child: BlocListener<LikeEventBloc, LikeEventState>(
            listener: (context, state) {
              if (state is LikeEventLoaded) {
                context
                    .read<PrivateEventBloc>()
                    .add(GetPrivateEvents()); // Reload specific events
              }
            },
            child: BlocBuilder<PrivateEventBloc, PrivateEventState>(
              builder: (context, state) {
                if (state is InitialPrivateEventState) {
                  return emptyStateFullView(
                    headerText: "No events",
                    bodyText:
                        "Get started by hitting the button on the bottom right corner of your screen. It is easy",
                  );
                } else if (state is PrivateEventLoading) {
                  return Center(child: CupertinoActivityIndicator());
                } else if (state is PrivateEventLoaded) {
                  return buildBody(state.events);
                }
                return Center(
                    child: Text(
                  "Empty",
                  style: TextStyle(fontSize: 30),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }

  Container buildBody(List<EventDataModel> eventDataModel) {
    return Container(
      height: height,
      width: width,
      child: eventDataModel.length == 0
          ? emptyStateFullView(
              headerText: "No events",
              bodyText:
                  "Get started by hitting the button on the bottom right corner of your screen. It is easy",
            )
          : ListView.builder(
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
                        DateTime.parse(eventDataModel[index].date),
                      ),
                      eventId: eventDataModel[index].id,
                      hasLikedEvent: eventDataModel[index].hasLikedEvent,
                    ),
                  ),
                );
              },
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
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      primary: true,
                      child: GestureDetector(
                        onTap: () => closeMenu(),
                        child: bottomSheetLayout(setState),
                      ),
                    ),
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

  void openCategoryMenu(
      StateSetter setState, GlobalKey _key, List<CategoryModel> categoryList) {
    findButton(_key);
    _overlayEntry = _overlayEntryBuilder(
        categoryDropDown(setState, _key, categoryList),
        buttonPosition.dx,
        buttonSize.width,
        null);
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
                  color: CustomColors.white,
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
        maxWidth: Get.width,
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
        color: CustomColors.colorFromHex("#F2F4F5"),
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
                    child: showBackButton > 0 && showBackButton < 4
                        ? Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColors.colorFromHex("#FFFFFF"),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: CustomColors.closeButtonColor,
                              size: 20,
                            ),
                          )
                        : SizedBox(
                            width: 10,
                          ),
                  ),
                  Text(
                    language.createEvent,
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: CustomColors.charcoalBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  showBackButton > 3
                      ? SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            //clearFields();
                            Get.back();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColors.colorFromHex("#FFFFFF"),
                            ),
                            child: Icon(
                              Icons.close,
                              color: CustomColors.closeButtonColor,
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
                color: CustomColors.lightGray,
                height: 1,
                width: Get.width,
              ),
            ),
            SizedBox(
              height: 520,
              child: PageView(
                controller: _pageViewController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  firstSheetContent(setState),
                  secondSheetContent(setState),
                  thirdSheetContent(setState),
                  fourthSheetContent(setState),
                  fifthSheetContent(setState),
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
            style: inter12CharcoalBlack400(),
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
            style: inter12CharcoalBlack400(),
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
                  color: CustomColors.colorFromHex("#FFFFFF"),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: CustomColors.colorFromHex("#C6CDD3"))),
              child: imageFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: 100,
                      color: CustomColors.gray,
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
    void placeAutoComplete(String query) async {
      Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {"input": query, "key": dotenv.get("API_KEY")},
      );
      String? response = await NetworkUtility.fetchUrl(uri);
      if (response != null) {
        PlaceAutocompleteResponse result =
            PlaceAutocompleteResponse.parseAutocompleteResult(response);
        if (result.predictions != null) {
          setState(() {
            predictionList = result.predictions!;
          });
        }
      }
    }

    Future<void> getLatLong(String placeId) async {
      Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/details/json",
        {"place_id": placeId, "key": dotenv.get("API_KEY")},
      );
      String? response = await NetworkUtility.fetchUrl(uri);
      if (response != null) {
        final Map<String, dynamic> data = json.decode(response);
        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          setState(() {
            latLngOfUserLocation = LatLng(location['lat'], location['lng']);
          });
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.selectDate,
            style: inter12CharcoalBlack400(),
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
                      language.startTime,
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
                      language.endTime,
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
            language.location,
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
            onChanged: (value) {
              placeAutoComplete(value);
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
                      await getLatLong(predictionList[index].placeId!);
                      setState(
                        () {
                          venueController.text =
                              predictionList[index].description!;
                          mapId = latLngOfUserLocation.toString();
                          print("map id is $mapId");
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
            buttonName: language.next,
            buttonWidth: Get.width,
            buttonAction: () {
              showBackButton = showBackButton + 1;
              context.read<CreateEventProvider>().updateEvent(
                    date: convertDateDashFormat(_selectedDay),
                    startTime: selectedStartTime.toString(),
                    endTime: selectedEndTime.toString(),
                    venue: venueController.text,
                    mapLocation: mapId,
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
            style: inter14CharcoalBlack400(),
          ),
          Text(
            "Only 150 characters allowed",
            style: inter12CharcoalBlack500(),
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
            style: inter14CharcoalBlack400(),
          ),
          extraSmallHeight(),
          Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: CustomColors.gray,
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
                return GestureDetector(
                  onTap: () {
                    if (isMenuOpen) {
                      closeMenu();
                    } else {
                      openCategoryMenu(setState, _keyCategory, categories);
                    }
                  },
                  child: Container(
                    key: _keyCategory,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            nameOfSelectedCategory,
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
                  style: inter14CharcoalBlack400(),
                ),
                Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    color: CustomColors.white,
                    border: Border.all(
                      color: CustomColors.black,
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
                            ? CustomColors.black
                            : CustomColors.white,
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
                print(idOfSelectedCategory);
                setState(() {
                  showBackButton = showBackButton + 1;
                });
                context.read<CreateEventProvider>().updateEvent(
                      description: aboutController.text,
                      eventType: publicEvent ? "public" : "private",
                      category: idOfSelectedCategory,
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
          /* ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File upload Failed: ${state.error}')),
          ); */

          print(state.error);
        } else if (state is FileUploadInitial) {
          print("process started");
        } else if (state is FileUploadingState) {
          print("process loading");
        }
      },
      builder: (context, fileUploadState) {
        return BlocConsumer<CreateEventBloc, CreateEventState>(
          listener: (context, state) {
            if (state is CreateEventSuccessful) {
            } else if (state is CreateEventError) {}
          },
          builder: (context, eventState) {
            if (eventState is CreateEventLoading) {
              print("Event creation loading....");
              return Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator during event creation
            } else if (eventState is CreateEventSuccessful) {
              _pageViewController.animateTo(
                MediaQuery.of(context).size.width * 4,
                duration: new Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
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
                              color: CustomColors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: CustomColors.white,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: ButtonTemplate(
                                buttonName: "+",
                                buttonWidth: width,
                                buttonAction: () {
                                  _navigateAndSelectContacts();
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              flex: 8,
                              child: ButtonTemplate(
                                buttonName: "Finish",
                                buttonWidth: width,
                                buttonAction: () {
                                  setState(() {
                                    showBackButton += 1;
                                  });
                                  context
                                      .read<CreateEventProvider>()
                                      .updateEvent(
                                        guests: selectedContacts
                                            .map(
                                                (contact) => contact.telephone!)
                                            .toList(),
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
                            ),
                          ],
                        )
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  fifthSheetContent(StateSetter setState) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      builder: (context, state) {
        if (state is CreateEventLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CreateEventSuccessful) {
          Future.delayed(Duration(seconds: 3), () {
            Get.back();
          });
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/success_view.png"),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "You did it!!",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/failed_view.png"),
              SizedBox(
                height: 20,
              ),
              Text(
                "Oops.. Something went wrong. Please try again",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
                          openStartTimeMenu(setState, _key);
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
                                  ? CustomColors.primary
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

  categoryDropDown(
      StateSetter setState, GlobalKey _key, List<CategoryModel> categoryList) {
    return Container(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
        child: ListView.builder(
          //shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                idOfSelectedCategory = categoryList[index].id;
                setState(() {
                  nameOfSelectedCategory = categoryList[index].name;
                });
                closeMenu();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  categoryList[index].name,
                  style: poppins14black500(),
                ),
              ),
            );
          },
        ),
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
                          openEndTimeMenu(setState, _key);
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
                                  ? CustomColors.primary
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
        return isSameDay(_selectedDay, day);
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
