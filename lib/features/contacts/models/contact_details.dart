class ContactDetails {
  final String name;
  String? telephone;
  String? image;
  Status? status;
  bool isSelected;

  ContactDetails({
    required this.name,
    this.telephone,
    this.image,
    this.status,
    this.isSelected = false,
  });
}

enum Status {
  accepted,
  rejected,
  pending,
}
