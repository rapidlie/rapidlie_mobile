import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/contributions/blocs/contribution_bloc/contribution_bloc.dart';
import 'package:rapidlie/features/contributions/data/models/contribution_model.dart';

class MyContributionsScreen extends StatefulWidget {
  const MyContributionsScreen({Key? key}) : super(key: key);

  @override
  State<MyContributionsScreen> createState() => _MyContributionsScreenState();
}

class _MyContributionsScreenState extends State<MyContributionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ContributionBloc>().add(const FetchMyContributions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: 'My Contributions',
          isSubPage: true,
        ),
      ),
      body: BlocBuilder<ContributionBloc, ContributionState>(
        builder: (context, state) {
          if (state is ContributionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyContributionsLoaded) {
            final items = state.contributions;
            if (items.isEmpty) {
              return const Center(
                child: Text('You haven\'t contributed to any events yet'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<ContributionBloc>()
                  .add(const FetchMyContributions()),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _ContributionCard(item: items[i]),
              ),
            );
          }
          if (state is ContributionError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ContributionCard extends StatelessWidget {
  final ContributionModel item;
  const _ContributionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.volunteer_activism, color: primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.transactionRef,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.createdAt,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.currency} ${item.amount.toStringAsFixed(2)}',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: primary),
              ),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Paid',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.green)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
