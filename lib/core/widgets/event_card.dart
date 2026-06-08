import 'package:flutter/material.dart';
import 'package:rapidlie/core/utils/render_image.dart';

class EventCard extends StatelessWidget {
  final String eventName;
  final String? eventImageString;
  final String eventDate;
  final String eventDay;
  final String? eventId;
  final bool hasLikedEvent;
  final String inviteStatus;
  final bool showStatusBadge;

  final bool showOwnerInfo;
  final String? eventOwner;
  final String? eventOwnerAvatar;
  final String? eventLocation;

  const EventCard({
    Key? key,
    required this.eventName,
    this.eventImageString,
    required this.eventDate,
    required this.eventDay,
    this.eventId,
    required this.hasLikedEvent,
    required this.inviteStatus,
    required this.showStatusBadge,
    this.showOwnerInfo = false,
    this.eventOwner,
    this.eventOwnerAvatar,
    this.eventLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showOwnerInfo) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: (eventOwnerAvatar != null &&
                          eventOwnerAvatar!.isNotEmpty)
                      ? NetworkImage(eventOwnerAvatar!)
                      : null,
                  backgroundColor: primary.withValues(alpha: 0.1),
                  child: (eventOwnerAvatar == null || eventOwnerAvatar!.isEmpty)
                      ? Icon(Icons.person, size: 18, color: primary)
                      : null,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventOwner ?? '',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (eventLocation != null && eventLocation!.isNotEmpty)
                      Text(
                        eventLocation!,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.outline),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: eventImageString != null && eventImageString!.isNotEmpty
                  ? RenderImage(
                      imageUrl: eventImageString!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: primary.withValues(alpha: 0.08),
                      child: Icon(Icons.event, size: 48, color: primary),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventName,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          eventDay,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.outline),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Container(
                            width: 1,
                            height: 10,
                            color: primary,
                          ),
                        ),
                        Text(
                          eventDate,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showStatusBadge) ...[
                const SizedBox(width: 8),
                _StatusBadge(status: inviteStatus),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;

    switch (status) {
      case 'accepted':
        bg = Colors.green.withValues(alpha: 0.12);
        fg = Colors.green.shade700;
        label = 'GOING';
        break;
      case 'declined':
        bg = Colors.red.withValues(alpha: 0.12);
        fg = Colors.red.shade700;
        label = 'DECLINED';
        break;
      default:
        bg = Theme.of(context).colorScheme.surfaceContainerHighest;
        fg = Theme.of(context).colorScheme.outline;
        label = 'PENDING';
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
