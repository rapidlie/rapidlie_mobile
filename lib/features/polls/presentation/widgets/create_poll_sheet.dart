import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/features/polls/blocs/poll_bloc/poll_bloc.dart';

class CreatePollSheet extends StatefulWidget {
  final String eventId;
  const CreatePollSheet({Key? key, required this.eventId}) : super(key: key);

  static void show(BuildContext context, String eventId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(
        value: context.read<PollBloc>(),
        child: CreatePollSheet(eventId: eventId),
      ),
    );
  }

  @override
  State<CreatePollSheet> createState() => _CreatePollSheetState();
}

class _CreatePollSheetState extends State<CreatePollSheet> {
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  String _type = 'single';
  String? _error;

  @override
  void dispose() {
    _questionController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    if (_optionControllers.length >= 10) return;
    setState(() => _optionControllers.add(TextEditingController()));
  }

  void _removeOption(int index) {
    if (_optionControllers.length <= 2) return;
    setState(() {
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
    });
  }

  void _submit() {
    final question = _questionController.text.trim();
    final options = _optionControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (question.isEmpty) {
      setState(() => _error = 'Question is required');
      return;
    }
    if (options.length < 2) {
      setState(() => _error = 'At least 2 options required');
      return;
    }

    setState(() => _error = null);
    context.read<PollBloc>().add(CreatePoll(
          eventId: widget.eventId,
          question: question,
          type: _type,
          options: options,
        ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Poll',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                hintText: 'Ask a question...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Type:',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Single'),
                  selected: _type == 'single',
                  onSelected: (_) => setState(() => _type = 'single'),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Multiple'),
                  selected: _type == 'multiple',
                  onSelected: (_) => setState(() => _type = 'multiple'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Options',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14.sp)),
            const SizedBox(height: 8),
            ...List.generate(
              _optionControllers.length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _optionControllers[i],
                        decoration: InputDecoration(
                          hintText: 'Option ${i + 1}',
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    if (_optionControllers.length > 2)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () => _removeOption(i),
                      ),
                  ],
                ),
              ),
            ),
            if (_optionControllers.length < 10)
              TextButton.icon(
                onPressed: _addOption,
                icon: const Icon(Icons.add),
                label: const Text('Add Option'),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12)),
              ),
            const SizedBox(height: 8),
            BlocBuilder<PollBloc, PollState>(
              builder: (context, state) => ButtonTemplate(
                buttonName: 'Create Poll',
                loading: state is PollCreating,
                buttonAction: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
