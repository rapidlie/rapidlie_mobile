class ContributorUser {
  final String id;
  final String name;
  final String? avatar;

  const ContributorUser({required this.id, required this.name, this.avatar});

  factory ContributorUser.fromJson(Map<String, dynamic> json) =>
      ContributorUser(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        avatar: json['avatar'] as String?,
      );
}

class ContributionModel {
  final String id;
  final double amount;
  final String currency;
  final String status;
  final String? message;
  final String transactionRef;
  final ContributorUser contributor;
  final String createdAt;

  const ContributionModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    this.message,
    required this.transactionRef,
    required this.contributor,
    required this.createdAt,
  });

  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';

  factory ContributionModel.fromJson(Map<String, dynamic> json) =>
      ContributionModel(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String? ?? 'GHS',
        status: json['status'] as String,
        message: json['message'] as String?,
        transactionRef: json['transaction_ref'] as String,
        contributor: ContributorUser.fromJson(
            json['contributor'] as Map<String, dynamic>),
        createdAt: json['created_at'] as String,
      );
}

class EventContributionSummary {
  final double total;
  final String currency;
  final List<ContributionModel> contributions;

  const EventContributionSummary({
    required this.total,
    required this.currency,
    required this.contributions,
  });

  factory EventContributionSummary.fromJson(Map<String, dynamic> json) =>
      EventContributionSummary(
        total: (json['total'] as num?)?.toDouble() ?? 0.0,
        currency: json['currency'] as String? ?? 'GHS',
        contributions: (json['data'] as List)
            .map((e) =>
                ContributionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
