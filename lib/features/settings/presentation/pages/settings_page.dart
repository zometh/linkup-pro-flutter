import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/providers/theme_provider.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _localDb = GetIt.I<LocalDBService>();
  bool _notificationsEnabled = true;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notificationsEnabled = await _localDb.getNotificationEnabled();
    final packageInfo = await PackageInfo.fromPlatform();

    if (mounted) {
      setState(() {
        _notificationsEnabled = notificationsEnabled;
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: CustomText(
          text: 'settings'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Section Apparence
          _buildSectionHeader(isDark, 'appearance'.tr()),
          _buildThemeSelector(isDark, themeMode),

          const SizedBox(height: 24),

          // Section Notifications
          _buildSectionHeader(isDark, 'notifications'.tr()),
          _buildSettingsTile(
            isDark: isDark,
            icon: Icons.notifications_outlined,
            title: 'push_notifications'.tr(),
            subtitle: 'receive_notifications'.tr(),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) async {
                setState(() => _notificationsEnabled = value);
                await _localDb.saveNotificationEnabled(value);
              },
              activeTrackColor: AppColors.primary,
            ),
          ),

          const SizedBox(height: 24),

          // Section Langue
          _buildSectionHeader(isDark, 'language'.tr()),
          _buildLanguageSelector(isDark),

          const SizedBox(height: 24),

          // Section Compte
          _buildSectionHeader(isDark, 'account'.tr()),
          _buildSettingsTile(
            isDark: isDark,
            icon: Icons.lock_outline,
            title: 'change_password'.tr(),
            onTap: () => _showChangePasswordDialog(),
          ),
          _buildSettingsTile(
            isDark: isDark,
            icon: Icons.privacy_tip_outlined,
            title: 'privacy'.tr(),
            onTap: () => _showPrivacySettings(),
          ),

          const SizedBox(height: 24),

          // Section À propos
          _buildSectionHeader(isDark, 'about'.tr()),
          _buildSettingsTile(
            isDark: isDark,
            icon: Icons.info_outline,
            title: 'app_version'.tr(),
            subtitle: _appVersion,
          ),
          _buildSettingsTile(
            isDark: isDark,
            icon: Icons.description_outlined,
            title: 'terms_of_service'.tr(),
            onTap: () => _openTermsOfService(),
          ),
          _buildSettingsTile(
            isDark: isDark,
            icon: Icons.security_outlined,
            title: 'privacy_policy'.tr(),
            onTap: () => _openPrivacyPolicy(),
          ),
          _buildSettingsTile(
            isDark: isDark,
            icon: Icons.help_outline,
            title: 'help_support'.tr(),
            onTap: () => _openHelpSupport(),
          ),

          const SizedBox(height: 24),

          // Bouton de déconnexion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutConfirmation(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: Text(
                'logout'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),



          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDark, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomText(
        text: title.toUpperCase(),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white38 : AppColors.textTertiary,

      ),
    );
  }

  Widget _buildThemeSelector(bool isDark, AppThemeMode currentMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildThemeOption(
            isDark: isDark,
            icon: Icons.light_mode_outlined,
            title: 'light_mode'.tr(),
            isSelected: currentMode == AppThemeMode.light,
            onTap: () => ref.read(themeProvider.notifier).setThemeMode(AppThemeMode.light),
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
          _buildThemeOption(
            isDark: isDark,
            icon: Icons.dark_mode_outlined,
            title: 'dark_mode'.tr(),
            isSelected: currentMode == AppThemeMode.dark,
            onTap: () => ref.read(themeProvider.notifier).setThemeMode(AppThemeMode.dark),
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
          _buildThemeOption(
            isDark: isDark,
            icon: Icons.brightness_auto_outlined,
            title: 'system_mode'.tr(),
            isSelected: currentMode == AppThemeMode.system,
            onTap: () => ref.read(themeProvider.notifier).setThemeMode(AppThemeMode.system),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required bool isDark,
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : (isDark ? Colors.white54 : AppColors.textSecondary),
      ),
      title: CustomText(
        text: title,
        fontSize: 15,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.primary)
          : null,
    );
  }

  Widget _buildLanguageSelector(bool isDark) {
    final currentLocale = context.locale;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildLanguageOption(
            isDark: isDark,
            flag: '🇫🇷',
            title: 'Français',
            isSelected: currentLocale.languageCode == 'fr',
            onTap: () {
              context.setLocale(const Locale('fr'));
              _localDb.saveLanguageCode('fr');
            },
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
          _buildLanguageOption(
            isDark: isDark,
            flag: '🇬🇧',
            title: 'English',
            isSelected: currentLocale.languageCode == 'en',
            onTap: () {
              context.setLocale(const Locale('en'));
              _localDb.saveLanguageCode('en');
            },
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
          _buildLanguageOption(
            isDark: isDark,
            flag: '🇸🇦',
            title: 'العربية',
            isSelected: currentLocale.languageCode == 'ar',
            onTap: () {
              context.setLocale(const Locale('ar'));
              _localDb.saveLanguageCode('ar');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required bool isDark,
    required String flag,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: CustomText(
        text: title,
        fontSize: 15,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.primary)
          : null,
    );
  }

  Widget _buildSettingsTile({
    required bool isDark,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isDark ? Colors.white54 : AppColors.textSecondary,
        ),
        title: CustomText(
          text: title,
          fontSize: 15,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        subtitle: subtitle != null
            ? CustomText(
                text: subtitle,
                fontSize: 13,
                color: isDark ? Colors.white38 : AppColors.textTertiary,
              )
            : null,
        trailing: trailing ??
            (onTap != null
                ? Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  )
                : null),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout'.tr()),
        content: Text('logout_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              GoRouter.of(context).pop();
              _logout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('logout'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    // Afficher un indicateur de chargement
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Déconnecter le WebSocket
      try {
        final socketService = GetIt.I<SocketService>();
        socketService.dispose();
      } catch (_) {}

      // Utiliser AuthProvider pour la déconnexion (met à jour l'état + supprime les données)
      await ref.read(authProvider).logout();

      // Fermer le dialog de chargement
      if (mounted) {
        GoRouter.of(context).pop();
      }

      // Naviguer vers la page de splash/login en nettoyant toute la pile
      if (mounted) {
        GoRouter.of(context).go('/splash');
      }
    } catch (e) {
      // Fermer le dialog en cas d'erreur
      if (mounted) {
        GoRouter.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la déconnexion: $e')),
        );
      }
    }
  }


  void _showChangePasswordDialog() {
    // TODO: Implémenter le changement de mot de passe
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('coming_soon'.tr())),
    );
  }

  void _showPrivacySettings() {
    // TODO: Implémenter les paramètres de confidentialité
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('coming_soon'.tr())),
    );
  }

  void _openTermsOfService() {
    // TODO: Ouvrir les conditions d'utilisation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('coming_soon'.tr())),
    );
  }

  void _openPrivacyPolicy() {
    // TODO: Ouvrir la politique de confidentialité
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('coming_soon'.tr())),
    );
  }

  void _openHelpSupport() {
    // TODO: Ouvrir l'aide et support
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('coming_soon'.tr())),
    );
  }
}

/// Page temporaire qui redirige vers le splash après la déconnexion
class _LogoutRedirectPage extends StatefulWidget {
  const _LogoutRedirectPage();

  @override
  State<_LogoutRedirectPage> createState() => _LogoutRedirectPageState();
}

class _LogoutRedirectPageState extends State<_LogoutRedirectPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        GoRouter.of(context).go('/splash');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
