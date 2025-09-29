import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/utils/image_picker.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/events/provider/create_event_provider.dart';
import 'dart:io';

class FirstSheetWidget extends StatefulWidget {
  final PageController pageViewController;
  final dynamic language;

  FirstSheetWidget({
    required this.pageViewController,
    required this.language,
  });

  @override
  State<FirstSheetWidget> createState() => _FirstSheetWidgetState();
}

class _FirstSheetWidgetState extends State<FirstSheetWidget> {
  late TextEditingController titleController;
  File? imageFile;

  initState() {
    super.initState();
    titleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.language.eventTitle + '*',
            style: inter12Black400(context),
          ),
          extraSmallHeight(),
          TextFieldTemplate(
            hintText: widget.language.title,
            controller: titleController,
            obscureText: false,
            width: MediaQuery.of(context).size.width,
            height: 50,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enabled: true,
          ),
          smallHeight(),
          Text(
            widget.language.uploadFlyer + '*',
            style: inter12Black400(context),
          ),
          extraSmallHeight(),
          GestureDetector(
            onTap: () async {
              File? file = await ImagePickerUtils.pickImageFromGallery(
                  maxWidth: MediaQuery.of(context).size.width);
              setState(() {
                imageFile = file;
              });
            },
            child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CustomColors.colorFromHex("#C6CDD3")),
              ),
              child: imageFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: 100,
                      color: CustomColors.gray,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: ButtonTemplate(
              buttonName: widget.language.next,
              buttonType: ButtonType.elevated,
              buttonAction: () async {
                if (titleController.text.isEmpty || imageFile == null) {
                  AppSnackbars.showError(context, "All fields are required!");
                  return;
                } else {
                  setState(() {});
                  context.read<CreateEventProvider>().updateEvent(
                        name: titleController.text,
                        file: imageFile,
                      );

                  widget.pageViewController.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
