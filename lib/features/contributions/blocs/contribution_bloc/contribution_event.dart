part of 'contribution_bloc.dart';

abstract class ContributionEvent extends Equatable {
  const ContributionEvent();
  @override
  List<Object?> get props => [];
}

class SubmitContribution extends ContributionEvent {
  final String eventId;
  final double amount;
  final String phone;
  final String network;
  final String? message;
  const SubmitContribution({
    required this.eventId,
    required this.amount,
    required this.phone,
    required this.network,
    this.message,
  });
  @override
  List<Object?> get props => [eventId, amount, phone, network, message];
}

class FetchEventContributions extends ContributionEvent {
  final String eventId;
  const FetchEventContributions(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class FetchMyContributions extends ContributionEvent {
  const FetchMyContributions();
}
