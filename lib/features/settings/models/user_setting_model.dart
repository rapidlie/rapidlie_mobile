class UserSettingModel {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool invitationNotifications;
  final bool eventReminders;
  final bool contributionNotifications;
  final String profileVisibility;
  final bool discoverableByContacts;
  final bool biometricEnabled;

  const UserSettingModel({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.invitationNotifications,
    required this.eventReminders,
    required this.contributionNotifications,
    required this.profileVisibility,
    required this.discoverableByContacts,
    required this.biometricEnabled,
  });

  bool get isPublic => profileVisibility == 'public';

  factory UserSettingModel.fromJson(Map<String, dynamic> json) =>
      UserSettingModel(
        pushNotifications: json['push_notifications'] as bool? ?? true,
        emailNotifications: json['email_notifications'] as bool? ?? true,
        invitationNotifications:
            json['invitation_notifications'] as bool? ?? true,
        eventReminders: json['event_reminders'] as bool? ?? true,
        contributionNotifications:
            json['contribution_notifications'] as bool? ?? true,
        profileVisibility:
            json['profile_visibility'] as String? ?? 'public',
        discoverableByContacts:
            json['discoverable_by_contacts'] as bool? ?? true,
        biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      );

  UserSettingModel copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? invitationNotifications,
    bool? eventReminders,
    bool? contributionNotifications,
    String? profileVisibility,
    bool? discoverableByContacts,
    bool? biometricEnabled,
  }) =>
      UserSettingModel(
        pushNotifications: pushNotifications ?? this.pushNotifications,
        emailNotifications: emailNotifications ?? this.emailNotifications,
        invitationNotifications:
            invitationNotifications ?? this.invitationNotifications,
        eventReminders: eventReminders ?? this.eventReminders,
        contributionNotifications:
            contributionNotifications ?? this.contributionNotifications,
        profileVisibility: profileVisibility ?? this.profileVisibility,
        discoverableByContacts:
            discoverableByContacts ?? this.discoverableByContacts,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      );

  Map<String, dynamic> toJson() => {
        'push_notifications': pushNotifications,
        'email_notifications': emailNotifications,
        'invitation_notifications': invitationNotifications,
        'event_reminders': eventReminders,
        'contribution_notifications': contributionNotifications,
        'profile_visibility': profileVisibility,
        'discoverable_by_contacts': discoverableByContacts,
        'biometric_enabled': biometricEnabled,
      };
}
