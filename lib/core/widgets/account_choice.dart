import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/routes/app_routes.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/main.dart';

class AccountChoice extends StatefulWidget {
  const AccountChoice({super.key});

  @override
  State<AccountChoice> createState() => _AccountChoiceState();
}

class _AccountChoiceState extends State<AccountChoice>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.05,
                vertical: constraints.maxHeight * 0.03,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: "account_choice_title".tr(),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: constraints.maxWidth * 0.055,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.015),
                  CustomText(
                    text: "Choose the account type that suits you",
                    fontSize: constraints.maxWidth * 0.035,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    color: Colors.grey[600],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  AccountTypeTile(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    icon: Icons.person_outline_rounded,
                    title: "account_choice_individual_title".tr(),
                    description: "account_choice_individual_description".tr(),
                    onTap: () => _navigate(context),
                    delay: 200,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  AccountTypeTile(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    icon: Icons.business_center_outlined,
                    title: "account_choice_business_title".tr(),
                    description: "account_choice_business_description".tr(),
                    onTap: () => _navigate(context, isEntreprise: true),
                    delay: 400,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _navigate(BuildContext context, {bool isEntreprise = false}) {
    final query = isEntreprise ? '?isEntreprise=true' : '';
    MyNavigator(context).navigateTo('/register$query');
  }
}

class AccountTypeTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final double height;
  final double width;
  final VoidCallback onTap;
  final int delay;

  const AccountTypeTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.height,
    required this.width,
    this.delay = 0,
  });

  @override
  State<AccountTypeTile> createState() => _AccountTypeTileState();
}

class _AccountTypeTileState extends State<AccountTypeTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    // Animation d'entrée avec délai
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: AnimatedScale(
        scale: _isVisible ? 1.0 : 0.8,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        child: MouseRegion(
          onEnter: (_) {
            setState(() => _isHovered = true);
            _hoverController.forward();
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            _hoverController.reverse();
          },
          child: AnimatedBuilder(
            animation: _hoverController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Material(
                  elevation: _elevationAnimation.value,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.white.withValues(alpha: .3),
                    highlightColor: Colors.white.withValues(alpha: .1),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AppGradients.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: .3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.width * 0.05,
                          vertical: widget.height * 0.025,
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.all(
                                _isHovered
                                    ? widget.width * 0.035
                                    : widget.width * 0.03,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                widget.icon,
                                size: context.isMobile ? 28 : 40,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: widget.width * 0.04),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: widget.title,
                                    color: Colors.white,
                                    fontSize: widget.width * 0.042,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  SizedBox(height: widget.height * 0.008),
                                  CustomText(
                                    text: widget.description,
                                    fontSize: widget.width * 0.033,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w400,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            AnimatedRotation(
                              turns: _isHovered ? 0.125 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: context.isMobile ? 20 : 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                  );
            },
          ),
        ),
      ),
    );
  }
}
