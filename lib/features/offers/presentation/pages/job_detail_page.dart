import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';

import '../providers/job_application_provider.dart';
import '../providers/job_offer_provider.dart';

class JobDetailPage extends ConsumerStatefulWidget {
  final String jobId;
  const JobDetailPage({super.key, required this.jobId});

  @override
  ConsumerState<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends ConsumerState<JobDetailPage> {
  bool _isSaved = false;
  bool _hasApplied = false;

  String _formatSalary(double? salary) {
    if (salary == null) return 'Non renseigné';
    final s = salary.toStringAsFixed(0);
    return '$s FCFA';
  }

  PlatformFile? _pickedFile;
  final TextEditingController _coverLetterController = TextEditingController();

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx'], withData: true);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  Future<void> _apply(String jobId) async {
    // Si un fichier est sélectionné, uploadez-le d'abord
    String? resumeUrl;
    if (_pickedFile != null) {
      final apiClient = ApiClient();
      // PlatformFile.bytes is available when withData: true in FilePicker
      final bytes = _pickedFile!.bytes!;
      final filename = _pickedFile!.name;
      final contentType = (_pickedFile!.extension ?? '').toLowerCase() == 'pdf'
          ? 'application/pdf'
          : (_pickedFile!.extension ?? '').toLowerCase() == 'docx'
              ? 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
              : (_pickedFile!.extension ?? '').toLowerCase() == 'doc'
                  ? 'application/msword'
                  : null;
      final res = await apiClient.uploadFile('/uploads', fileField: 'file', bytes: bytes, filename: filename, contentType: contentType);
      resumeUrl = res['url'] as String?;
    }

    final applyNotifier = ref.read(applyToJobProvider.notifier);
    final success = await applyNotifier.apply(jobOfferId: jobId, resumeUrl: resumeUrl, coverLetter: _coverLetterController.text.isEmpty ? null : _coverLetterController.text);
    if (success && mounted) {
      // mettre à jour les providers locaux
      ref.read(targetedJobOffersProvider.notifier).markAsApplied(jobId);
      setState(() => _hasApplied = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Candidature envoyée')));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Échec lors de la candidature')));
    }
  }

  void _toggleSave(String jobId) {
    // Mise à jour locale + provider ciblé si présent
    ref.read(targetedJobOffersProvider.notifier).toggleSaved(jobId);
    setState(() => _isSaved = !_isSaved);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isSaved ? 'Offre enregistrée' : 'Enregistrement supprimé')));
  }

  @override
  Widget build(BuildContext context) {
    final asyncOffer = ref.watch(jobOfferDetailProvider(widget.jobId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'offre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: asyncOffer.when(
        data: (offer) {
          if (offer == null) {
            return const Center(child: Text('Offre introuvable'));
          }

          // Initialiser l'état local si non défini
          if (!_isSaved) _isSaved = offer.isSaved;
          if (!_hasApplied) _hasApplied = offer.hasApplied;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(offer.company.name, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(width: 8),
                    Text('•', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 8),
                    Text(timeago.format(offer.creationDate), style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Text(_formatSalary(offer.salary), style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Description', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(offer.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                if (offer.requiredSkills.isNotEmpty) ...[
                  Text('Compétences requises', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: offer.requiredSkills.map((s) => Chip(label: Text(s.skillName))).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: _coverLetterController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Lettre de motivation (optionnel)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.attach_file),
                      label: Text(_pickedFile == null ? 'Joindre CV' : 'CV choisi'),
                    ),
                    const SizedBox(width: 12),
                    if (_pickedFile != null) Expanded(child: Text(_pickedFile!.name, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _hasApplied ? null : () async => await _apply(offer.id),
                        icon: const Icon(Icons.send),
                        label: Text(_hasApplied ? 'Déjà postulé' : 'Postuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => _toggleSave(offer.id),
                      child: Text(_isSaved ? 'Enregistré' : 'Enregistrer'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erreur de chargement')),
      ),
    );
  }
}
