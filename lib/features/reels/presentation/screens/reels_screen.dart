import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rapidlie/core/utils/render_image.dart';
import 'package:rapidlie/features/file_upload/bloc/file_upload_bloc.dart';
import 'package:rapidlie/features/reels/blocs/reel_bloc/reel_bloc.dart';
import 'package:rapidlie/features/reels/data/models/reel_model.dart';

class ReelsScreen extends StatefulWidget {
  final String eventId;
  final bool canPost;
  const ReelsScreen({Key? key, required this.eventId, required this.canPost})
      : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final _picker = ImagePicker();
  String? _pendingCaption;

  @override
  void initState() {
    super.initState();
    context.read<ReelBloc>().add(FetchReels(widget.eventId));
  }

  Future<void> _pickAndUpload() async {
    final choice = await _showMediaTypeDialog();
    if (choice == null) return;

    final XFile? file = choice == 'photo'
        ? await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80)
        : await _picker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;

    final caption = await _showCaptionDialog();

    setState(() => _pendingCaption = caption);
    if (mounted) {
      context
          .read<FileUploadBloc>()
          .add(FileUploadEvent(file: File(file.path)));
    }
  }

  Future<String?> _showMediaTypeDialog() async {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Photo'),
              onTap: () => Navigator.pop(context, 'photo'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Video'),
              onTap: () => Navigator.pop(context, 'video'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showCaptionDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add a caption'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Optional caption...'),
          maxLines: 2,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Skip')),
          TextButton(
              onPressed: () =>
                  Navigator.pop(context, controller.text.trim()),
              child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileUploadBloc, FileUploadState>(
      listener: (context, uploadState) {
        if (uploadState is FileUploadSuccessState) {
          final mediaType = uploadState.fileName.contains('.mp4') ||
                  uploadState.fileName.contains('.mov')
              ? 'video'
              : 'photo';
          context.read<ReelBloc>().add(PostReel(
                eventId: widget.eventId,
                mediaUrl: uploadState.fileName,
                mediaType: mediaType,
                caption: _pendingCaption,
              ));
          setState(() => _pendingCaption = null);
        } else if (uploadState is FileUploadFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(uploadState.error)),
          );
        }
      },
      child: BlocConsumer<ReelBloc, ReelState>(
        listener: (context, state) {
          if (state is ReelUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reel posted!')),
            );
            context.read<ReelBloc>().add(FetchReels(widget.eventId));
          } else if (state is ReelDeleteSuccess) {
            context.read<ReelBloc>().add(FetchReels(widget.eventId));
          } else if (state is ReelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isUploading = context.watch<FileUploadBloc>().state
              is FileUploadingState ||
              state is ReelUploading;

          if (state is ReelLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final reels =
              state is ReelsLoaded ? state.reels : <ReelModel>[];

          return Scaffold(
            floatingActionButton: widget.canPost
                ? FloatingActionButton(
                    onPressed: isUploading ? null : _pickAndUpload,
                    child: isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.add_a_photo),
                  )
                : null,
            body: reels.isEmpty
                ? const Center(child: Text('No moments yet'))
                : GridView.builder(
                    padding: const EdgeInsets.all(4),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: reels.length,
                    itemBuilder: (_, i) => _ReelTile(
                      reel: reels[i],
                      onLikeTap: () =>
                          context.read<ReelBloc>().add(ToggleReelLike(
                                reelId: reels[i].id,
                                like: !reels[i].hasLiked,
                              )),
                      onDeleteTap: () =>
                          context.read<ReelBloc>().add(DeleteReel(reels[i].id)),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _ReelTile extends StatelessWidget {
  final ReelModel reel;
  final VoidCallback onLikeTap;
  final VoidCallback onDeleteTap;

  const _ReelTile({
    required this.reel,
    required this.onLikeTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showOptions(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          RenderImage(imageUrl: reel.mediaUrl),
          if (reel.isVideo)
            const Center(
              child: Icon(Icons.play_circle_fill,
                  color: Colors.white70, size: 30),
            ),
          Positioned(
            bottom: 4,
            left: 4,
            child: Row(
              children: [
                GestureDetector(
                  onTap: onLikeTap,
                  child: Icon(
                    reel.hasLiked ? Icons.favorite : Icons.favorite_border,
                    color: reel.hasLiked ? Colors.red : Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  '${reel.likes}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reel.caption != null && reel.caption!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(reel.caption!),
              ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onDeleteTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}
