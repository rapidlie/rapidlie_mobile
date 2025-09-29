import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
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
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
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
                ),
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
    );
  }
}


/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
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

  List<ContactDetails> fetchedContacts = []; // All local contacts
  List<ContactDetails> _flockrContacts = []; // Source list: Contacts on Flockr
  List<ContactDetails> _inviteContacts =
      []; // Source list: Contacts NOT on Flockr

  List<ContactDetails> _filteredFlockrContacts =
      []; // Display list for Flockr users
  List<ContactDetails> _filteredInviteContacts =
      []; // Display list for Invite users

  List<ContactDetails> _selectedContacts = [];
  late TextEditingController searchController;
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
    // Initialize TextEditingController and add listener for filtering
    searchController = TextEditingController();
    searchController.addListener(_filterContacts);

    contacts = context.read<ContactsBloc>().cachedContacts;
    final numbersBloc = context.read<TelephoneNumbersBloc>();
    if (numbersBloc.state is! TelephoneNumbersLoaded) {
      numbersBloc.add(GetNumbers());
    }
    getCustomContacts();
  }

  // Converts FlutterContacts data into our ContactDetails model
  Future<void> getCustomContacts() async {
    setState(() {
      fetchedContacts = contacts.map((contact) {
        return ContactDetails(
          name: contact.displayName,
          telephone:
              contact.phones.isNotEmpty ? contact.phones.first.number : null,
        );
      }).toList();

      // Initialize filtered lists before processing by the BlocListener
      _filteredInviteContacts = fetchedContacts;
      _filteredFlockrContacts = [];
      isLoading = false;
    });

    // If numbers are already loaded (e.g., from cache), process them immediately.
    final numbersState = context.read<TelephoneNumbersBloc>().state;
    if (numbersState is TelephoneNumbersLoaded) {
      _processContacts(numbersState.numbers);
    }
  }

  // Filters the displayed lists based on the search query
  void _filterContacts() {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredFlockrContacts = _flockrContacts;
        _filteredInviteContacts = _inviteContacts;
      });
    } else {
      setState(() {
        _filteredFlockrContacts = _flockrContacts
            .where((contact) => contact.name.toLowerCase().contains(query))
            .toList();

        _filteredInviteContacts = _inviteContacts
            .where((contact) => contact.name.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  // Separates all local contacts into Flockr and non-Flockr lists
  void _processContacts(List<String> flockrNumbers) {
    _flockrContacts.clear();
    _inviteContacts.clear();

    for (final contact in fetchedContacts) {
      String? contactPhone = contact.telephone;
      bool isFlockr = false;

      if (contactPhone != null && contactPhone.length >= 9) {
        // Clean and isolate last 9 digits of local contact phone number
        String contactLastNine = contactPhone
            .substring(contactPhone.length - 9)
            .replaceAll(RegExp(r'\D'), '');

        // Check against the list of Flockr phone numbers
        isFlockr = flockrNumbers.any((number) {
          String cleanedStateNumber = number.replaceAll(RegExp(r'\D'), '');
          return cleanedStateNumber.endsWith(contactLastNine);
        });
      }

      if (isFlockr) {
        _flockrContacts.add(contact);
      } else {
        _inviteContacts.add(contact);
      }
    }

    // Apply the current filter (which might be empty) after separation
    _filterContacts();
  }

  // Handles updating the selection status and rebuilding the selected list
  void _updateSelectedContacts(ContactDetails contact, bool isSelected) {
    setState(() {
      // Find the contact in the source list and update its state
      final targetList =
          _flockrContacts.contains(contact) ? _flockrContacts : _inviteContacts;
      final index = targetList.indexWhere(
          (c) => c.name == contact.name && c.telephone == contact.telephone);
      if (index != -1) {
        targetList[index].isSelected = isSelected;
      }

      // Rebuild the final list of selected contacts from all source lists
      _selectedContacts = [
        ..._flockrContacts.where((c) => c.isSelected),
      ];
      // Note: Only Flockr contacts are selectable according to the original code structure.
    });
  }

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    super.build(context);
    double width = MediaQuery.of(context).size.width;

    // Use BlocListener to trigger contact separation when Flockr numbers are loaded
    return BlocListener<TelephoneNumbersBloc, TelephoneNumbersState>(
      listener: (context, state) {
        if (state is TelephoneNumbersLoaded) {
          _processContacts(state.numbers);
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: SafeArea(
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
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFieldTemplate(
                      hintText: language.searchName,
                      controller: searchController,
                      obscureText: false,
                      width: width,
                      height: 40,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      enabled: true,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            smallHeight(),
                            // Flockr Contacts List
                            if (_filteredFlockrContacts.isNotEmpty) ...[
                              Text(
                                language.flockrContacts,
                                style: inter15black500(context),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Flexible(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _filteredFlockrContacts.length,
                                  itemBuilder: (context, index) {
                                    final contact =
                                        _filteredFlockrContacts[index];
                                    return ContactListItemWithSelector(
                                      contactName: contact.name,
                                      value: contact.isSelected,
                                      onChanged: (bool? value) {
                                        _updateSelectedContacts(
                                            contact, value ?? false);
                                      },
                                    );
                                  },
                                ),
                              ),
                              smallHeight(), // Spacing before the next section
                            ],

                            // Invite to Flockr List
                            if (_filteredInviteContacts.isNotEmpty) ...[
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
                                  itemCount: _filteredInviteContacts.length,
                                  itemBuilder: (context, index) {
                                    final contact =
                                        _filteredInviteContacts[index];
                                    return GestureDetector(
                                      onTap: () {
                                        inviteFriend(
                                            contact.telephone, context);
                                      },
                                      child: ContactListItemWithText(
                                        contactName: contact.name,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                            // Handle case where no results are found after filtering
                            if (_filteredFlockrContacts.isEmpty &&
                                _filteredInviteContacts.isEmpty &&
                                searchController.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Center(
                                  child: Text(
                                    "language.noContactsFound", // assuming you have this localized string
                                    style: inter14black500(context),
                                  ),
                                ),
                              )
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
} */
