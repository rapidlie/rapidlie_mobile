import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/contacts/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:rapidlie/features/contacts/blocs/flockr_contacts_bloc/telephone_numbers_bloc.dart';
import 'package:rapidlie/features/contacts/models/matched_user_model.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen>
    with AutomaticKeepAliveClientMixin {
  List<Contact> _deviceContacts = [];
  bool _matchTriggered = false;

  void _inviteFriend(String? phone) async {
    if (phone == null || phone.isEmpty) {
      AppSnackbars.showError(
          context, AppLocalizations.of(context).unavailablePhoneNumber);
      return;
    }
    final message = AppLocalizations.of(context).inviteMessage;
    final uri = Uri.parse('sms:$phone?body=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        AppSnackbars.showError(
            context, AppLocalizations.of(context).unsentInvite);
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _deviceContacts = context.read<ContactsBloc>().cachedContacts;
    final numbersBloc = context.read<TelephoneNumbersBloc>();
    if (numbersBloc.state is! TelephoneNumbersLoaded) {
      numbersBloc.add(GetNumbers());
    }
    _triggerMatch();
  }

  void _triggerMatch() {
    if (_matchTriggered) return;
    _matchTriggered = true;
    final phoneNumbers = _deviceContacts
        .where((c) => c.phones.isNotEmpty)
        .map((c) => c.phones.first.number)
        .toList();
    if (phoneNumbers.isNotEmpty) {
      context.read<ContactsBloc>().add(MatchContactsEvent(phoneNumbers));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final language = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.contacts,
          isSubPage: true,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (context, state) {
            if (state is ContactMatchLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final matchedUsers = state is ContactMatchLoaded
                ? state.users
                : <MatchedUserModel>[];

            return CustomScrollView(
              slivers: [
                // Flockr contacts section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Text(
                      language.flockrContacts,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ),
                ),
                if (matchedUsers.isEmpty && state is! ContactMatchLoading)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Text(
                        'None of your contacts are on Flockr yet.',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.colorScheme.outline),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final user = matchedUsers[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundColor: primary.withValues(alpha: 0.1),
                            backgroundImage: user.avatar != null &&
                                    user.avatar!.isNotEmpty
                                ? NetworkImage(user.avatar!)
                                : null,
                            child: (user.avatar == null || user.avatar!.isEmpty)
                                ? Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.w600),
                                  )
                                : null,
                          ),
                          title: Text(user.name,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          subtitle: Text(user.phone,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: theme.colorScheme.outline)),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'On Flockr',
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(color: primary),
                            ),
                          ),
                        );
                      },
                      childCount: matchedUsers.length,
                    ),
                  ),

                // Divider
                const SliverToBoxAdapter(child: Divider(height: 24)),

                // Invite section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Text(
                      language.inviteToFlockr,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final contact = _deviceContacts[index];
                      final phone = contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : null;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          child: Text(
                            contact.displayName.isNotEmpty
                                ? contact.displayName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        title: Text(contact.displayName,
                            style: theme.textTheme.bodyMedium),
                        subtitle: phone != null
                            ? Text(phone,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.outline))
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.send_outlined,
                              size: 20, color: primary),
                          tooltip: 'Invite',
                          onPressed: () => _inviteFriend(phone),
                        ),
                      );
                    },
                    childCount: _deviceContacts.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }
}
