import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

/// Widget de démonstration pour montrer les différents styles de texte Manrope
class TypographyShowcase extends StatelessWidget {
  const TypographyShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manrope Typography', style: AppTextStyles.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo style
            Text(
              'LinkUp Pro',
              style: AppTextStyles.logo.withColor(AppColors.primary),
            ),
            const SizedBox(height: AppTheme.paddingL),

            // Display styles
            _buildSection('Display Styles', [
              _buildTextExample('Display Large', AppTextStyles.displayLarge),
              _buildTextExample('Display Medium', AppTextStyles.displayMedium),
              _buildTextExample('Display Small', AppTextStyles.displaySmall),
            ]),

            // Headline styles
            _buildSection('Headlines', [
              _buildTextExample('Headline Large', AppTextStyles.headlineLarge),
              _buildTextExample(
                'Headline Medium',
                AppTextStyles.headlineMedium,
              ),
              _buildTextExample('Headline Small', AppTextStyles.headlineSmall),
            ]),

            // Title styles
            _buildSection('Titles', [
              _buildTextExample('Title Large', AppTextStyles.titleLarge),
              _buildTextExample('Title Medium', AppTextStyles.titleMedium),
              _buildTextExample('Title Small', AppTextStyles.titleSmall),
            ]),

            // Body styles
            _buildSection('Body Text', [
              _buildTextExample('Body Large', AppTextStyles.bodyLarge),
              _buildTextExample('Body Medium', AppTextStyles.bodyMedium),
              _buildTextExample('Body Small', AppTextStyles.bodySmall),
            ]),

            // Label styles
            _buildSection('Labels', [
              _buildTextExample('Label Large', AppTextStyles.labelLarge),
              _buildTextExample('Label Medium', AppTextStyles.labelMedium),
              _buildTextExample('Label Small', AppTextStyles.labelSmall),
            ]),

            // Special styles
            _buildSection('Special Styles', [
              _buildTextExample('Button Text', AppTextStyles.button),
              _buildTextExample('Caption', AppTextStyles.caption),
              _buildTextExample('OVERLINE', AppTextStyles.overline),
              _buildTextExample('Subtitle', AppTextStyles.subtitle),
            ]),

            const SizedBox(height: AppTheme.paddingXL),

            // Exemple d'utilisation avec couleurs
            Container(
              padding: const EdgeInsets.all(AppTheme.paddingM),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exemple d\'utilisation',
                    style: AppTextStyles.titleMedium.withColor(
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingS),
                  Text(
                    'La police Manrope offre une excellente lisibilité et un style moderne pour votre application.',
                    style: AppTextStyles.bodyMedium.withColor(
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppTheme.paddingL,
            bottom: AppTheme.paddingM,
          ),
          child: Text(
            title,
            style: AppTextStyles.headlineSmall.withColor(AppColors.primary),
          ),
        ),
        ...children,
        const SizedBox(height: AppTheme.paddingM),
      ],
    );
  }

  Widget _buildTextExample(String label, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.withColor(AppColors.textTertiary),
          ),
          const SizedBox(height: 2),
          Text('Exemple de texte avec $label', style: style),
        ],
      ),
    );
  }
}
