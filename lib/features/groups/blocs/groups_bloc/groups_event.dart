part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();
  @override
  List<Object?> get props => [];
}

class FetchPublicGroups extends GroupsEvent {
  const FetchPublicGroups();
}

class FetchMyGroups extends GroupsEvent {
  const FetchMyGroups();
}

class FetchGroupDetail extends GroupsEvent {
  final String groupId;
  const FetchGroupDetail(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class CreateGroup extends GroupsEvent {
  final String name;
  final String? description;
  final String? image;
  final String privacy;
  const CreateGroup({
    required this.name,
    this.description,
    this.image,
    this.privacy = 'public',
  });
  @override
  List<Object?> get props => [name, description, image, privacy];
}

class JoinGroup extends GroupsEvent {
  final String groupId;
  const JoinGroup(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class LeaveGroup extends GroupsEvent {
  final String groupId;
  const LeaveGroup(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class FetchGroupMembers extends GroupsEvent {
  final String groupId;
  const FetchGroupMembers(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class FetchGroupEvents extends GroupsEvent {
  final String groupId;
  const FetchGroupEvents(this.groupId);
  @override
  List<Object?> get props => [groupId];
}
