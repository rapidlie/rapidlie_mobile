import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/chat/presentation/widgets/chat_textbox_widget.dart';
import 'package:rapidlie/features/chat/presentation/widgets/message_item_widget.dart';

class ChatScreen extends StatelessWidget {
  final String eventName;
  late TextEditingController controller = TextEditingController();
  ChatScreen({Key? key, required this.eventName}) : super(key: key);

  List messagesList = [
    {"message": "Hello! I was busy at work.", "date": "6/10/2022"},
    {
      "message":
          "Hello! I was busy at work. I have some availability at the end of June. I hope to see you then!",
      "date": "6/10/2022"
    },
    {"message": "I hope to see you then!", "date": "6/10/2022"},
    {
      "message": "I have some availability at the end of June.",
      "date": "7/10/2022"
    },
    {
      "message": "Hello! I was busy at work. Nice to meet you.",
      "date": "7/10/2022"
    },
    {"message": "Hello!", "messageType": "received", "date": "8/10/2022"},
    {
      "message": "Hello! I was busy at work. Nice to meet you.",
      "date": "8/10/2022"
    },
    {
      "message":
          "Hello! I was busy at work. Nice to meet you. I know my schedule is pretty full, I’m sorry. I have some availability at the end of June. I hope to see you then!",
      "date": "8/10/2022"
    },
    {
      "message":
          "Hello! I was busy at work. Nice to meet you. I know my schedule is pretty full, I’m sorry. I have some availability at the end of June. I hope to see you then!",
      "date": "8/10/2022"
    },
    {"message": "Hello! I was busy at work.", "date": "9/10/2022"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: AppBarTemplate(
            pageTitle: eventName,
            isSubPage: true,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GroupedListView<dynamic, String>(
              elements: messagesList,
              groupBy: (element) => element["date"],
              groupComparator: (value1, value2) => value2.compareTo(value1),
              itemComparator: (item1, item2) =>
                  item1['message'].compareTo(item2['message']),
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: false,
              floatingHeader: false,
              stickyHeaderBackgroundColor: Colors.transparent,
              groupSeparatorBuilder: (String value) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
              itemBuilder: (c, element) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 2.0,
                    bottom: 2.0,
                    left: 18,
                    right: 50,
                  ),
                  child: MessageItemWidget(
                    message: element["message"],
                    imageLocation: "assets/images/usr1.png",
                  ),
                );
              },
            ),
          ),
          ChatTextboxWidget(
            controller: controller,
          ),
        ],
      ),
    );
  }
}
