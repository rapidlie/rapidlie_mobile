import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/event/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';

class InvitesScreen extends StatelessWidget {
  static const String routeName = "invites";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBarTemplate(
              pageTitle: "Invites",
              isSubPage: false,
            ),
          ),
          body: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              //controller: _scrollController,
              physics:
                  BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
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
                          Icon(
                            Icons.thumb_up,
                            color: Colors.grey.shade600,
                            size: 25,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Icon(
                            Icons.thumb_down,
                            color: Colors.grey.shade600,
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}
