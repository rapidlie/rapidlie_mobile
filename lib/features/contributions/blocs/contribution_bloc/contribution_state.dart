part of 'contribution_bloc.dart';

abstract class ContributionState extends Equatable {
  const ContributionState();
  @override
  List<Object?> get props => [];
}

class ContributionInitial extends ContributionState {}

class ContributionLoading extends ContributionState {}

class ContributionSuccess extends ContributionState {
  final String message;
  const ContributionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class EventContributionsLoaded extends ContributionState {
  final EventContributionSummary summary;
  const EventContributionsLoaded(this.summary);
  @override
  List<Object?> get props => [summary];
}

class MyContributionsLoaded extends ContributionState {
  final List<ContributionModel> contributions;
  const MyContributionsLoaded(this.contributions);
  @override
  List<Object?> get props => [contributions];
}

class ContributionError extends ContributionState {
  final String message;
  const ContributionError(this.message);
  @override
  List<Object?> get props => [message];
}
