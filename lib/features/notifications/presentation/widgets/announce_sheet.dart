import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/notifications/blocs/announce_bloc/announce_bloc.dart';

class AnnounceSheet extends StatefulWidget {
  final String eventId;
  const AnnounceSheet({Key? key, required this.eventId}) : super(key: key);

  static void show(BuildContext context, String eventId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AnnounceBloc>(),
        child: AnnounceSheet(eventId: eventId),
      ),
    );
  }

  @override
  State<AnnounceSheet> createState() => _AnnounceSheetState();
}

class _AnnounceSheetState extends State<AnnounceSheet> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String? _titleError;
  String? _messageError;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      _titleError =
          _titleController.text.trim().isEmpty ? 'Title is required' : null;
      _messageError =
          _messageController.text.trim().isEmpty ? 'Message is required' : null;
    });
    return _titleError == null && _messageError == null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnnounceBloc, AnnounceState>(
      listener: (context, state) {
        if (state is AnnounceSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AnnounceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Announcement',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Notify all accepted guests',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            TextFieldTemplate(
              controller: _titleController,
              hintText: 'Title (e.g. Change of venue)',
              obscureText: false,
              width: double.infinity,
              height: 50.h,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              enabled: true,
            ),
            if (_titleError != null) ...[
              const SizedBox(height: 4),
              Text(_titleError!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp)),
            ],
            const SizedBox(height: 12),
            TextFieldTemplate(
              controller: _messageController,
              hintText: 'Message',
              obscureText: false,
              width: double.infinity,
              height: 80.h,
              textInputType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              enabled: true,
              numberOfLines: 3,
            ),
            if (_messageError != null) ...[
              const SizedBox(height: 4),
              Text(_messageError!,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp)),
            ],
            const SizedBox(height: 20),
            BlocBuilder<AnnounceBloc, AnnounceState>(
              builder: (context, state) {
                return ButtonTemplate(
                  buttonName: 'Send',
                  loading: state is AnnounceLoading,
                  buttonAction: () {
                    if (_validate()) {
                      context.read<AnnounceBloc>().add(SendAnnouncement(
                            eventId: widget.eventId,
                            title: _titleController.text.trim(),
                            message: _messageController.text.trim(),
                          ));
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
