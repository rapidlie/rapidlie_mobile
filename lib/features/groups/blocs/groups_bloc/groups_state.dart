part of 'groups_bloc.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();
  @override
  List<Object?> get props => [];
}

class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<GroupModel> groups;
  const GroupsLoaded(this.groups);
  @override
  List<Object?> get props => [groups];
}

class GroupDetailLoaded extends GroupsState {
  final GroupModel group;
  const GroupDetailLoaded(this.group);
  @override
  List<Object?> get props => [group];
}

class GroupCreateSuccess extends GroupsState {
  final GroupModel group;
  const GroupCreateSuccess(this.group);
  @override
  List<Object?> get props => [group];
}

class GroupActionSuccess extends GroupsState {
  final String message;
  const GroupActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class GroupMembersLoaded extends GroupsState {
  final List<GroupMemberModel> members;
  const GroupMembersLoaded(this.members);
  @override
  List<Object?> get props => [members];
}

class GroupEventsLoaded extends GroupsState {
  final List<EventDataModel> events;
  const GroupEventsLoaded(this.events);
  @override
  List<Object?> get props => [events];
}

class GroupsError extends GroupsState {
  final String message;
  const GroupsError(this.message);
  @override
  List<Object?> get props => [message];
}
