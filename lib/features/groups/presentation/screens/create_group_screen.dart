import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/file_upload/bloc/file_upload_bloc.dart';
import 'package:rapidlie/features/groups/blocs/groups_bloc/groups_bloc.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _privacy = 'public';
  String? _uploadedImageUrl;
  bool _isUploading = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      context
          .read<FileUploadBloc>()
          .add(FileUploadEvent(file: File(picked.path)));
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group name is required')),
      );
      return;
    }
    final desc = _descController.text.trim();
    context.read<GroupsBloc>().add(CreateGroup(
          name: name,
          description: desc.isEmpty ? null : desc,
          image: _uploadedImageUrl,
          privacy: _privacy,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(pageTitle: 'Create Group', isSubPage: true),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<FileUploadBloc, FileUploadState>(
            listener: (context, state) {
              if (state is FileUploadingState) {
                setState(() => _isUploading = true);
              } else if (state is FileUploadSuccessState) {
                setState(() {
                  _isUploading = false;
                  _uploadedImageUrl = state.fileName;
                });
              } else if (state is FileUploadFailureState) {
                setState(() => _isUploading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
          BlocListener<GroupsBloc, GroupsState>(
            listener: (context, state) {
              if (state is GroupsLoading) {
                setState(() => _isSubmitting = true);
              } else if (state is GroupCreateSuccess) {
                setState(() => _isSubmitting = false);
                context.pop();
              } else if (state is GroupsError) {
                setState(() => _isSubmitting = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _isUploading ? null : _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        width: 2,
                      ),
                      image: _uploadedImageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(_uploadedImageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _isUploading
                        ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : _uploadedImageUrl == null
                            ? Icon(Icons.add_a_photo,
                                color:
                                    Theme.of(context).colorScheme.primary,
                                size: 32)
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Group Photo',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              const SizedBox(height: 24),
              TextFieldTemplate(
                hintText: 'Group name',
                controller: _nameController,
                obscureText: false,
                width: double.infinity,
                height: 50,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                enabled: true,
              ),
              const SizedBox(height: 16),
              TextFieldTemplate(
                hintText: 'Description (optional)',
                controller: _descController,
                obscureText: false,
                width: double.infinity,
                height: 100,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                enabled: true,
                numberOfLines: 4,
              ),
              const SizedBox(height: 20),
              const Text('Privacy',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _PrivacyChip(
                    label: 'Public',
                    icon: Icons.public,
                    selected: _privacy == 'public',
                    onTap: () => setState(() => _privacy = 'public'),
                  ),
                  const SizedBox(width: 12),
                  _PrivacyChip(
                    label: 'Private',
                    icon: Icons.lock_outline,
                    selected: _privacy == 'private',
                    onTap: () => setState(() => _privacy = 'private'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ButtonTemplate(
                buttonName: 'Create Group',
                buttonAction: _submit,
                loading: _isSubmitting || _isUploading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PrivacyChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          color:
              selected ? color.withValues(alpha: 0.08) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color: selected ? color : Colors.grey),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? color : Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}
