import 'package:flutter/material.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/main.dart';

class CustomPopscope extends StatelessWidget {
  final Widget widget;
  final Function()? executeOnPop;

  const CustomPopscope({super.key, required this.widget, this.executeOnPop});

  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _ExitConfirmationDialog(),
    );

    if (result == true && executeOnPop != null) {
      await executeOnPop!();
    }

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _showExitDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: widget,
    );
  }
}

class _ExitConfirmationDialog extends StatefulWidget {
  const _ExitConfirmationDialog();

  @override
  State<_ExitConfirmationDialog> createState() =>
      _ExitConfirmationDialogState();
}

class _ExitConfirmationDialogState extends State<_ExitConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleResponse(bool value) {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) => FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: constraints.maxWidth * 0.85,
              constraints: BoxConstraints(
                maxWidth: context.isMobile ? double.infinity : 400,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withValues(alpha: 0.95),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header avec icône
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.orange,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          text: 'Confirmer le retour',
                          fontWeight: FontWeight.bold,
                          fontSize: 22,

                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Contenu
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Êtes-vous sûr de vouloir revenir en arrière ?',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Les modifications non sauvegardées seront perdues',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Boutons d'action
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _AnimatedButton(
                            onPressed: () => _handleResponse(false),
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.grey.shade700,
                            icon: Icons.close_rounded,
                            label: 'Annuler',
                            delay: 100,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AnimatedButton(
                            onPressed: () => _handleResponse(true),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.check_rounded,
                            label: 'Confirmer',
                            delay: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String label;
  final int delay;

  const _AnimatedButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.label,
    this.delay = 0,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() => _isVisible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedSlide(
        offset: _isVisible ? Offset.zero : const Offset(0, 0.3),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: Row(
            spacing: context.screenWidth * 0.02,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon),

              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
