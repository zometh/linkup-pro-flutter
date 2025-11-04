import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  // ...existing code...
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _controller = TextEditingController();
  final int _maxChars = 280;
  File? _imageFile;
  bool _isPosting = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  Future<void> _post() async {
    final String content = _controller.text.trim();
    if (content.isEmpty && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le post est vide. Ajoutez du texte ou une image.')),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      // Simuler envoi (remplacez par appel à votre repository)
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post publié')),
      );
      Navigator.of(context).pop(true); // renvoyer succès
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la publication: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildImagePreview() {
    if (_imageFile == null) return const SizedBox.shrink();
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(_imageFile!, width: double.infinity, fit: BoxFit.cover),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: _removeImage,
            child: Container(
              decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int remaining = _maxChars - _controller.text.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau post'),
        actions: [
          TextButton(
            onPressed: _isPosting ? null : _post,
            child: _isPosting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Publier', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar utilisateur (placeholder)
                  const CircleAvatar(radius: 22, child: Icon(Icons.person)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: 6,
                      maxLength: _maxChars,
                      decoration: const InputDecoration(
                        hintText: "Quoi de neuf ?",
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              if (_imageFile != null) ...[
                const SizedBox(height: 8),
                _buildImagePreview(),
              ],
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    tooltip: 'Ajouter une image',
                  ),
                  IconButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    tooltip: 'Prendre une photo',
                  ),
                  // ... ajouter d'autres actions si besoin ...
                  const Spacer(),
                  Text(
                    '$remaining',
                    style: TextStyle(color: remaining < 0 ? Colors.red : Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

