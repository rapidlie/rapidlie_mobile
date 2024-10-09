class TelephoneNumbersModel {
  List<String> contacts;

  TelephoneNumbersModel({required this.contacts});

  factory TelephoneNumbersModel.fromJson(Map<String, dynamic> json) {
    return TelephoneNumbersModel(
      contacts: List<String>.from(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contacts': contacts,
    };
  }
}
