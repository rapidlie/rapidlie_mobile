part of 'poll_bloc.dart';

abstract class PollState extends Equatable {
  const PollState();
  @override
  List<Object?> get props => [];
}

class PollInitial extends PollState {}

class PollLoading extends PollState {}

class PollCreating extends PollState {}

class PollsLoaded extends PollState {
  final List<PollModel> polls;
  const PollsLoaded(this.polls);
  @override
  List<Object?> get props => [polls];
}

class PollCreateSuccess extends PollState {
  final PollModel poll;
  const PollCreateSuccess(this.poll);
  @override
  List<Object?> get props => [poll];
}

class PollVoteSuccess extends PollState {
  final PollModel poll;
  const PollVoteSuccess(this.poll);
  @override
  List<Object?> get props => [poll];
}

class PollDeleteSuccess extends PollState {
  final String pollId;
  const PollDeleteSuccess(this.pollId);
  @override
  List<Object?> get props => [pollId];
}

class PollError extends PollState {
  final String message;
  const PollError(this.message);
  @override
  List<Object?> get props => [message];
}
