import 'package:flutter/material.dart';
import 'package:rapidlie/core/constants/feature_contants.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';

class ChatTextboxWidget extends StatefulWidget {
  final TextEditingController controller;
  const ChatTextboxWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  State<ChatTextboxWidget> createState() => _ChatTextboxWidgetState();
}

class _ChatTextboxWidgetState extends State<ChatTextboxWidget> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      height: height * 0.114,
      width: width,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  enabled = true;
                });
              },
              child: FocusScope(
                child: Focus(
                  onFocusChange: (focus) {
                    enabled = focus;
                  },
                  child: TextFieldTemplate(
                    width: width,
                    controller: widget.controller,
                    height: 40.0,
                    hintText: '',
                    obscureText: false,
                    textInputAction: TextInputAction.send,
                    textInputType: TextInputType.multiline,
                    leftContentPadding: 16,
                    rightContentPadding: 50,
                    enabled: true,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 18,
              child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.send,
                    color: enabled ? Colors.black : Colors.grey,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
