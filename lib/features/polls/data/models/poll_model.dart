class PollOption {
  final String id;
  final String text;
  final int votes;
  final double percentage;
  final bool hasVoted;

  const PollOption({
    required this.id,
    required this.text,
    required this.votes,
    required this.percentage,
    required this.hasVoted,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) => PollOption(
        id: json['id'] as String,
        text: json['text'] as String,
        votes: (json['votes'] as num?)?.toInt() ?? 0,
        percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
        hasVoted: json['has_voted'] as bool? ?? false,
      );
}

class PollModel {
  final String id;
  final String question;
  final String type;
  final int totalVotes;
  final bool hasVoted;
  final bool isExpired;
  final String? endsAt;
  final List<PollOption> options;
  final String createdAt;

  const PollModel({
    required this.id,
    required this.question,
    required this.type,
    required this.totalVotes,
    required this.hasVoted,
    required this.isExpired,
    this.endsAt,
    required this.options,
    required this.createdAt,
  });

  bool get isMultiple => type == 'multiple';

  factory PollModel.fromJson(Map<String, dynamic> json) => PollModel(
        id: json['id'] as String,
        question: json['question'] as String,
        type: json['type'] as String,
        totalVotes: (json['total_votes'] as num?)?.toInt() ?? 0,
        hasVoted: json['has_voted'] as bool? ?? false,
        isExpired: json['is_expired'] as bool? ?? false,
        endsAt: json['ends_at'] as String?,
        options: (json['options'] as List)
            .map((e) => PollOption.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: json['created_at'] as String,
      );
}
