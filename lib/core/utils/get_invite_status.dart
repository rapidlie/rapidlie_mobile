import 'package:rapidlie/features/events/models/event_model.dart';

String getInviteStatus(EventDataModel events, userId) {
  if (events.invitations.isEmpty) {
    return "pending";
  }

  if (events.user!.uuid == userId) {
    return "accepted";
  }

  final match = events.invitations
      .where((invitation) => invitation.user.uuid == userId)
      .toList();

  return match.isNotEmpty ? match.first.status : 'pending';
}
