import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/contacts/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:rapidlie/features/contacts/blocs/flockr_contacts_bloc/telephone_numbers_bloc.dart';
import 'package:rapidlie/features/contacts/models/contact_details.dart';
import 'package:rapidlie/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListScreen extends StatefulWidget {
  static const String routeName = "contacts";
  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;

  List<ContactDetails> fetchedContacts = [];
  List<ContactDetails> _selectedContacts = [];
  late TextEditingController searchController;
  List<ContactDetails> flockrContacts = [];
  List<Contact> contacts = [];

  void inviteFriend() async {
    String message = "Hey, check out this cool event app!";
    String encodedMessage = Uri.encodeComponent(message);
    String smsUrl = "sms:?body=$encodedMessage";

    if (await canLaunchUrl(Uri.parse(smsUrl))) {
      await launchUrl(Uri.parse(smsUrl));
    } else {
      throw "Could not launch $smsUrl";
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
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: AppBarTemplate(
            pageTitle: "Contacts",
            isSubPage: true,
            trailingWidget: _selectedContacts.length == 0
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      Navigator.pop(context, _selectedContacts);
                    },
                    child: Text(
                      'Done',
                      style: poppins14black500(),
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
                    hintText: "Search name or number",
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
                            'Contacts on Flockr',
                            style: inter15black500(),
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
                            'Invite to Flockr',
                            style: inter15black500(),
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
                                    print(fetchedContacts[index].telephone);
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
