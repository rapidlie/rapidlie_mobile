class MoodOption {
  final String value;
  final String label;
  final String emoji;

  const MoodOption({
    required this.value,
    required this.label,
    required this.emoji,
  });

  factory MoodOption.fromJson(Map<String, dynamic> json) => MoodOption(
        value: json['value'] as String,
        label: json['label'] as String,
        emoji: json['emoji'] as String,
      );
}
