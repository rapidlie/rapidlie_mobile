import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/features/settings/blocs/user_setting_bloc/user_setting_bloc.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserSettingBloc>().add(const FetchSettings());
  }

  void _toggle(String key, bool value) {
    context.read<UserSettingBloc>().add(UpdateSetting(key: key, value: value));
  }

  void _setVisibility(String value) {
    context
        .read<UserSettingBloc>()
        .add(UpdateSetting(key: 'profile_visibility', value: value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocConsumer<UserSettingBloc, UserSettingState>(
        listener: (context, state) {
          if (state is UserSettingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserSettingLoading || state is UserSettingInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! UserSettingLoaded) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Could not load settings'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context
                        .read<UserSettingBloc>()
                        .add(const FetchSettings()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final s = state.settings;
          return ListView(
            children: [
              _SectionHeader('Notifications'),
              _SettingTile(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Receive push alerts on this device',
                value: s.pushNotifications,
                onChanged: (v) => _toggle('push_notifications', v),
              ),
              _SettingTile(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                subtitle: 'Get updates sent to your email',
                value: s.emailNotifications,
                onChanged: (v) => _toggle('email_notifications', v),
              ),
              _SettingTile(
                icon: Icons.person_add_outlined,
                title: 'Invitation Alerts',
                subtitle: 'Notify me when I\'m invited to events',
                value: s.invitationNotifications,
                onChanged: (v) => _toggle('invitation_notifications', v),
              ),
              _SettingTile(
                icon: Icons.alarm_outlined,
                title: 'Event Reminders',
                subtitle: 'Remind me before events I\'m attending',
                value: s.eventReminders,
                onChanged: (v) => _toggle('event_reminders', v),
              ),
              _SettingTile(
                icon: Icons.volunteer_activism_outlined,
                title: 'Contribution Alerts',
                subtitle: 'Notify me about kitty contributions',
                value: s.contributionNotifications,
                onChanged: (v) => _toggle('contribution_notifications', v),
              ),
              _SectionHeader('Privacy'),
              _VisibilityTile(
                current: s.profileVisibility,
                onChanged: _setVisibility,
              ),
              _SettingTile(
                icon: Icons.contacts_outlined,
                title: 'Discoverable by Contacts',
                subtitle: 'Let people find you via your phone number',
                value: s.discoverableByContacts,
                onChanged: (v) => _toggle('discoverable_by_contacts', v),
              ),
              _SectionHeader('Security'),
              _BiometricTile(
                enabled: s.biometricEnabled,
                onToggle: (v) {
                  if (v) {
                    context.pushNamed('vault_enable');
                  } else {
                    context.read<UserSettingBloc>().add(
                          const DisableBiometric(),
                        );
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
      title: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: Theme.of(context).colorScheme.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _VisibilityTile extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;

  const _VisibilityTile({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.visibility_outlined,
          color: Theme.of(context).colorScheme.primary, size: 22),
      title: const Text('Profile Visibility',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(current == 'public' ? 'Anyone can view your profile' : 'Only invited users can see you',
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: DropdownButton<String>(
        value: current,
        underline: const SizedBox.shrink(),
        items: const [
          DropdownMenuItem(value: 'public', child: Text('Public')),
          DropdownMenuItem(value: 'private', child: Text('Private')),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _BiometricTile extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onToggle;

  const _BiometricTile({required this.enabled, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.fingerprint,
          color: Theme.of(context).colorScheme.primary, size: 22),
      title: const Text('Biometric Login',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(
          enabled ? 'Face ID / Touch ID enabled' : 'Tap to set up biometric login',
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Switch.adaptive(
        value: enabled,
        onChanged: onToggle,
        activeTrackColor: Theme.of(context).colorScheme.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
