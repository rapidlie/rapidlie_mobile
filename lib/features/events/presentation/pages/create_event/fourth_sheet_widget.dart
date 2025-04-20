import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/features/contacts/models/contact_details.dart';
import 'package:rapidlie/features/contacts/presentation/pages/contact_list_screen.dart';
import 'package:rapidlie/features/contacts/presentation/widgets/contact_list_item.dart';
import 'package:rapidlie/features/events/blocs/create_bloc/create_event_bloc.dart';
import 'package:rapidlie/features/events/provider/create_event_provider.dart';
import 'package:rapidlie/features/file_upload/bloc/file_upload_bloc.dart';

class FourthSheetContentWidget extends StatefulWidget {
  final dynamic language;
  final PageController pageViewController;

  FourthSheetContentWidget({
    required this.language,
    required this.pageViewController,
  });

  @override
  _FourthSheetContentWidgetState createState() =>
      _FourthSheetContentWidgetState();
}

class _FourthSheetContentWidgetState extends State<FourthSheetContentWidget> {
  List<ContactDetails> selectedContacts = [];

  void _navigateAndSelectContacts() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactListScreen()),
    );

    if (result != null && result is List<ContactDetails>) {
      setState(() {
        selectedContacts = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocConsumer<FileUploadBloc, FileUploadState>(
      listener: (context, state) {
        if (state is FileUploadInitial) {
          print("File upload initial");
        } else if (state is FileUploadingState) {
          print("File uploading...");
        } else if (state is FileUploadSuccessState) {
          debugPrint("File uploaded successfully");

          context.read<CreateEventProvider>().updateEvent(
                image: state.fileName,
              );
          print(context.read<CreateEventProvider>().event);
          BlocProvider.of<CreateEventBloc>(context).add(
            SubmitCreateEventEvent(
              image: state.fileName,
              name: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .name!,
              eventType:
                  Provider.of<CreateEventProvider>(context, listen: false)
                      .event
                      .eventType!,
              category: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .category!,
              description:
                  Provider.of<CreateEventProvider>(context, listen: false)
                      .event
                      .description!,
              date: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .date!,
              startTime:
                  Provider.of<CreateEventProvider>(context, listen: false)
                      .event
                      .startTime!,
              endTime: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .endTime!,
              venue: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .venue!,
              mapLocation:
                  Provider.of<CreateEventProvider>(context, listen: false)
                      .event
                      .mapLocation!,
              guests: Provider.of<CreateEventProvider>(context, listen: false)
                  .event
                  .guests!,
            ),
          );
        } else if (state is FileUploadFailureState) {
          print(state.error);
        } else {
          print("Unknown state: $state");
        }
      },
      builder: (context, fileUploadState) {
        return BlocConsumer<CreateEventBloc, CreateEventState>(
          listener: (context, state) {
            if (state is CreateEventSuccessful) {
            } else if (state is CreateEventError) {
              print("Error creating event: ${state.message}");
            }
          },
          builder: (context, eventState) {
            if (eventState is CreateEventLoading) {
              print("Event creation loading....");
              return Center(child: CircularProgressIndicator());
            } else if (eventState is CreateEventSuccessful) {
              widget.pageViewController.nextPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            }
            return Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20, right: 20, bottom: 40),
              child: selectedContacts.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _navigateAndSelectContacts();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: CustomColors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: CustomColors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.language.inviteFriends,
                          style: poppins13black400(),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: selectedContacts.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ContactListItem(
                                  contactName: selectedContacts[index].name,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedContacts.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: ButtonTemplate(
                                buttonName: "+",
                                buttonWidth: width,
                                buttonAction: () {
                                  _navigateAndSelectContacts();
                                },
                              ),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              flex: 8,
                              child: ButtonTemplate(
                                buttonName: "Finish",
                                buttonWidth: width,
                                buttonAction: () {
                                  context
                                      .read<CreateEventProvider>()
                                      .updateEvent(
                                        guests: selectedContacts
                                            .map(
                                                (contact) => contact.telephone!)
                                            .toList(),
                                      );
                                  BlocProvider.of<FileUploadBloc>(context).add(
                                    FileUploadEvent(
                                      file: Provider.of<CreateEventProvider>(
                                              context,
                                              listen: false)
                                          .fileUpload
                                          .file!,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}
