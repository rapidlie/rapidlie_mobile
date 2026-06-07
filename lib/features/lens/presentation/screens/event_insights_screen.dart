import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/features/lens/blocs/lens_bloc/lens_bloc.dart';
import 'package:rapidlie/features/lens/data/models/lens_model.dart';

class EventInsightsScreen extends StatefulWidget {
  final String eventId;
  const EventInsightsScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventInsightsScreen> createState() => _EventInsightsScreenState();
}

class _EventInsightsScreenState extends State<EventInsightsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LensBloc>().add(FetchInsights(widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Insights'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<LensBloc, LensState>(
        builder: (context, state) {
          if (state is LensLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LensError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<LensBloc>()
                        .add(FetchInsights(widget.eventId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is LensLoaded) {
            return _InsightsDashboard(insights: state.insights);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

Color _scoreColor(String score) {
  switch (score) {
    case 'Excellent':
      return Colors.green;
    case 'Good':
      return Colors.blue;
    case 'Average':
      return Colors.orange;
    default:
      return Colors.red;
  }
}

class _InsightsDashboard extends StatelessWidget {
  final LensModel insights;
  const _InsightsDashboard({required this.insights});

  @override
  Widget build(BuildContext context) {
    final att = insights.attendance;
    final eng = insights.engagement;
    final con = insights.contributions;
    final reels = insights.reels;
    final polls = insights.polls;

    final scoreColor = _scoreColor(eng.engagementScore);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(insights.eventName,
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 18.sp)),
          const SizedBox(height: 16),

          // Attendance card
          _SectionCard(
            title: 'Attendance',
            child: Column(
              children: [
                _AttendanceBar(
                  accepted: att.accepted,
                  declined: att.declined,
                  pending: att.pending,
                  total: att.totalInvited,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatBadge(
                        label: 'Invited',
                        value: '${att.totalInvited}',
                        color: Colors.grey),
                    _StatBadge(
                        label: 'Accepted',
                        value: '${att.accepted}',
                        color: Colors.green),
                    _StatBadge(
                        label: 'Declined',
                        value: '${att.declined}',
                        color: Colors.red),
                    _StatBadge(
                        label: 'Pending',
                        value: '${att.pending}',
                        color: Colors.orange),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Attendance rate: ${att.attendanceRate}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13.sp),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Engagement card
          _SectionCard(
            title: 'Engagement',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatBadge(
                    label: 'Likes',
                    value: '${eng.likes}',
                    color: Colors.red),
                _StatBadge(
                    label: 'Bookmarks',
                    value: '${eng.bookmarks}',
                    color: Theme.of(context).colorScheme.primary),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: scoreColor.withValues(alpha: 0.15),
                      ),
                      child: Text(
                        eng.engagementScore,
                        style: TextStyle(
                            color: scoreColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Score',
                        style:
                            TextStyle(color: Colors.grey, fontSize: 11.sp)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Contributions card
          _SectionCard(
            title: 'Contributions',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatBadge(
                        label: 'Total',
                        value:
                            '${con.currency} ${con.totalAmount.toStringAsFixed(2)}',
                        color: Colors.green),
                    _StatBadge(
                        label: 'Contributors',
                        value: '${con.contributors}',
                        color: Colors.blue),
                  ],
                ),
                if (con.topContributors.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('Top Contributors',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13.sp)),
                  const SizedBox(height: 6),
                  ...con.topContributors.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(c.name),
                            Text(
                              '${con.currency} ${c.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Reels & Polls row
          Row(
            children: [
              Expanded(
                child: _SectionCard(
                  title: 'Moments',
                  child: Column(
                    children: [
                      _StatBadge(
                          label: 'Reels',
                          value: '${reels.count}',
                          color: Colors.purple),
                      const SizedBox(height: 4),
                      _StatBadge(
                          label: 'Likes',
                          value: '${reels.totalLikes}',
                          color: Colors.red),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SectionCard(
                  title: 'Polls',
                  child: Column(
                    children: [
                      _StatBadge(
                          label: 'Polls',
                          value: '${polls.count}',
                          color: Colors.teal),
                      const SizedBox(height: 4),
                      _StatBadge(
                          label: 'Votes',
                          value: '${polls.totalVotes}',
                          color: Colors.indigo),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14.sp)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBadge(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: color)),
        Text(label,
            style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
      ],
    );
  }
}

class _AttendanceBar extends StatelessWidget {
  final int accepted, declined, pending, total;
  const _AttendanceBar(
      {required this.accepted,
      required this.declined,
      required this.pending,
      required this.total});

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Row(
        children: [
          Flexible(
            flex: accepted,
            child: Container(height: 12, color: Colors.green),
          ),
          Flexible(
            flex: declined,
            child: Container(height: 12, color: Colors.red),
          ),
          Flexible(
            flex: pending,
            child: Container(height: 12, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
