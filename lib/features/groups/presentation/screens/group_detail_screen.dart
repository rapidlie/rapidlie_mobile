import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/utils/render_image.dart';
import 'package:rapidlie/features/groups/blocs/groups_bloc/groups_bloc.dart';
import 'package:rapidlie/features/groups/data/models/group_model.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;
  const GroupDetailScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GroupModel? _group;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_group == null) return;
      if (_tabController.index == 0) {
        context
            .read<GroupsBloc>()
            .add(FetchGroupMembers(widget.groupId));
      } else {
        context
            .read<GroupsBloc>()
            .add(FetchGroupEvents(widget.groupId));
      }
    });
    context.read<GroupsBloc>().add(FetchGroupDetail(widget.groupId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onJoinLeave(GroupModel group) {
    if (group.isMember) {
      context.read<GroupsBloc>().add(LeaveGroup(widget.groupId));
    } else {
      context.read<GroupsBloc>().add(JoinGroup(widget.groupId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsBloc, GroupsState>(
      listener: (context, state) {
        if (state is GroupDetailLoaded) {
          setState(() => _group = state.group);
          context
              .read<GroupsBloc>()
              .add(FetchGroupMembers(widget.groupId));
        } else if (state is GroupActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context
              .read<GroupsBloc>()
              .add(FetchGroupDetail(widget.groupId));
        } else if (state is GroupsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final group = _group;
        if (group == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                expandedHeight: 200.h,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(group.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  background: group.image != null
                      ? RenderImage(
                          imageUrl: group.image!,
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.2),
                          child: Icon(Icons.group,
                              size: 64,
                              color:
                                  Theme.of(context).colorScheme.primary),
                        ),
                ),
                actions: [
                  if (!group.isOwner)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: state is GroupsLoading
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                            )
                          : TextButton(
                              onPressed: () => _onJoinLeave(group),
                              child: Text(
                                group.isMember ? 'Leave' : 'Join',
                                style: TextStyle(
                                  color: group.isMember
                                      ? Colors.red
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16,
                              color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${group.memberCount} members',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: group.isPublic
                                  ? Colors.green.withValues(alpha: 0.12)
                                  : Colors.orange.withValues(alpha: 0.12),
                            ),
                            child: Text(
                              group.privacy.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: group.isPublic
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (group.description != null) ...[
                        const SizedBox(height: 8),
                        Text(group.description!,
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Members'),
                      Tab(text: 'Events'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _MembersTab(
                  groupId: widget.groupId,
                  isOwner: group.isOwner,
                ),
                _EventsTab(groupId: widget.groupId),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MembersTab extends StatelessWidget {
  final String groupId;
  final bool isOwner;
  const _MembersTab({required this.groupId, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        if (state is GroupsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GroupMembersLoaded) {
          final members = state.members;
          if (members.isEmpty) {
            return const Center(child: Text('No members yet'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final m = members[i];
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      m.avatar != null ? NetworkImage(m.avatar!) : null,
                  child: m.avatar == null
                      ? Text(m.name[0].toUpperCase())
                      : null,
                ),
                title: Text(m.name,
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w500)),
                subtitle: Text(m.role,
                    style: const TextStyle(fontSize: 11)),
                trailing: m.role == 'admin'
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.12),
                        ),
                        child: Text('Admin',
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  Theme.of(context).colorScheme.primary,
                            )),
                      )
                    : null,
              );
            },
          );
        }
        return const Center(child: Text('Could not load members'));
      },
    );
  }
}

class _EventsTab extends StatelessWidget {
  final String groupId;
  const _EventsTab({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (context, state) {
        if (state is GroupsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GroupEventsLoaded) {
          final events = state.events;
          if (events.isEmpty) {
            return const Center(child: Text('No events in this group'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final e = events[i];
              return GestureDetector(
                onTap: () =>
                    context.pushNamed('event_details', extra: e),
                child: Container(
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
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12)),
                        child: e.image != null
                            ? RenderImage(
                                imageUrl: e.image!,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 72,
                                height: 72,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                                child: const Icon(Icons.event, size: 28),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(e.date,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                              Text(e.venue,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('Could not load events'));
      },
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
