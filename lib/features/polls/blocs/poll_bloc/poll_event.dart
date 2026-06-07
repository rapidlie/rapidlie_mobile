part of 'poll_bloc.dart';

abstract class PollEvent extends Equatable {
  const PollEvent();
  @override
  List<Object?> get props => [];
}

class FetchPolls extends PollEvent {
  final String eventId;
  const FetchPolls(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class CreatePoll extends PollEvent {
  final String eventId;
  final String question;
  final String type;
  final List<String> options;
  final String? endsAt;
  const CreatePoll({
    required this.eventId,
    required this.question,
    required this.type,
    required this.options,
    this.endsAt,
  });
  @override
  List<Object?> get props => [eventId, question, type, options, endsAt];
}

class VoteOnPoll extends PollEvent {
  final String pollId;
  final List<String> optionIds;
  const VoteOnPoll({required this.pollId, required this.optionIds});
  @override
  List<Object?> get props => [pollId, optionIds];
}

class DeletePoll extends PollEvent {
  final String pollId;
  const DeletePoll(this.pollId);
  @override
  List<Object?> get props => [pollId];
}
