import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/contacts/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:rapidlie/features/contacts/blocs/flockr_contacts_bloc/telephone_numbers_bloc.dart';
import 'package:rapidlie/features/contacts/models/contact_details.dart';
import 'package:rapidlie/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListScreen extends StatefulWidget {
  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  var language;

  List<ContactDetails> fetchedContacts = [];
  List<ContactDetails> _selectedContacts = [];
  late TextEditingController searchController;
  List<ContactDetails> flockrContacts = [];
  List<Contact> contacts = [];

  void inviteFriend(String? phone, BuildContext context) async {
    if (phone != null && phone.isNotEmpty) {
      String message = AppLocalizations.of(context).inviteMessage;
      String encodedMessage = Uri.encodeComponent(message);
      String smsUrl = "sms:$phone?body=$encodedMessage";

      if (await canLaunchUrl(Uri.parse(smsUrl))) {
        await launchUrl(Uri.parse(smsUrl));
      } else {
        AppSnackbars.showError(
            context, AppLocalizations.of(context).unsentInvite);
      }
    } else {
      AppSnackbars.showError(
          context, AppLocalizations.of(context).unavailablePhoneNumber);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
    contacts = context.read<ContactsBloc>().cachedContacts;
    final numbersBloc = context.read<TelephoneNumbersBloc>();
    if (numbersBloc.state is! TelephoneNumbersLoaded) {
      numbersBloc.add(GetNumbers());
    }
    getCustomContacts();
  }

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

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.contacts,
          isSubPage: true,
          trailingWidget: _selectedContacts.length == 0
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    Navigator.pop(context, _selectedContacts);
                  },
                  child: Text(
                    language.done,
                    style: inter14black500(context),
                  ),
                ),
        ),
      ),
      body: isLoading
          ? Center(
              child: SafeArea(child: CircularProgressIndicator()),
            )
          : SafeArea(
            child: Column(
                children: [
                  /* Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFieldTemplate(
                      hintText: language.searchName,
                      controller: searchController,
                      obscureText: false,
                      width: width,
                      height: 40,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      enabled: true,
                    ),
                  ), */
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            smallHeight(),
                            Text(
                              language.flockrContacts,
                              style: inter15black500(context),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Flexible(
                              child: BlocBuilder<TelephoneNumbersBloc,
                                  TelephoneNumbersState>(
                                builder: (context, state) {
                                  if (state is TelephoneNumbersLoaded) {
                                    flockrContacts.clear();
                                    for (int i = 0;
                                        i < fetchedContacts.length;
                                        i++) {
                                      String? contactPhone =
                                          fetchedContacts[i].telephone;
                                      if (contactPhone != null &&
                                          contactPhone.length >= 9) {
                                        String contactLastNine = contactPhone
                                            .substring(contactPhone.length - 9);
            
                                        contactLastNine = contactLastNine
                                            .replaceAll(RegExp(r'\D'), '');
            
                                        if (state.numbers.any((number) {
                                          String cleanedStateNumber = number
                                              .replaceAll(RegExp(r'\D'), '');
                                          return cleanedStateNumber
                                              .endsWith(contactLastNine);
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
                                            flockrContacts[index].isSelected =
                                                value ?? false;
                                            _selectedContacts = flockrContacts
                                                .where((contact) =>
                                                    contact.isSelected)
                                                .toList();
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            //smallHeight(),
                            Text(
                              language.inviteToFlockr,
                              style: inter15black500(context),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Flexible(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: fetchedContacts.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      inviteFriend(
                                          fetchedContacts[index].telephone,
                                          context);
                                    },
                                    child: ContactListItemWithText(
                                      contactName: fetchedContacts[index].name,
                                    ),
                                  );
                                  //return Container();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
    );
  }
}
