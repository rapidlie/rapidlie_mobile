import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/events/bloc/event_bloc.dart';
import 'package:rapidlie/features/events/presentation/pages/event_details_screen.dart';
import 'package:rapidlie/features/home/presentation/widgets/event_list_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class InvitesScreen extends StatefulWidget {
  static const String routeName = "invites";

  @override
  State<InvitesScreen> createState() => _InvitesScreenState();
}

class _InvitesScreenState extends State<InvitesScreen> {
  var language;

  @override
  void initState() {
    context.read<EventBloc>().add(GetPrivateEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBarTemplate(
              pageTitle: language.invites,
              isSubPage: false,
            ),
          ),
          body: SingleChildScrollView(
            child:
                BlocBuilder<EventBloc, EventState>(builder: (context, state) {
              if (state is InitialEventState) {
                return Text(
                  "No invites",
                  textAlign: TextAlign.center,
                  style: poppins13black400(),
                );
              } else if (state is EventLoading) {
                return Center(child: CupertinoActivityIndicator());
              }
              if (state is EventLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  //controller: _scrollController,
                  physics: BouncingScrollPhysics(
                      parent: NeverScrollableScrollPhysics()),
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
                );
              }
              return Container();
            }),
          )),
    );
  }
}
