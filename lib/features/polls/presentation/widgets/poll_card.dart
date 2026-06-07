import 'package:flutter/material.dart';
import 'package:rapidlie/features/polls/data/models/poll_model.dart';

class PollCard extends StatefulWidget {
  final PollModel poll;
  final bool isOrganizer;
  final void Function(List<String> optionIds) onVote;
  final VoidCallback onDelete;

  const PollCard({
    Key? key,
    required this.poll,
    required this.isOrganizer,
    required this.onVote,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final poll = widget.poll;
    final canVote = !poll.hasVoted && !poll.isExpired;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(poll.question,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                if (widget.isOrganizer)
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 20),
                    onPressed: widget.onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            if (poll.isExpired)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('Poll ended',
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 12)),
              ),
            const SizedBox(height: 12),
            ...poll.options.map((opt) => _OptionRow(
                  option: opt,
                  showResults: poll.hasVoted || poll.isExpired,
                  isSelected: _selected.contains(opt.id),
                  canVote: canVote,
                  onTap: canVote
                      ? () {
                          setState(() {
                            if (poll.isMultiple) {
                              if (_selected.contains(opt.id)) {
                                _selected.remove(opt.id);
                              } else {
                                _selected.add(opt.id);
                              }
                            } else {
                              _selected
                                ..clear()
                                ..add(opt.id);
                            }
                          });
                        }
                      : null,
                )),
            if (canVote && _selected.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      widget.onVote(_selected.toList()),
                  child: const Text('Submit Vote'),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${poll.totalVotes} vote${poll.totalVotes == 1 ? '' : 's'}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final PollOption option;
  final bool showResults;
  final bool isSelected;
  final bool canVote;
  final VoidCallback? onTap;

  const _OptionRow({
    required this.option,
    required this.showResults,
    required this.isSelected,
    required this.canVote,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (canVote)
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: isSelected ? primary : Colors.grey,
                  ),
                if (canVote) const SizedBox(width: 8),
                Expanded(
                  child: Text(option.text,
                      style: TextStyle(
                          fontWeight: isSelected || option.hasVoted
                              ? FontWeight.w600
                              : FontWeight.normal)),
                ),
                if (showResults)
                  Text('${option.percentage}%',
                      style: TextStyle(
                          fontSize: 12,
                          color: option.hasVoted ? primary : Colors.grey)),
              ],
            ),
            if (showResults) ...[
              const SizedBox(height: 4),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: option.percentage / 100),
                duration: const Duration(milliseconds: 600),
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  color: option.hasVoted ? primary : Colors.grey,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
