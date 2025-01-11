import 'dart:io';

import 'package:equatable/equatable.dart';

class FileUploadModel extends Equatable {
  File? file;

  FileUploadModel({
    this.file,
  });

  factory FileUploadModel.fromJson(Map<String, dynamic> json) {
    return FileUploadModel(
      file: json['file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
    };
  }

  @override
  List<Object?> get props => [
        file,
      ];
}
