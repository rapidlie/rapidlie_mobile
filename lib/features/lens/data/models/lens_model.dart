class TopContributor {
  final String name;
  final double amount;
  const TopContributor({required this.name, required this.amount});
  factory TopContributor.fromJson(Map<String, dynamic> json) => TopContributor(
        name: json['name'] as String,
        amount: (json['amount'] as num).toDouble(),
      );
}

class LensAttendance {
  final int totalInvited;
  final int accepted;
  final int declined;
  final int pending;
  final String attendanceRate;
  const LensAttendance({
    required this.totalInvited,
    required this.accepted,
    required this.declined,
    required this.pending,
    required this.attendanceRate,
  });
  factory LensAttendance.fromJson(Map<String, dynamic> json) => LensAttendance(
        totalInvited: (json['total_invited'] as num).toInt(),
        accepted: (json['accepted'] as num).toInt(),
        declined: (json['declined'] as num).toInt(),
        pending: (json['pending'] as num).toInt(),
        attendanceRate: json['attendance_rate'] as String,
      );
}

class LensEngagement {
  final int likes;
  final int bookmarks;
  final String engagementScore;
  const LensEngagement({
    required this.likes,
    required this.bookmarks,
    required this.engagementScore,
  });
  factory LensEngagement.fromJson(Map<String, dynamic> json) => LensEngagement(
        likes: (json['likes'] as num).toInt(),
        bookmarks: (json['bookmarks'] as num).toInt(),
        engagementScore: json['engagement_score'] as String,
      );
}

class LensContributions {
  final double totalAmount;
  final String currency;
  final int contributors;
  final List<TopContributor> topContributors;
  const LensContributions({
    required this.totalAmount,
    required this.currency,
    required this.contributors,
    required this.topContributors,
  });
  factory LensContributions.fromJson(Map<String, dynamic> json) =>
      LensContributions(
        totalAmount: (json['total_amount'] as num).toDouble(),
        currency: json['currency'] as String? ?? 'GHS',
        contributors: (json['contributors'] as num).toInt(),
        topContributors: (json['top_contributors'] as List)
            .map((e) => TopContributor.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class LensReels {
  final int count;
  final int totalLikes;
  const LensReels({required this.count, required this.totalLikes});
  factory LensReels.fromJson(Map<String, dynamic> json) => LensReels(
        count: (json['count'] as num).toInt(),
        totalLikes: (json['total_likes'] as num).toInt(),
      );
}

class LensPolls {
  final int count;
  final int totalVotes;
  const LensPolls({required this.count, required this.totalVotes});
  factory LensPolls.fromJson(Map<String, dynamic> json) => LensPolls(
        count: (json['count'] as num).toInt(),
        totalVotes: (json['total_votes'] as num).toInt(),
      );
}

class LensModel {
  final String eventName;
  final LensAttendance attendance;
  final LensEngagement engagement;
  final LensContributions contributions;
  final LensReels reels;
  final LensPolls polls;

  const LensModel({
    required this.eventName,
    required this.attendance,
    required this.engagement,
    required this.contributions,
    required this.reels,
    required this.polls,
  });

  factory LensModel.fromJson(Map<String, dynamic> json) => LensModel(
        eventName: (json['event'] as Map<String, dynamic>)['name'] as String,
        attendance: LensAttendance.fromJson(
            json['attendance'] as Map<String, dynamic>),
        engagement: LensEngagement.fromJson(
            json['engagement'] as Map<String, dynamic>),
        contributions: LensContributions.fromJson(
            json['contributions'] as Map<String, dynamic>),
        reels: LensReels.fromJson(json['reels'] as Map<String, dynamic>),
        polls: LensPolls.fromJson(json['polls'] as Map<String, dynamic>),
      );
}
