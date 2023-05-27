class ContactDetails {
  final String name;
  String? telephone;
  String? image;
  Status? status;

  ContactDetails({required this.name, this.telephone, this.image, this.status});
}

enum Status {
  accepted,
  rejected,
  pending,
}
