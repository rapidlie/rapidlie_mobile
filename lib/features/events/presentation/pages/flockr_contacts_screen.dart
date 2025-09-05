import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/contacts/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:rapidlie/features/contacts/blocs/flockr_contacts_bloc/telephone_numbers_bloc.dart';
import 'package:rapidlie/features/contacts/models/contact_details.dart';
import 'package:rapidlie/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/blocs/invite_contact_bloc/invite_contact_bloc.dart';
import 'package:rapidlie/features/events/blocs/invite_contact_bloc/invite_contact_event.dart';
import 'package:rapidlie/features/events/blocs/invite_contact_bloc/invite_contact_state.dart';

class FlockrContactsScreen extends StatefulWidget {
  final String id;
  FlockrContactsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<FlockrContactsScreen> createState() => _FlockrContactsScreenState();
}

class _FlockrContactsScreenState extends State<FlockrContactsScreen> {
  List<ContactDetails> fetchedContacts = [];
  List<ContactDetails> _selectedContacts = [];

  List<ContactDetails> flockrContacts = [];
  List<Contact> contacts = [];
  bool isLoading = true;

  Future<void> getCustomContacts() async {
    setState(() {
      fetchedContacts = contacts.map((contact) {
        return ContactDetails(
          name: contact.displayName,
          telephone:
              contact.phones.isNotEmpty ? contact.phones.first.number : null,
        );
      }).toList();
      isLoading = false;
    });
  }

  initState() {
    super.initState();
    contacts = context.read<ContactsBloc>().cachedContacts;
    final numbersBloc = context.read<TelephoneNumbersBloc>();
    if (numbersBloc.state is! TelephoneNumbersLoaded) {
      numbersBloc.add(GetNumbers());
    }
    getCustomContacts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InviteContactBloc, InviteContactState>(
        listener: (context, state) {
      if (state is InviteContactSuccess) {
        context.read<PrivateEventBloc>().add(GetPrivateEvents());
        context.read<PublicEventBloc>().add(GetPublicEvents());
        context.read<InvitedEventBloc>().add(GetInvitedEvents());

        context.read<PrivateEventBloc>().invalidateCache();
        context.read<PublicEventBloc>().invalidateCache();
        context.read<InvitedEventBloc>().invalidateCache();
        context.go("/bottom_nav", extra: 1);
      } else if (state is InviteContactError) {
        AppSnackbars.showError(
            context, 'Failed to send invitations. Please try again.');
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: SafeArea(
            child: AppBarTemplate(
              pageTitle: "Contacts",
              isSubPage: true,
              trailingWidget: _selectedContacts.length == 0
                  ? GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Text(
                        "Cancel",
                        style: poppins14black500(),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        BlocProvider.of<InviteContactBloc>(context).add(
                          SubmitInviteContactEvent(
                            guests: _selectedContacts
                                .map((contact) => contact.telephone ?? '')
                                .toList(),
                            id: widget.id,
                          ),
                        );
                      },
                      child: Text(
                        "Done",
                        style: poppins14black500(),
                      ),
                    ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<TelephoneNumbersBloc, TelephoneNumbersState>(
                  builder: (context, state) {
                    if (state is TelephoneNumbersLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TelephoneNumbersLoaded) {
                      flockrContacts.clear();
                      for (int i = 0; i < fetchedContacts.length; i++) {
                        String? contactPhone = fetchedContacts[i].telephone;
                        if (contactPhone != null && contactPhone.length >= 9) {
                          String contactLastNine =
                              contactPhone.substring(contactPhone.length - 9);

                          contactLastNine =
                              contactLastNine.replaceAll(RegExp(r'\D'), '');

                          if (state.numbers.any((number) {
                            String cleanedStateNumber =
                                number.replaceAll(RegExp(r'\D'), '');
                            return cleanedStateNumber.endsWith(contactLastNine);
                          })) {
                            flockrContacts.add(fetchedContacts[i]);
                          }
                        }
                      }
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: flockrContacts.length,
                      itemBuilder: (context, index) {
                        return ContactListItemWithSelector(
                          contactName: flockrContacts[index].name,
                          value: flockrContacts[index].isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              flockrContacts[index].isSelected = value ?? false;
                              _selectedContacts = flockrContacts
                                  .where((contact) => contact.isSelected)
                                  .toList();
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
