import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/get_invite_status.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/animations.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/event_card.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class EventsScreen extends StatefulWidget {
  static const String routeName = "events";

  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late PageController _pageViewController;
  late String userId;

  @override
  void initState() {
    _pageViewController = PageController();
    getUserID();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PrivateEventBloc>().add(GetPrivateEvents());
      }
    });
    super.initState();
  }

  void getUserID() async {
    userId = UserPreferences().getUserId().toString();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    context.read<PrivateEventBloc>().add(GetPrivateEvents());
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.myEvents,
          isSubPage: false,
        ),
      ),
      resizeToAvoidBottomInset: true,
      floatingActionButton: floatingActionButton(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: BlocBuilder<PrivateEventBloc, EventListState>(
              builder: (context, state) {
                if (state is EventListInitial || state is EventListLoading) {
                  return _buildShimmer(height, width);
                } else if (state is EventListLoaded) {
                  return buildBody(
                      state.events.reversed.toList(), width, height);
                }
                return _buildShimmer(height, width);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: List.generate(
            3,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: double.infinity,
                    height: (width - 32) * 9 / 16,
                    borderRadius: 16,
                  ),
                  SizedBox(height: 10.h),
                  ShimmerBox(
                    width: 200.w,
                    height: 16.h,
                    borderRadius: 8,
                  ),
                  SizedBox(height: 6.h),
                  ShimmerBox(
                    width: 120.w,
                    height: 12.h,
                    borderRadius: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 80.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_outlined,
              size: 64.sp,
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: 16.h),
            Text(
              'No events yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Create your first event',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody(List<EventDataModel> eventDataModel, width, height) {
    return SizedBox(
      height: height,
      width: width,
      child: eventDataModel.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.only(bottom: 200.0),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 70),
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                itemCount: eventDataModel.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      bool isOwnEvent =
                          eventDataModel[index].user!.uuid == userId;
                      context.pushNamed(
                        'event_details',
                        extra: {
                          'eventId': eventDataModel[index].id,
                          'isOwnEvent': isOwnEvent,
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: EventCard(
                        eventName: eventDataModel[index].name,
                        eventImageString: eventDataModel[index].image,
                        eventDay: getDayName(eventDataModel[index].date),
                        eventDate: convertDateDotFormat(
                          DateTime.parse(eventDataModel[index].date),
                        ),
                        eventId: eventDataModel[index].id,
                        hasLikedEvent: eventDataModel[index].hasLikedEvent,
                        inviteStatus:
                            getInviteStatus(eventDataModel[index], userId),
                        showStatusBadge: false,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget floatingActionButton() {
    return GestureDetector(
      onTap: () => context.pushNamed('create_event'),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 30,
        ),
      ),
    );
  }

  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      return null;
    }
  }
}
