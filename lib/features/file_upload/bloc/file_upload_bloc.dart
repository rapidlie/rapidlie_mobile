import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/file_upload/repository/file_upload_repository.dart';

part 'file_upload_event.dart';
part 'file_upload_state.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final FileUploadRepository fileUploadRepository;

  FileUploadBloc({required this.fileUploadRepository}) : super(FileUploadInitial()) {
    on<FileUploadEvent>(_onUploadFile);
  }

  Future<void> _onUploadFile(
      FileUploadEvent event, Emitter<FileUploadState> emit) async {
    emit(FileUploadingState());
    final dataState = await fileUploadRepository.uploadFile(event.file);

    if (dataState is DataSuccess) {
      emit(FileUploadSuccessState(
          dataState.data!));
    } else if (dataState is DataFailed) {
      emit(FileUploadFailureState(dataState.error?.message ?? 'Unknown Error'));
    }
  }
}
