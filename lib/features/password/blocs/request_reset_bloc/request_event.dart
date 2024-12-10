part of 'request_bloc.dart';

class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitRequestEvent extends RequestEvent {
  final String email;

  const SubmitRequestEvent({
    required this.email,
  });

  @override
  List<Object> get props => [];
}
