import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/features/mood/blocs/mood_bloc/mood_bloc.dart';
import 'package:rapidlie/features/mood/data/models/mood_model.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({Key? key}) : super(key: key);

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    context.read<MoodBloc>().add(const FetchMoods());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling?'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<MoodBloc, MoodState>(
        listener: (context, state) {
          if (state is MoodSetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Mood set! Finding events for you...')),
            );
            context.read<MoodBloc>().add(const FetchMoodSuggestions());
            context.pushReplacementNamed('mood_events');
          } else if (state is MoodError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is MoodLoading || state is MoodSetting) {
            return const Center(child: CircularProgressIndicator());
          }

          final moods = state is MoodOptionsLoaded ? state.moods : <MoodOption>[];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Pick your vibe and we\'ll suggest the perfect events for you.',
                  style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: moods.length,
                  itemBuilder: (_, i) => _MoodTile(
                    mood: moods[i],
                    isSelected: _selected == moods[i].value,
                    onTap: () =>
                        setState(() => _selected = moods[i].value),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                child: ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () => context
                          .read<MoodBloc>()
                          .add(SetMood(_selected!)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Find My Events'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MoodTile extends StatelessWidget {
  final MoodOption mood;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodTile(
      {required this.mood,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? primary.withValues(alpha: 0.12)
              : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected ? primary : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mood.emoji, style: TextStyle(fontSize: 32.sp)),
            const SizedBox(height: 6),
            Text(
              mood.label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: isSelected ? primary : null),
            ),
          ],
        ),
      ),
    );
  }
}
