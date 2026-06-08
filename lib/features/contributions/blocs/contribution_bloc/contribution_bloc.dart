import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/contributions/data/models/contribution_model.dart';
import 'package:rapidlie/features/contributions/data/repository/contribution_repository.dart';

part 'contribution_event.dart';
part 'contribution_state.dart';

class ContributionBloc extends Bloc<ContributionEvent, ContributionState> {
  final ContributionRepository contributionRepository;

  ContributionBloc({required this.contributionRepository})
      : super(ContributionInitial()) {
    on<SubmitContribution>(_onSubmit);
    on<FetchEventContributions>(_onFetchEventContributions);
    on<FetchMyContributions>(_onFetchMyContributions);
  }

  Future<void> _onSubmit(
      SubmitContribution event, Emitter<ContributionState> emit) async {
    emit(ContributionLoading());
    final result = await contributionRepository.contribute(
      eventId: event.eventId,
      amount: event.amount,
      phone: event.phone,
      network: event.network,
      message: event.message,
    );
    if (result is DataSuccess<ContributionModel>) {
      emit(const ContributionSuccess(
          'Payment initiated. Complete the prompt on your phone.'));
    } else {
      emit(ContributionError(
          result.error?.response?.data['message'] as String? ??
              'Payment failed. Please try again.'));
    }
  }

  Future<void> _onFetchEventContributions(
      FetchEventContributions event, Emitter<ContributionState> emit) async {
    emit(ContributionLoading());
    final result =
        await contributionRepository.getEventContributions(event.eventId);
    if (result is DataSuccess<EventContributionSummary>) {
      emit(EventContributionsLoaded(result.data!));
    } else {
      emit(ContributionError(
          result.error?.response?.data['message'] as String? ??
              'Failed to load contributions'));
    }
  }

  Future<void> _onFetchMyContributions(
      FetchMyContributions event, Emitter<ContributionState> emit) async {
    emit(ContributionLoading());
    final result = await contributionRepository.getMyContributions();
    if (result is DataSuccess<List<ContributionModel>>) {
      emit(MyContributionsLoaded(result.data!));
    } else {
      emit(ContributionError(
          result.error?.response?.data['message'] as String? ??
              'Failed to load contributions'));
    }
  }
}
