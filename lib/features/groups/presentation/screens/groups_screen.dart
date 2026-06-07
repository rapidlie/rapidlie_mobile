import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/utils/render_image.dart';
import 'package:rapidlie/features/groups/blocs/groups_bloc/groups_bloc.dart';
import 'package:rapidlie/features/groups/data/models/group_model.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        context.read<GroupsBloc>().add(const FetchPublicGroups());
      } else {
        context.read<GroupsBloc>().add(const FetchMyGroups());
      }
    });
    context.read<GroupsBloc>().add(const FetchPublicGroups());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Discover'), Tab(text: 'My Groups')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.pushNamed('create_group'),
      ),
      body: BlocConsumer<GroupsBloc, GroupsState>(
        listener: (context, state) {
          if (state is GroupActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<GroupsBloc>().add(const FetchPublicGroups());
          } else if (state is GroupCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Group created!')),
            );
            context.read<GroupsBloc>().add(const FetchMyGroups());
            _tabController.animateTo(1);
          } else if (state is GroupsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is GroupsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final groups =
              state is GroupsLoaded ? state.groups : <GroupModel>[];
          return TabBarView(
            controller: _tabController,
            children: [
              _GroupsList(
                groups: groups,
                onRefresh: () => context
                    .read<GroupsBloc>()
                    .add(const FetchPublicGroups()),
              ),
              _GroupsList(
                groups: groups,
                onRefresh: () =>
                    context.read<GroupsBloc>().add(const FetchMyGroups()),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  final List<GroupModel> groups;
  final VoidCallback onRefresh;
  const _GroupsList({required this.groups, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const Center(child: Text('No groups found'));
    }
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: groups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _GroupCard(group: groups[i]),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupModel group;
  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
            .read<GroupsBloc>()
            .add(FetchGroupDetail(group.id));
        context.pushNamed('group_detail', extra: group.id);
      },
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
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
              child: group.image != null
                  ? RenderImage(
                      imageUrl: group.image!,
                      width: 80.w,
                      height: 80.w,
                    )
                  : Container(
                      width: 80.w,
                      height: 80.w,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                      child: Icon(Icons.group,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    if (group.description != null) ...[
                      const SizedBox(height: 2),
                      Text(group.description!,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${group.memberCount} members',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: group.isPublic
                                ? Colors.green.withValues(alpha: 0.12)
                                : Colors.orange.withValues(alpha: 0.12),
                          ),
                          child: Text(
                            group.privacy.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: group.isPublic
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (!group.isMember && !group.isOwner && group.isPublic)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ElevatedButton(
                  onPressed: () => context
                      .read<GroupsBloc>()
                      .add(JoinGroup(group.id)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: TextStyle(fontSize: 11.sp),
                  ),
                  child: const Text('Join'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
