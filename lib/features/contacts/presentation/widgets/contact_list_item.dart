import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class ContactListItem extends StatelessWidget {
  final String contactName;

  const ContactListItem({Key? key, required this.contactName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            /* border: Border.all(
              color: Colors.black,
            ), */
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              contactName[0],
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          contactName,
          style: poppins14black500(),
        )
      ],
    );
  }
}

class InvitedContactListItem extends StatelessWidget {
  final String contactName;
  const InvitedContactListItem({Key? key, required this.contactName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ContactListItem(contactName: contactName),
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.close,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ],
    );
  }
}
