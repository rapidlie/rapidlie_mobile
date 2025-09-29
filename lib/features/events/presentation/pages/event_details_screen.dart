import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_stack/image_stack.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/date_formatters.dart';
import 'package:rapidlie/core/utils/get_invite_status.dart';
import 'package:rapidlie/core/utils/render_image.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/header_title_template.dart';
import 'package:rapidlie/features/events/blocs/event_detail_bloc/event_detail_bloc.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/blocs/give_consent_bloc/consent_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/events/presentation/pages/map_direction_launcher.dart';
import 'package:rapidlie/features/events/repository/event_detail_respository.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

// The screen now only needs the eventId to fetch its own data.
class EventDetailsScreen extends StatelessWidget {
  final bool isOwnEvent;
  final String eventId;

  const EventDetailsScreen({
    Key? key,
    required this.isOwnEvent,
    required this.eventId,
  }) : super(key: key);

  static EventDetailsScreen fromState(GoRouterState state) {
    final data = state.extra as Map<String, dynamic>;

    return EventDetailsScreen(
      eventId: data['eventId'] as String,
      isOwnEvent: data['isOwnEvent'] as bool,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide the EventDetailBloc here.
      // This makes the bloc available to all child widgets.
      create: (context) => EventDetailBloc(
        eventdetailRepository: context.read<EventDetailRepository>(),
      )..add(GetEventDetail(eventId)), // Trigger initial data fetch
      child: Scaffold(
        body: BlocBuilder<EventDetailBloc, EventDetailState>(
          // Correctly specify the BLoC and State types here.

          builder: (context, state) {
            if (state is EventDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventDetailLoaded) {
              final eventDetail = state.events;
              final userId = UserPreferences().getUserId().toString();
              final inviteStatus = getInviteStatus(eventDetail, userId);

              return _EventDetailsBody(
                event: eventDetail,
                isOwnEvent: isOwnEvent,
                inviteStatus: inviteStatus,
              );
            } else if (state is EventDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox(); // Initial state or unknown state
          },
        ),
      ),
    );
  }
}

// A new widget to build the main body of the screen,
// separate from the BLoC logic.
class _EventDetailsBody extends StatelessWidget {
  final EventDataModel event;
  final bool isOwnEvent;
  final String? inviteStatus;

  const _EventDetailsBody({
    Key? key,
    required this.event,
    required this.isOwnEvent,
    required this.inviteStatus,
  }) : super(key: key);

  LatLng _extractLatLngFromString(String latLngString) {
    final regex = RegExp(r"LatLng\(([^,]+), ([^)]+)\)");
    final match = regex.firstMatch(latLngString);
    if (match != null) {
      double latitude = double.parse(match.group(1)!);
      double longitude = double.parse(match.group(2)!);
      return LatLng(latitude, longitude);
    }
    return const LatLng(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);
    final userImages = event.invitations
        .map((invite) => invite.user.avatar ?? "assets/images/placeholder.png")
        .toList();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final initialPosition = _extractLatLngFromString(event.mapLocation);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CustomColors.lightGray,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.name, style: inter16Black600(context)),
                              HeaderTextTemplate(
                                titleText: event.category.name,
                                titleTextColor:
                                    Theme.of(context).colorScheme.onSurface,
                                textSize: 8,
                                verticalPadding: 5,
                                horizontalPadding: 10,
                                containerColor: Colors.grey.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              centerTitle: false,
              backgroundColor: Theme.of(context).colorScheme.surface,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: RenderImage(imageUrl: event.image!),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(language.date,
                                      style: inter12Black600(context)),
                                  extraSmallHeight(),
                                  Text(
                                    convertDateDotFormat(
                                        DateTime.parse(event.date)),
                                    style: inter10Black400(context),
                                  ),
                                  Text(
                                    getDayName(event.date),
                                    style: inter10Black400(context),
                                  ),
                                ],
                              ),
                              Container(
                                height: 20,
                                width: 1,
                                color: CustomColors.lightGray,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(language.time,
                                      style: inter12Black600(context)),
                                  extraSmallHeight(),
                                  Row(
                                    children: [
                                      Text(
                                        event.startTime,
                                        style: inter10Black400(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: 20,
                                width: 1,
                                color: CustomColors.lightGray,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(language.venue,
                                      style: inter12Black600(context)),
                                  extraSmallHeight(),
                                  Text(
                                    event.venue.split(",").first,
                                    style: inter10Black400(context),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      smallHeight(),
                      Text(language.description,
                          style: inter14black600(context)),
                      Text(
                        event.description,
                        style: inter12black400(context),
                      ),
                      normalHeight(),
                      Text(language.directions,
                          style: inter14black600(context)),
                      MapDirectionLauncher(
                        targetLocation: initialPosition,
                      ),
                      normalHeight(),
                      if (event.eventType == "private")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(language.invites,
                                style: inter14black600(context)),
                            !isOwnEvent
                                ? SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                        'flockr_contacts',
                                        extra: event.id,
                                      );
                                    },
                                    child: HeaderTextTemplate(
                                      titleText: language.add,
                                      titleTextColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      textSize: 10.sp,
                                      containerColor:
                                          Colors.grey.withOpacity(0.3),
                                    ),
                                  ),
                          ],
                        ),
                      extraSmallHeight(),
                      GestureDetector(
                        onTap: () {
                          context.push(
                            '/guest_list',
                            extra: event.invitations,
                          );
                        },
                        child: ImageStack(
                          imageList: userImages,
                          imageRadius: 50,
                          showTotalCount: false,
                          imageBorderWidth: 2,
                          imageCount: userImages.length,
                          imageBorderColor: Colors.white,
                          backgroundColor: Colors.grey,
                          extraCountBorderColor: Colors.grey,
                          totalCount: userImages.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20.0,
          left: 20.0,
          right: 20.0,
          child: isOwnEvent || event.eventType == "public"
              ? const SizedBox.shrink()
              : _ConsentButtons(
                  event: event,
                  inviteStatus: inviteStatus,
                ),
        ),
      ],
    );
  }
}

class _ConsentButtons extends StatelessWidget {
  final EventDataModel event;
  final String? inviteStatus;

  const _ConsentButtons({
    Key? key,
    required this.event,
    required this.inviteStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsentBloc, ConsentState>(
      listener: (context, state) {
        if (state is ConsentLoadedState) {
          context.read<EventDetailBloc>().add(GetEventDetail(event.id));

          context.read<InvitedEventBloc>().add(GetInvitedEvents());
          context.read<UpcomingEventBloc>().add(GetUpcomingEvents());
          context.read<PublicEventBloc>().add(GetPublicEvents());
          context.read<PrivateEventBloc>().add(GetPrivateEvents());
          context.read<ConsentBloc>().add(ResetGiveConsentEvent());
        }
      },
      builder: (context, state) {
        bool isAnyButtonLoading = state is ConsentLoadingState;
        String? currentInviteStatus = inviteStatus;
        if (state is ConsentLoadedState) {
          currentInviteStatus = state.message;
        }

        if (currentInviteStatus == "pending") {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: isAnyButtonLoading
                        ? null
                        : () {
                            context.read<ConsentBloc>().add(GiveConsentEvent(
                                  status: "declined",
                                  eventId: event.id,
                                ));
                          },
                    child: isAnyButtonLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Decline"),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(185, 165, 165, 165),
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Colors.white,
                      ),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: isAnyButtonLoading
                        ? null
                        : () {
                            context.read<ConsentBloc>().add(GiveConsentEvent(
                                  status: "accepted",
                                  eventId: event.id,
                                ));
                          },
                    child: isAnyButtonLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Accept"),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        CustomColors.acceptButtonColor,
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Colors.white,
                      ),
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: isAnyButtonLoading
                  ? null
                  : () {
                      context.read<ConsentBloc>().add(GiveConsentEvent(
                            status: currentInviteStatus == "accepted"
                                ? 'declined'
                                : 'accepted',
                            eventId: event.id,
                          ));
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    currentInviteStatus == "declined"
                        ? Icons.thumb_down
                        : Icons.thumb_up,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    currentInviteStatus == "declined"
                        ? "Declined"
                        : "You're going",
                  ),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  currentInviteStatus == "declined"
                      ? Colors.red
                      : CustomColors.acceptButtonColor,
                ),
                foregroundColor: WidgetStateProperty.all<Color>(
                  Colors.white,
                ),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
