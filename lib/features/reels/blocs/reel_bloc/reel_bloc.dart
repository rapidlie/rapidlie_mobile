import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/reels/data/models/reel_model.dart';
import 'package:rapidlie/features/reels/data/repository/reel_repository.dart';

part 'reel_event.dart';
part 'reel_state.dart';

class ReelBloc extends Bloc<ReelEvent, ReelState> {
  final ReelRepository reelRepository;

  ReelBloc({required this.reelRepository}) : super(ReelInitial()) {
    on<FetchReels>(_onFetchReels);
    on<PostReel>(_onPostReel);
    on<DeleteReel>(_onDeleteReel);
    on<ToggleReelLike>(_onToggleReelLike);
  }

  Future<void> _onFetchReels(FetchReels event, Emitter<ReelState> emit) async {
    emit(ReelLoading());
    final result = await reelRepository.getReels(event.eventId);
    if (result is DataSuccess<List<ReelModel>>) {
      emit(ReelsLoaded(result.data!));
    } else {
      emit(ReelError(result.error?.response?.data['message'] as String? ??
          'Failed to load reels'));
    }
  }

  Future<void> _onPostReel(PostReel event, Emitter<ReelState> emit) async {
    emit(ReelUploading());
    final result = await reelRepository.postReel(
      eventId: event.eventId,
      mediaUrl: event.mediaUrl,
      mediaType: event.mediaType,
      caption: event.caption,
    );
    if (result is DataSuccess<ReelModel>) {
      emit(ReelUploadSuccess(result.data!));
    } else {
      emit(ReelError(result.error?.response?.data['message'] as String? ??
          'Failed to post reel'));
    }
  }

  Future<void> _onDeleteReel(
      DeleteReel event, Emitter<ReelState> emit) async {
    final result = await reelRepository.deleteReel(event.reelId);
    if (result is DataSuccess<String>) {
      emit(ReelDeleteSuccess(event.reelId));
    } else {
      emit(ReelError(result.error?.response?.data['message'] as String? ??
          'Failed to delete reel'));
    }
  }

  Future<void> _onToggleReelLike(
      ToggleReelLike event, Emitter<ReelState> emit) async {
    final result = event.like
        ? await reelRepository.likeReel(event.reelId)
        : await reelRepository.unlikeReel(event.reelId);
    if (result is DataSuccess<String>) {
      emit(ReelLikeToggled(reelId: event.reelId, isLiked: event.like));
    }
  }
}
