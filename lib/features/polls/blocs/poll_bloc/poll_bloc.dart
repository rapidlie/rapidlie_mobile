import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/polls/data/models/poll_model.dart';
import 'package:rapidlie/features/polls/data/repository/poll_repository.dart';

part 'poll_event.dart';
part 'poll_state.dart';

class PollBloc extends Bloc<PollEvent, PollState> {
  final PollRepository pollRepository;

  PollBloc({required this.pollRepository}) : super(PollInitial()) {
    on<FetchPolls>(_onFetchPolls);
    on<CreatePoll>(_onCreatePoll);
    on<VoteOnPoll>(_onVote);
    on<DeletePoll>(_onDeletePoll);
  }

  Future<void> _onFetchPolls(FetchPolls event, Emitter<PollState> emit) async {
    emit(PollLoading());
    final result = await pollRepository.getPolls(event.eventId);
    if (result is DataSuccess<List<PollModel>>) {
      emit(PollsLoaded(result.data!));
    } else {
      emit(PollError(result.error?.response?.data['message'] as String? ??
          'Failed to load polls'));
    }
  }

  Future<void> _onCreatePoll(
      CreatePoll event, Emitter<PollState> emit) async {
    emit(PollCreating());
    final result = await pollRepository.createPoll(
      eventId: event.eventId,
      question: event.question,
      type: event.type,
      options: event.options,
      endsAt: event.endsAt,
    );
    if (result is DataSuccess<PollModel>) {
      emit(PollCreateSuccess(result.data!));
    } else {
      emit(PollError(result.error?.response?.data['message'] as String? ??
          'Failed to create poll'));
    }
  }

  Future<void> _onVote(VoteOnPoll event, Emitter<PollState> emit) async {
    final result = await pollRepository.vote(
        pollId: event.pollId, optionIds: event.optionIds);
    if (result is DataSuccess<PollModel>) {
      emit(PollVoteSuccess(result.data!));
    } else {
      emit(PollError(result.error?.response?.data['message'] as String? ??
          'Failed to vote'));
    }
  }

  Future<void> _onDeletePoll(
      DeletePoll event, Emitter<PollState> emit) async {
    final result = await pollRepository.deletePoll(event.pollId);
    if (result is DataSuccess<String>) {
      emit(PollDeleteSuccess(event.pollId));
    } else {
      emit(PollError(result.error?.response?.data['message'] as String? ??
          'Failed to delete poll'));
    }
  }
}
