import 'package:flutter/material.dart';

class UpcomingEventListTemplate extends StatelessWidget {
  final String eventName;
  final String eventLocation;
  final String eventDate;
  final String eventDay;
  final String? eventImageString;
  final String? eventId;

  const UpcomingEventListTemplate({
    Key? key,
    required this.eventName,
    required this.eventLocation,
    required this.eventDate,
    required this.eventDay,
    required this.eventImageString,
    this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.72,
        child: Stack(
          children: [
            // Background image or placeholder
            Positioned.fill(
              child: eventImageString != null && eventImageString!.isNotEmpty
                  ? Image.network(
                      eventImageString!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: primary.withValues(alpha: 0.12),
                        child: Icon(Icons.event, size: 48, color: primary),
                      ),
                    )
                  : Container(
                      color: primary.withValues(alpha: 0.12),
                      child: Icon(Icons.event, size: 48, color: primary),
                    ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
            ),
            // Text content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$eventDay · $eventDate',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      eventName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 11, color: Colors.white60),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            eventLocation,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
