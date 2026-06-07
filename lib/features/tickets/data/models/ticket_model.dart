class TicketEventData {
  final String id;
  final String name;
  final String date;
  final String venue;
  final String image;

  const TicketEventData({
    required this.id,
    required this.name,
    required this.date,
    required this.venue,
    required this.image,
  });

  factory TicketEventData.fromJson(Map<String, dynamic> json) {
    return TicketEventData(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date'] as String,
      venue: json['venue'] as String,
      image: json['image'] as String? ?? '',
    );
  }
}

class TicketModel {
  final String id;
  final String ticketCode;
  final String status;
  final String? scannedAt;
  final TicketEventData event;
  final String issuedAt;

  const TicketModel({
    required this.id,
    required this.ticketCode,
    required this.status,
    this.scannedAt,
    required this.event,
    required this.issuedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] as String,
      ticketCode: json['ticket_code'] as String,
      status: json['status'] as String,
      scannedAt: json['scanned_at'] as String?,
      event: TicketEventData.fromJson(json['event'] as Map<String, dynamic>),
      issuedAt: json['issued_at'] as String,
    );
  }

  bool get isUsed => status == 'used';
  bool get isCancelled => status == 'cancelled';
  bool get isValid => status == 'valid' || status == 'pending';
}
