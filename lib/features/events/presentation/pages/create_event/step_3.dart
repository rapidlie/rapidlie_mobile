import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String nameOfSelectedCategory = "";
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).inputDecorationTheme.fillColor,
      ),
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
                  style: inter14black500(context),
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
  void initState() {
    nameOfSelectedCategory = widget.language.selectCategory;
    super.initState();
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
            style: inter12Black400(context),
          ),
          Text(
            widget.language.characterLength,
            style: inter12Black400(context),
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
            widget.language.category + "*",
            style: inter12Black400(context),
          ),
          SizedBox(height: 8), // Assuming extraSmallHeight() is 8
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).inputDecorationTheme.fillColor,
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
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(nameOfSelectedCategory,
                                style: inter12Black500(context)),
                            Icon(
                              Icons.keyboard_arrow_down,
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
                      style: inter14black500(context),
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
                  style: inter12Black400(context),
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
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                        color: publicEvent
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
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
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ButtonTemplate(
                    buttonName: widget.language.previous,
                    buttonType: ButtonType.outlined,
                    buttonAction: () {
                      widget.pageViewController.previousPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                  flex: 6,
                  child: ButtonTemplate(
                    buttonName: widget.language.next,
                    buttonType: ButtonType.elevated,
                    buttonAction: () {
                      if (aboutController.text.isEmpty ||
                          idOfSelectedCategory == null) {
                        AppSnackbars.showError(
                          context,
                          widget.language.requiredFields,
                        );
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
          ),
        ],
      ),
    );
  }
}
