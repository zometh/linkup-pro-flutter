import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/offers/presentation/providers/job_offer_provider.dart';

/// Bottom sheet for creating a new job offer
class CreateOfferSheet extends ConsumerStatefulWidget {
  final VoidCallback onCreated;

  const CreateOfferSheet({super.key, required this.onCreated});

  @override
  ConsumerState<CreateOfferSheet> createState() => _CreateOfferSheetState();
}

class _CreateOfferSheetState extends ConsumerState<CreateOfferSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();

  String? _selectedEmploymentType;
  bool _isLoading = false;

  // Mock employment types - should come from API
  final List<Map<String, String>> _employmentTypes = [
    {'id': 'CDI', 'name': 'CDI'},
    {'id': 'CDD', 'name': 'CDD'},
    {'id': 'ALTERNATION', 'name': 'Alternance'},
    {'id': 'INTERNSHIP', 'name': 'Stage'},
    {'id': 'FULL_TIME', 'name': 'Temps plein'},
    {'id': 'PARTIAL_TIME', 'name': 'Temps partiel'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEmploymentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un type de contrat'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await ref
        .read(companyJobOffersProvider.notifier)
        .createOffer(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          salary: _salaryController.text.isNotEmpty
              ? double.tryParse(_salaryController.text)
              : null,
          employmentTypeId: _selectedEmploymentType!,
        );

    setState(() => _isLoading = false);

    if (success) {
      widget.onCreated();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHandle(isDark),
          _buildTitle(isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: 'Titre du poste',
                      hint: 'Ex: Développeur Flutter Senior',
                      isDark: isDark,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Titre requis' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(isDark),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _salaryController,
                      label: 'Salaire annuel (FCFA)',
                      hint: 'Ex: 30 000 000',
                      isDark: isDark,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Décrivez le poste, les missions...',
                      isDark: isDark,
                      maxLines: 6,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Description requise' : null,
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: .infinity, child: _buildBottomBar(isDark)),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? Colors.white24 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: isDark ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          CustomText(
            text: 'Nouvelle offre',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : AppColors.textPrimary,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : AppColors.textTertiary,
            ),
            filled: true,
            fillColor: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Type de contrat',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : AppColors.textPrimary,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkInput : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedEmploymentType,
              isExpanded: true,
              hint: Text(
                'Sélectionner',
                style: TextStyle(
                  color: isDark ? Colors.white38 : AppColors.textTertiary,
                ),
              ),
              dropdownColor: isDark ? AppColors.darkCard : Colors.white,
              items: _employmentTypes.map((type) {
                return DropdownMenuItem(
                  value: type['id'],
                  child: Text(
                    type['name']!,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedEmploymentType = value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleCreate,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Text(
                'Créer l\'offre',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
