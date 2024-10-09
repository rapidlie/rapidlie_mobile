part of 'file_upload_bloc.dart';

abstract class FileUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FileUploadInitial extends FileUploadState {}

class FileUploadingState extends FileUploadState {}

class FileUploadSuccessState extends FileUploadState {
  final String fileName;

  FileUploadSuccessState(this.fileName);

  @override
  List<Object?> get props => [fileName];
}

class FileUploadFailureState extends FileUploadState {
  final String error;

  FileUploadFailureState(this.error);

  @override
  List<Object?> get props => [error];
}
