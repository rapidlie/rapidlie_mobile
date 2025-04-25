import 'package:rapidlie/features/events/models/event_model.dart';

String getInviteStatus(List<EventDataModel> events, int index, userId) {
  String inviteStatus = events[index]
      .invitations
      .firstWhere(
        (invitation) => invitation.user.uuid == userId,
      )
      .status;

  return inviteStatus;
}
