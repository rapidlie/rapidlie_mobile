import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';

class InvitesListItem extends StatelessWidget {
  const InvitesListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_2_outlined,
              color: Colors.grey,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Eugene Ofori Asiedu",
              style: poppins14black500(),
            ),
          ],
        ),
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
