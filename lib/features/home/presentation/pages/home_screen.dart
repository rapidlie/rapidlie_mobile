import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/constants/color_constants.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/header_title_template.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/categories/presentation/category_screen.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';
import 'package:rapidlie/features/home/presentation/widgets/explore_categories_list_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  var language;
  String name = "";

  @override
  void initState() {
    //_scrollController.addListener(_updateScrollPhysics);
    getUserName();
    context.read<CategoryBloc>().add(FetchCategoriesEvent());
    super.initState();
  }

  void getUserName() async {
    name = UserPreferences().getUserName().toString().split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: language.hi + " " + name,
            isSubPage: false,
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: HeaderTextTemplate(
                    titleText: language.upcomingEvents,
                    titleTextColor: Colors.black,
                    containerColor: ColorConstants.gray,
                    textSize: 13,
                  ),
                ),
                verySmallHeight(),
                Container(
                  width: width,
                  height: height * 0.25,
                  child: ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          width: width * 0.85,
                          height: height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
                            color: const Color.fromARGB(255, 138, 81, 81),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                bigHeight(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HeaderTextTemplate(
                        titleText: language.explore,
                        titleTextColor: Colors.black,
                        containerColor: ColorConstants.gray,
                        textSize: 13,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            CategoryScreen.routeName,
                          );
                        },
                        child: Text(
                          language.seeAll,
                          style: TextStyle(
                            color: Color.fromARGB(133, 63, 59, 59),
                            fontFamily: "Poppins",
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verySmallHeight(),
                Container(
                    width: width,
                    height: 110,
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoadingState) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is CategoryLoadedState) {
                          return ListView.builder(
                            itemCount: state.categories.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 20),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return ExploreCategoryListTemplate(
                                categoryName: state.categories[index].name,
                                imageSrc: state.categories[index].image,
                              );
                            },
                          );
                        } else if (state is CategoryErrorState) {
                          return Center(
                              child: Text('Failed to load categories'));
                        }
                        return Center(child: Text('No categories found'));
                      },
                    )),
                bigHeight(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: HeaderTextTemplate(
                    titleText: language.discover,
                    titleTextColor: Colors.black,
                    containerColor: ColorConstants.gray,
                    textSize: 13,
                  ),
                ),
                verySmallHeight(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  //controller: _scrollController,
                  physics: BouncingScrollPhysics(
                      parent: BouncingScrollPhysics(
                    parent: NeverScrollableScrollPhysics(),
                  )),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => EventDetailsScreeen(isOwnEvent: false));
                        },
                        child: EventListTemplate(
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
                )
              ],
            ),
          ),
        ),
        /* floatingActionButton: GestureDetector(
          onTap: () {
            _scrollController.animateTo(
              0,
              duration:
                  Duration(milliseconds: 700), // You can adjust the duration
              curve: Curves.easeOut,
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              Icons.arrow_drop_up,
              color: Colors.white,
              size: 40,
            ),
          ),
        ), */
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
