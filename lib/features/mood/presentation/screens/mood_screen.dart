import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/utils/app_theme.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: 'How are you feeling?',
          isSubPage: true,
        ),
      ),
      body: BlocConsumer<MoodBloc, MoodState>(
        listener: (context, state) {
          if (state is MoodSetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Mood set! Finding events for you...')),
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

          final moods =
              state is MoodOptionsLoaded ? state.moods : <MoodOption>[];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Pick your vibe and we\'ll suggest the perfect events for you.',
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 13.sp,
                  ),
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
                child: GestureDetector(
                  onTap: _selected == null
                      ? null
                      : () =>
                          context.read<MoodBloc>().add(SetMood(_selected!)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _selected != null
                          ? AppColors.darkCard
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: _selected != null
                          ? Border.all(
                              color: const Color(0xFF3C3C3C), width: 1)
                          : null,
                      boxShadow: _selected != null
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        'Find My Events',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: _selected != null
                              ? Colors.white
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2A2A2A), Color(0xFF1C1C1C)],
                )
              : null,
          color: isSelected
              ? null
              : Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkCard
                  : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mood.emoji, style: TextStyle(fontSize: 36.sp)),
            const SizedBox(height: 6),
            Text(
              mood.label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
