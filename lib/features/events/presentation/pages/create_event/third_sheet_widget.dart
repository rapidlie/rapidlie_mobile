import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/categories/models/category_model.dart';
import 'package:rapidlie/features/events/presentation/widgets/overlay_utils.dart';
import 'package:rapidlie/features/events/provider/create_event_provider.dart';

class ThirdSheetContentWidget extends StatefulWidget {
  final dynamic language;
  final PageController pageViewController;

  ThirdSheetContentWidget({
    required this.language,
    required this.pageViewController,
  });

  @override
  _ThirdSheetContentWidgetState createState() =>
      _ThirdSheetContentWidgetState();
}

class _ThirdSheetContentWidgetState extends State<ThirdSheetContentWidget> {
  TextEditingController aboutController = TextEditingController();
  bool publicEvent = false;
  String nameOfSelectedCategory = "Select Category";
  String? idOfSelectedCategory;
  bool isMenuOpen = false;
  final GlobalKey _keyCategory = GlobalKey();

  late Offset buttonPosition;
  late Size buttonSize;
  OverlayEntry? _overlayEntry;

  // ... (Your other methods like openCategoryMenu, closeMenu, etc.)
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

  categoryDropDown(GlobalKey _key, List<CategoryModel> categoryList) {
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

  void openCategoryMenu(GlobalKey _key, List<CategoryModel> categoryList) {
    findButton(_key);
    _overlayEntry = OverlayUtils.createOverlayEntry(
        categoryDropDown(_key, categoryList),
        buttonPosition,
        buttonSize,
        buttonPosition.dx,
        buttonSize.width,
        null);
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
            widget.language.description + '*',
            style: inter14CharcoalBlack400(),
          ),
          Text(
            "Only 150 characters allowed",
            style: inter12CharcoalBlack500(),
          ),
          SizedBox(height: 8), // Assuming extraSmallHeight() is 8
          TextFieldTemplate(
            hintText: '',
            controller: aboutController,
            obscureText: false,
            width: MediaQuery.of(context).size.width,
            height: 100,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enabled: true,
            textFieldColor: Colors.white,
            numberOfLines: 10,
          ),
          SizedBox(height: 16), // Assuming smallHeight() is 16
          Text(
            "Category*",
            style: inter14CharcoalBlack400(),
          ),
          SizedBox(height: 8), // Assuming extraSmallHeight() is 8
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CustomColors.gray,
                width: 2,
              ),
              color: Colors.white,
            ),
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is CategoryLoadedState) {
                  List<CategoryModel> categories = state.categories;
                  return GestureDetector(
                    onTap: () {
                      if (isMenuOpen) {
                        closeMenu();
                      } else {
                        openCategoryMenu(
                            _keyCategory, categories); // Passing setState
                      }
                    },
                    child: Container(
                      key: _keyCategory,
                      width: MediaQuery.of(context).size.width,
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
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          SizedBox(height: 16), // Assuming smallHeight() is 16
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
                  widget.language.publicEvent,
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
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ButtonTemplate(
              buttonName: widget.language.next,
              buttonWidth: MediaQuery.of(context).size.width,
              buttonAction: () {
                if (aboutController.text.isEmpty ||
                    idOfSelectedCategory == null) {
                  AppSnackbars.showError(context, "All fields are required!");
                } else {
                  setState(() {});
                  context.read<CreateEventProvider>().updateEvent(
                        description: aboutController.text,
                        eventType: publicEvent ? "public" : "private",
                        category: idOfSelectedCategory,
                      );
                  widget.pageViewController.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
