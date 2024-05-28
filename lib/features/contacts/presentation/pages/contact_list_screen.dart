import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/contact_details.dart';

class ContactListScreen extends StatefulWidget {
  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List contacts = [
    "Eugene Asiedu",
    "Daniel Rodriguez",
    "Jedidah Amanor",
    "Sylivia Nataka",
    "Yaw Asiedu"
  ];

  bool isLoading = true;

  List<ContactDetails> _contacts = [];
  List<ContactDetails> _selectedContacts = [];

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
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    // Check current permission status
    PermissionStatus permissionStatus = await Permission.contacts.status;

    // Request permission if not already granted
    if (permissionStatus.isDenied || permissionStatus.isRestricted) {
      permissionStatus = await Permission.contacts.request();
    }

    // If permission is granted, fetch contacts
    if (permissionStatus.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts.map((contact) {
          return ContactDetails(
            name: contact.displayName ?? contact.phones!.first.value ?? '',
            telephone: contact.phones!.isNotEmpty
                ? contact.phones!.first.value ?? ''
                : '',
          );
        }).toList();
        isLoading = false;
      });
    } else if (permissionStatus.isPermanentlyDenied) {
      // Show dialog guiding user to app settings
      _showOpenAppSettingsDialog();
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showOpenAppSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission required"),
          content: Text(
            "This app needs contact permissions to function. Please go to settings and enable the permissions.",
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Open Settings"),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: height,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 150.0),
                    child: ListView.builder(
                      itemCount: _contacts.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        /* String contactNumber =
                            _contacts[index].telephone!.isNotEmpty
                                ? _contacts[index].telephone!.first.value ??
                                    'No Number'
                                : 'No Number'; */
                        return Tooltip(
                          message: _contacts[index].telephone,
                          verticalOffset: 0,
                          preferBelow: true,
                          showDuration: Duration(seconds: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: poppins10white500(),
                          child: ContactListItemWithSelector(
                            contactName: _contacts[index].name,
                            value: _contacts[index].isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                _contacts[index].isSelected = value ?? false;
                                _selectedContacts = _contacts
                                    .where((contact) => contact.isSelected)
                                    .toList();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
