import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/polls/blocs/poll_bloc/poll_bloc.dart';
import 'package:rapidlie/features/polls/data/models/poll_model.dart';
import 'package:rapidlie/features/polls/presentation/widgets/create_poll_sheet.dart';
import 'package:rapidlie/features/polls/presentation/widgets/poll_card.dart';

class PollsScreen extends StatefulWidget {
  final String eventId;
  final bool isOrganizer;

  const PollsScreen(
      {Key? key, required this.eventId, required this.isOrganizer})
      : super(key: key);

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PollBloc>().add(FetchPolls(widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PollBloc, PollState>(
      listener: (context, state) {
        if (state is PollCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Poll created!')),
          );
          context.read<PollBloc>().add(FetchPolls(widget.eventId));
        } else if (state is PollVoteSuccess) {
          context.read<PollBloc>().add(FetchPolls(widget.eventId));
        } else if (state is PollDeleteSuccess) {
          context.read<PollBloc>().add(FetchPolls(widget.eventId));
        } else if (state is PollError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: AppBarTemplate(pageTitle: 'Polls', isSubPage: true),
          ),
          floatingActionButton: widget.isOrganizer
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => CreatePollSheet.show(
                      context, widget.eventId),
                )
              : null,
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(PollState state) {
    if (state is PollLoading || state is PollCreating) {
      return const Center(child: CircularProgressIndicator());
    }

    List<PollModel> polls = [];
    if (state is PollsLoaded) polls = state.polls;

    if (polls.isEmpty) {
      return const Center(child: Text('No polls yet'));
    }

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<PollBloc>().add(FetchPolls(widget.eventId)),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: polls.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => PollCard(
          poll: polls[i],
          isOrganizer: widget.isOrganizer,
          onVote: (optionIds) => context.read<PollBloc>().add(
                VoteOnPoll(pollId: polls[i].id, optionIds: optionIds),
              ),
          onDelete: () => context
              .read<PollBloc>()
              .add(DeletePoll(polls[i].id)),
        ),
      ),
    );
  }
}
