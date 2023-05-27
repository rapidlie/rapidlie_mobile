class ContactDetails {
  final String name;
  final String telephone;
  final String? image;

  ContactDetails(this.name, this.telephone, this.image);
}

enum Status {
  accepted,
  rejected,
  pending,
}
