import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/features/sage/blocs/sage_bloc/sage_bloc.dart';
import 'package:rapidlie/features/sage/data/models/sage_model.dart';

class SageScreen extends StatefulWidget {
  final String eventId;
  const SageScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<SageScreen> createState() => _SageScreenState();
}

class _SageScreenState extends State<SageScreen> {
  final _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<SageBloc>()
        .add(FetchSageSuggestions(eventId: widget.eventId));
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAGE — AI Planning'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Question input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      hintText: 'Ask SAGE anything about your event...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<SageBloc, SageState>(
                  builder: (context, state) => IconButton(
                    icon: state is SageLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send),
                    onPressed: state is SageLoading
                        ? null
                        : () => context.read<SageBloc>().add(
                              FetchSageSuggestions(
                                eventId: widget.eventId,
                                question: _questionController.text.trim(),
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SageBloc, SageState>(
              builder: (context, state) {
                if (state is SageLoading) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('SAGE is thinking...'),
                      ],
                    ),
                  );
                }
                if (state is SageError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ButtonTemplate(
                          buttonName: 'Try Again',
                          buttonAction: () =>
                              context.read<SageBloc>().add(
                                    FetchSageSuggestions(
                                        eventId: widget.eventId),
                                  ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is SageLoaded) {
                  return _SuggestionsView(suggestions: state.suggestions);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SageCategory {
  final String title;
  final IconData icon;
  const _SageCategory(this.title, this.icon);
}

class _SuggestionsView extends StatelessWidget {
  final SageSuggestions suggestions;
  const _SuggestionsView({required this.suggestions});

  static const _categories = [
    _SageCategory('Theme & Decor', Icons.palette_outlined),
    _SageCategory('Activities & Entertainment', Icons.celebration_outlined),
    _SageCategory('Catering & Refreshments', Icons.restaurant_outlined),
    _SageCategory('Timeline & Schedule', Icons.schedule_outlined),
    _SageCategory('Logistics & Setup', Icons.checklist_outlined),
    _SageCategory('Guest Engagement', Icons.people_outlined),
  ];

  List<String> _itemsFor(int index) {
    switch (index) {
      case 0:
        return suggestions.themeAndDecor;
      case 1:
        return suggestions.activitiesAndEntertainment;
      case 2:
        return suggestions.cateringAndRefreshments;
      case 3:
        return suggestions.timelineAndSchedule;
      case 4:
        return suggestions.logisticsAndSetup;
      case 5:
        return suggestions.guestEngagement;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Pro tip banner
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  suggestions.proTip,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Category sections
        ...List.generate(_categories.length, (i) {
          final items = _itemsFor(i);
          if (items.isEmpty) return const SizedBox.shrink();
          return _CategorySection(
            title: _categories[i].title,
            icon: _categories[i].icon,
            items: items,
          );
        }),
      ],
    );
  }
}

class _CategorySection extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  const _CategorySection(
      {required this.title, required this.icon, required this.items});

  @override
  State<_CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(widget.icon,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(widget.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14.sp)),
              trailing: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more),
              onTap: () => setState(() => _expanded = !_expanded),
            ),
            if (_expanded) ...[
              const Divider(height: 1),
              ...widget.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_right, size: 18),
                        const SizedBox(width: 6),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  )),
              const SizedBox(height: 4),
            ],
          ],
        ),
      ),
    );
  }
}
