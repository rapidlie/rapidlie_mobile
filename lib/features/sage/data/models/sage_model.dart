class SageSuggestions {
  final String eventName;
  final List<String> themeAndDecor;
  final List<String> activitiesAndEntertainment;
  final List<String> cateringAndRefreshments;
  final List<String> timelineAndSchedule;
  final List<String> logisticsAndSetup;
  final List<String> guestEngagement;
  final String proTip;

  const SageSuggestions({
    required this.eventName,
    required this.themeAndDecor,
    required this.activitiesAndEntertainment,
    required this.cateringAndRefreshments,
    required this.timelineAndSchedule,
    required this.logisticsAndSetup,
    required this.guestEngagement,
    required this.proTip,
  });

  factory SageSuggestions.fromJson(Map<String, dynamic> json) {
    final s = json['suggestions'] as Map<String, dynamic>;
    return SageSuggestions(
      eventName: json['event'] as String,
      themeAndDecor: _toList(s['theme_and_decor']),
      activitiesAndEntertainment:
          _toList(s['activities_and_entertainment']),
      cateringAndRefreshments: _toList(s['catering_and_refreshments']),
      timelineAndSchedule: _toList(s['timeline_and_schedule']),
      logisticsAndSetup: _toList(s['logistics_and_setup']),
      guestEngagement: _toList(s['guest_engagement']),
      proTip: s['pro_tip'] as String? ?? '',
    );
  }

  static List<String> _toList(dynamic v) =>
      v == null ? [] : (v as List).map((e) => e as String).toList();
}
