import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JobDetailPage extends StatelessWidget {
  final String jobId;
  const JobDetailPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'offre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Détails pour l\'offre: $jobId', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const Text('Page de détails simplifiée. Si vous souhaitez un écran complet, créez un JobDetailPage plus riche.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/offers'),
                child: const Text('Retour aux offres'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

