import 'dart:io';

import 'package:equatable/equatable.dart';

class FileUploadModel extends Equatable {
  File? file;

  FileUploadModel({
    this.file,
  });

  // Factory constructor to create an instance from JSON
  factory FileUploadModel.fromJson(Map<String, dynamic> json) {
    return FileUploadModel(
      file: json['file'],
    );
  }

  // Method to convert an instance to JSON
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
