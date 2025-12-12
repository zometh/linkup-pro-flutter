import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/features/messages/domain/entity/send_message_entity.dart';
import 'package:linkup_pro/features/messages/domain/repos_implementation/message_repository_implement.dart';
import 'package:linkup_pro/features/messages/presentation/providers/messages.dart';

class ConversationBottomBar extends ConsumerStatefulWidget {
  final String conversationId;
  const ConversationBottomBar({super.key, required this.conversationId});

  @override
  ConsumerState<ConversationBottomBar> createState() =>
      _ConversationBottomBarState();
}

class _ConversationBottomBarState extends ConsumerState<ConversationBottomBar> {
  late TextEditingController _textCtrl;
  String? _selectedImagePath;
  Map<String, dynamic>? _uploadedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSending = ref.watch(messagesProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasContent =
        _textCtrl.text.trim().isNotEmpty || _uploadedImage != null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withAlpha(20)
                : Colors.black.withAlpha(20),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(100)
                : Colors.grey.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedImagePath != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey[850]!.withAlpha(180)
                        : AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withAlpha(15)
                          : AppColors.primary.withAlpha(50),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_selectedImagePath!),
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (_isUploading)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(150),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Image sélectionnée',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isUploading
                                  ? 'Upload en cours...'
                                  : 'Prêt à envoyer',
                              style: TextStyle(
                                fontSize: 11,
                                color: _isUploading
                                    ? AppColors.primary
                                    : Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _isUploading
                            ? null
                            : () {
                                setState(() {
                                  _selectedImagePath = null;
                                  _uploadedImage = null;
                                });
                              },
                        icon: Icon(
                          Icons.close_rounded,
                          color: _isUploading ? Colors.grey : Colors.red,
                          size: 20,
                        ),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: _isUploading
                          ? (isDark ? Colors.grey[800] : Colors.grey[300])
                          : (isDark
                                ? AppColors.primary.withAlpha(40)
                                : AppColors.primary.withAlpha(30)),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withAlpha(15)
                            : Colors.grey.withAlpha(50),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isUploading
                            ? null
                            : () async => await _pickImage(),
                        borderRadius: BorderRadius.circular(22),
                        child: Center(
                          child: Icon(
                            Icons.image_rounded,
                            color: _isUploading
                                ? Colors.grey
                                : AppColors.primary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: /*Container(
                      constraints: const BoxConstraints(minHeight: 44),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2A2A2A)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withAlpha(25)
                              : Colors.grey.withAlpha(50),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: */ TextField(
                      controller: _textCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 5,
                      minLines: 1,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Écrire un message...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                          fontSize: 15,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _send(),
                    ),
                    //  ),
                  ),
                  const SizedBox(width: 8),
                  // Bouton envoyer
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      gradient: (isSending || _isUploading)
                          ? null
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: hasContent
                                  ? [
                                      AppColors.primary,
                                      AppColors.primary.withAlpha(200),
                                    ]
                                  : [Colors.grey[400]!, Colors.grey[500]!],
                            ),
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: hasContent && !isSending && !_isUploading
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(100),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (isSending || _isUploading || !hasContent)
                            ? null
                            : _send,
                        borderRadius: BorderRadius.circular(22),
                        child: Center(
                          child: (isSending || _isUploading)
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isDark ? Colors.white : AppColors.primary,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 80,
      );
      if (picked == null) return;

      setState(() {
        _selectedImagePath = picked.path;
        _isUploading = true;
      });

      // Upload l'image
      final messageRepo = GetIt.I<MessageRepositoryImplement>();
      final result = await messageRepo.uploadMessageImage(picked.path);

      result.fold(
        (error) {
          MyLogger().log('Erreur upload: $error', type: LogType.error);
          setState(() {
            _selectedImagePath = null;
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'upload de l\'image')),
          );
        },
        (uploadedData) {
          setState(() {
            _uploadedImage = uploadedData;
            _isUploading = false;
          });
        },
      );
    } catch (e) {
      MyLogger().log('Erreur picker: $e', type: LogType.error);
      setState(() {
        _selectedImagePath = null;
        _isUploading = false;
      });
    }
  }

  void _send() async {
    final text = _textCtrl.text.trim();

    // Vérifier qu'il y a au moins du texte ou une image
    if (text.isEmpty && _uploadedImage == null) return;

    final List<Map<String, dynamic>>? attachments = _uploadedImage != null
        ? [
            {
              'fileName': _uploadedImage!['fileName'],
              'fileUrl': _uploadedImage!['url'],
              'fileType': _uploadedImage!['fileType'] ?? 'image',
              'fileSize': _uploadedImage!['fileSize'],
            },
          ]
        : null;

    final message = SendMessageEntity(
      conversationId: widget.conversationId,
      content: text.isNotEmpty ? text : null,
      attachments: attachments,
    );

    try {
      await ref.read(messagesProvider.notifier).sendMessage(message);
      _textCtrl.clear();
      setState(() {
        _selectedImagePath = null;
        _uploadedImage = null;
      });
    } catch (e) {
      MyLogger().log('Erreur envoi: $e', type: LogType.error);
      //ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi du message')),
      );
    }
  }
}
