import 'package:rapidlie/features/events/models/event_model.dart';

String getInviteStatus(EventDataModel events, userId) {
  if (events.invitations.isEmpty) {
    return "pending";
  }

  if (events.user!.uuid == userId) {
    return "accepted";
  }

  String inviteStatus = events
      .invitations
      .firstWhere(
        (invitation) => invitation.user.uuid == userId,
      )
      .status;

  return inviteStatus;
}
