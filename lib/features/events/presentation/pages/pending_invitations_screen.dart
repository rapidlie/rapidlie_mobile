import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/constants/strings.dart';
import 'package:rapidlie/core/utils/render_image.dart';
import 'package:rapidlie/core/utils/shared_peferences_manager.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/events/blocs/give_consent_bloc/consent_bloc.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:dio/dio.dart';

class PendingInvitationsScreen extends StatefulWidget {
  const PendingInvitationsScreen({Key? key}) : super(key: key);

  @override
  State<PendingInvitationsScreen> createState() =>
      _PendingInvitationsScreenState();
}

class _PendingInvitationsScreenState extends State<PendingInvitationsScreen> {
  List<EventDataModel> _events = [];
  bool _loading = true;
  String? _error;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = await UserPreferences().getBearerToken();
      final dio = Dio();
      final response = await dio.get(
        '$flockrAPIBaseUrl/events/invitations/pending',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );
      final list = response.data['data'] as List? ?? [];
      setState(() {
        _events = list
            .map((e) => EventDataModel.fromJson(e as Map<String, dynamic>))
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load invitations';
        _loading = false;
      });
    }
  }

  void _respond(String eventId, bool accept) {
    context.read<ConsentBloc>().add(GiveConsentEvent(
          eventId: eventId,
          status: accept ? 'accepted' : 'declined',
        ));
    setState(() {
      if (_currentIndex < _events.length - 1) {
        _currentIndex++;
      } else {
        _events = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: 'Pending Invitations',
          isSubPage: true,
          trailingWidget: _events.isNotEmpty
              ? Text(
                  '${_currentIndex + 1} of ${_events.length}',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                )
              : null,
        ),
      ),
      body: BlocListener<ConsentBloc, ConsentState>(
        listener: (context, state) {
          if (state is ConsentErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_events.isEmpty || _currentIndex >= _events.length) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text('All caught up!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('No pending invitations',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final event = _events[_currentIndex];
    final invitation = event.invitations.isNotEmpty
        ? event.invitations.first
        : null;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: _InvitationCard(
              event: event,
              onTap: () => context.pushNamed('event_details', extra: {
                'event': event,
                'isOwnEvent': false,
              }),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text('Decline',
                      style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: invitation != null
                      ? () => _respond(event.id, false)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Accept'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: invitation != null
                      ? () => _respond(event.id, true)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                if (_currentIndex < _events.length - 1) {
                  _currentIndex++;
                }
              });
            },
            child: const Text('Skip for now',
                style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final EventDataModel event;
  final VoidCallback onTap;
  const _InvitationCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.image != null)
              Expanded(
                flex: 3,
                child: RenderImage(
                  imageUrl: event.image!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Expanded(
                flex: 3,
                child: Container(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  child: Center(
                    child: Icon(Icons.event,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(event.date,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(event.venue,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: event.user?.avatar != null
                              ? NetworkImage(event.user!.avatar!)
                              : null,
                          child: event.user?.avatar == null
                              ? const Icon(Icons.person, size: 12)
                              : null,
                        ),
                        const SizedBox(width: 6),
                        Text('Invited by ${event.username}',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
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
