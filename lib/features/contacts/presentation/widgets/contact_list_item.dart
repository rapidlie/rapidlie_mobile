import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';

class ContactListItem extends StatelessWidget {
  final String contactName;

  const ContactListItem({
    Key? key,
    required this.contactName,
  }) : super(key: key);

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
            padding: const EdgeInsets.all(10),
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
          style: poppins12CharcoalBlack500(),
        )
      ],
    );
  }
}

class ContactListItemWithSelector extends StatelessWidget {
  final String contactName;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const ContactListItemWithSelector(
      {Key? key,
      required this.contactName,
      required this.value,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ContactListItem(
            contactName: contactName,
          ),
          Container(
            width: 18.0,
            height: 18.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: value ? Colors.deepOrange : Colors.grey,
                width: 1.5,
              ),
              color: value ? Colors.deepOrange : Colors.transparent,
            ),
            child: value
                ? Icon(
                    Icons.check,
                    size: 16.0,
                    color: Colors.white,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class ContactListItemWithText extends StatelessWidget {
  final String contactName;

  const ContactListItemWithText({
    Key? key,
    required this.contactName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ContactListItem(
            contactName: contactName,
          ),
          Text(
            "Invite",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.deepOrange,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
