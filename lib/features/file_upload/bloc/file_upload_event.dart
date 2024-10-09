part of 'file_upload_bloc.dart';

class FileUploadEvent extends Equatable {
  final File file;
  const FileUploadEvent({required this.file});

  

  @override
  List<Object> get props => [file];
}

