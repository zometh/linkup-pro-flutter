import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

/// Exemple d'utilisation des TextStyles avec couleurs
class TextStylesExample extends StatelessWidget {
  const TextStylesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Styles de Texte',
          style: AppTextStylesThemed.getTitleLarge(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo avec couleur primaire
            Text(
              'LinkUp Pro',
              style: AppTextStyles.logo, // Couleur primaire intégrée
            ),
            const SizedBox(height: AppTheme.paddingL),

            // Exemples avec adaptation automatique au thème
            _buildSection(context, 'Titres principaux', [
              _buildTextDemo(
                context,
                'Display Large',
                AppTextStylesThemed.getDisplayLarge(context),
              ),
              _buildTextDemo(
                context,
                'Headline Large',
                AppTextStylesThemed.getHeadlineLarge(context),
              ),
              _buildTextDemo(
                context,
                'Headline Medium',
                AppTextStylesThemed.getHeadlineMedium(context),
              ),
            ]),

            _buildSection(context, 'Titres de section', [
              _buildTextDemo(
                context,
                'Title Large',
                AppTextStylesThemed.getTitleLarge(context),
              ),
              _buildTextDemo(
                context,
                'Title Medium',
                AppTextStylesThemed.getTitleMedium(context),
              ),
              _buildTextDemo(
                context,
                'Title Small',
                AppTextStylesThemed.getTitleSmall(context),
              ),
            ]),

            _buildSection(context, 'Corps de texte', [
              _buildTextDemo(
                context,
                'Body Large',
                AppTextStylesThemed.getBodyLarge(context),
              ),
              _buildTextDemo(
                context,
                'Body Medium',
                AppTextStylesThemed.getBodyMedium(context),
              ),
              _buildTextDemo(
                context,
                'Body Small',
                AppTextStylesThemed.getBodySmall(context),
              ),
            ]),

            _buildSection(context, 'Styles spéciaux', [
              _buildTextDemo(
                context,
                'Subtitle',
                AppTextStylesThemed.getSubtitle(context),
              ),
              _buildTextDemo(
                context,
                'Caption',
                AppTextStylesThemed.getCaption(context),
              ),
              _buildTextDemo(
                context,
                'Button Style',
                AppTextStyles.button,
              ), // Couleur fixe (blanc)
            ]),

            const SizedBox(height: AppTheme.paddingXL),

            // Exemple avec personnalisation
            Container(
              padding: const EdgeInsets.all(AppTheme.paddingM),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personnalisation avec extension',
                    style: AppTextStylesThemed.getTitleMedium(
                      context,
                    ).withColor(AppColors.primary),
                  ),
                  const SizedBox(height: AppTheme.paddingS),
                  Text(
                    'Vous pouvez facilement personnaliser les couleurs, tailles et poids.',
                    style: AppTextStylesThemed.getBodyMedium(
                      context,
                    ).withOpacity(0.8),
                  ),
                  const SizedBox(height: AppTheme.paddingS),
                  Text(
                    'Texte plus grand et gras',
                    style: AppTextStylesThemed.getBodyMedium(context)
                        .withSize(18)
                        .withWeight(FontWeight.w600)
                        .withColor(AppColors.primary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.paddingL),

            // Exemple avec couleurs d'état
            _buildStatusExamples(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          'Action',
          style: AppTextStyles.button, // Style button avec couleur blanche
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
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
            style: AppTextStylesThemed.getHeadlineSmall(
              context,
            ).withColor(AppColors.primary),
          ),
        ),
        ...children,
        const SizedBox(height: AppTheme.paddingM),
      ],
    );
  }

  Widget _buildTextDemo(BuildContext context, String label, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStylesThemed.getCaption(context)),
          const SizedBox(height: 2),
          Text('Exemple avec $label', style: style),
        ],
      ),
    );
  }

  Widget _buildStatusExamples(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Couleurs d\'état',
          style: AppTextStylesThemed.getHeadlineSmall(
            context,
          ).withColor(AppColors.primary),
        ),
        const SizedBox(height: AppTheme.paddingM),

        _buildStatusText('Succès', AppColors.success),
        _buildStatusText('Attention', AppColors.warning),
        _buildStatusText('Erreur', AppColors.error),
        _buildStatusText('Information', AppColors.info),
      ],
    );
  }

  Widget _buildStatusText(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingS),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppTheme.paddingS),
          Text(text, style: AppTextStyles.bodyMedium.withColor(color)),
        ],
      ),
    );
  }
}
