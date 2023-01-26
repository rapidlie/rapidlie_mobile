import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/components/button_template.dart';
import 'package:rapidlie/components/text_field_template.dart';
import 'package:rapidlie/constants/color_constants.dart';

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
  late GlobalKey _key;
  bool isMenuOpen = false;
  late Offset buttonPosition;
  late Size buttonSize;
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    _pageViewController = PageController();
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  findButton() {
    RenderBox? renderBox =
        _key.currentContext!.findRenderObject() as RenderBox?;
    buttonSize = renderBox!.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder() {
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
                height: 200,
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(),
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
                    onTap: () => Get.back(),
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
              buttonName: "Next",
              buttonColor: ColorConstants.primary,
              buttonWidth: Get.width,
              buttonHeight: 50,
              buttonAction: () {},
              fontColor: Colors.white,
              textSize: 10,
              buttonBorderRadius: 10,
            ),
          )
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
                openMenu();
              }
              //dateController.text = 'Hello';
            },
            child: Container(
              key: _key,
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
                      dateText,
                      style: TextStyle(
                        color: ColorConstants.hintTextColor,
                        fontSize: 14.0,
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
            height: 100,
          )
        ],
      ),
    );
  }
}
