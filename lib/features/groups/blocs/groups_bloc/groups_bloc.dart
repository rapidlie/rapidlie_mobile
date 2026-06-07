import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/events/models/event_model.dart';
import 'package:rapidlie/features/groups/data/models/group_model.dart';
import 'package:rapidlie/features/groups/data/repository/group_repository.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GroupRepository groupRepository;

  GroupsBloc({required this.groupRepository}) : super(GroupsInitial()) {
    on<FetchPublicGroups>(_onFetchPublic);
    on<FetchMyGroups>(_onFetchMy);
    on<FetchGroupDetail>(_onFetchDetail);
    on<CreateGroup>(_onCreate);
    on<JoinGroup>(_onJoin);
    on<LeaveGroup>(_onLeave);
    on<FetchGroupMembers>(_onFetchMembers);
    on<FetchGroupEvents>(_onFetchEvents);
  }

  String _errMsg(DataState state) =>
      state.error?.response?.data['message'] as String? ?? 'Something went wrong';

  Future<void> _onFetchPublic(
      FetchPublicGroups event, Emitter<GroupsState> emit) async {
    emit(GroupsLoading());
    final result = await groupRepository.getPublicGroups();
    if (result is DataSuccess<List<GroupModel>>) {
      emit(GroupsLoaded(result.data!));
    } else {
      emit(GroupsError(_errMsg(result)));
    }
  }

  Future<void> _onFetchMy(
      FetchMyGroups event, Emitter<GroupsState> emit) async {
    emit(GroupsLoading());
    final result = await groupRepository.getMyGroups();
    if (result is DataSuccess<List<GroupModel>>) {
      emit(GroupsLoaded(result.data!));
    } else {
      emit(GroupsError(_errMsg(result)));
    }
  }

  Future<void> _onFetchDetail(
      FetchGroupDetail event, Emitter<GroupsState> emit) async {
    emit(GroupsLoading());
    final result = await groupRepository.getGroup(event.groupId);
    if (result is DataSuccess<GroupModel>) {
      emit(GroupDetailLoaded(result.data!));
    } else {
      emit(GroupsError(_errMsg(result)));
    }
  }

  Future<void> _onCreate(
      CreateGroup event, Emitter<GroupsState> emit) async {
    emit(GroupsLoading());
    final result = await groupRepository.createGroup(
      name: event.name,
      description: event.description,
      image: event.image,
      privacy: event.privacy,
    );
    if (result is DataSuccess<GroupModel>) {
      emit(GroupCreateSuccess(result.data!));
    } else {
      emit(GroupsError(_errMsg(result)));
    }
  }

  Future<void> _onJoin(
      JoinGroup event, Emitter<GroupsState> emit) async {
    final result = await groupRepository.joinGroup(event.groupId);
    if (result is DataSuccess<String>) {
      emit(GroupActionSuccess(result.data!));
    } else {
      emit(GroupsError(_errMsg(result)));
    }
  }

  Future<void> _onLeave(
      LeaveGroup event, Emitter<GroupsState> emit) async {
    final result = await groupRepository.leaveGroup(event.groupId);
    if (result is DataSuccess<String>) {
      emit(GroupActionSuccess(result.data!));
    } else {
      emit(GroupsError(_errMsg(result)));
    }
  }

  Future<void> _onFetchMembers(
      FetchGroupMembers event, Emitter<GroupsState> emit) async {
    emit(GroupsLoading());
    final result = await groupRepository.getMembers(event.groupId);
    if (result is DataSuccess<List<GroupMemberModel>>) {
      emit(GroupMembersLoaded(result.data!));
    } else {
      emit(GroupsError(_errMsg(result)));
    }
  }

  Future<void> _onFetchEvents(
      FetchGroupEvents event, Emitter<GroupsState> emit) async {
    emit(GroupsLoading());
    final result = await groupRepository.getGroupEvents(event.groupId);
    if (result is DataSuccess<List<EventDataModel>>) {
      emit(GroupEventsLoaded(result.data!));
    } else {
      emit(GroupsError(_errMsg(result)));
    }
  }
}
