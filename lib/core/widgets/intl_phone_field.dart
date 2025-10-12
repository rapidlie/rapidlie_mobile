import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class IntlPhoneField extends StatelessWidget {
  final TextEditingController controller;

  IntlPhoneField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.13)),
        boxShadow: [
          BoxShadow(
            color: Color(0xffeeeeee),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          InternationalPhoneNumberInput(
            onInputChanged: (value) {},
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.DROPDOWN,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: TextStyle(color: Colors.black),
            textFieldController: controller,
            formatInput: false,
            maxLength: 9,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            cursorColor: Colors.black,
            inputDecoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 15, left: 0),
              border: InputBorder.none,
              hintText: 'Phone number',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
            onSaved: (PhoneNumber number) {},
          ),
          Positioned(
            left: 90,
            top: 8,
            bottom: 8,
            child: Container(
              height: 40,
              width: 1,
              color: Colors.black.withOpacity(0.13),
            ),
          ),
        ],
      ),
    );
  }
}
