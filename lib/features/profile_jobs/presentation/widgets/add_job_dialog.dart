import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/profile_jobs/data/entity/job_entity.dart';
import 'package:linkup_pro/features/profile_jobs/data/models/job_model.dart';
import 'package:linkup_pro/features/profile_jobs/presentation/providers/profile_jobs_provider.dart';

class AddJobDialog extends ConsumerStatefulWidget {
  const AddJobDialog({super.key});

  @override
  ConsumerState<AddJobDialog> createState() => _AddJobDialogState();
}

class _AddJobDialogState extends ConsumerState<AddJobDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _companySearchController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrent = false;
  CompanyInfo? _selectedCompany;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _companySearchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _onCompanySearchChanged(String query) {
    if (query.trim().isEmpty) {
      ref.read(profileJobsProvider.notifier).clearCompanySearch();
      return;
    }
    ref.read(profileJobsProvider.notifier).searchCompanies(query);
  }

  void _selectCompany(CompanyInfo company) {
    setState(() {
      _selectedCompany = company;
      _companySearchController.text = company.name;
    });
    ref.read(profileJobsProvider.notifier).clearCompanySearch();
  }

  void _clearCompanySelection() {
    setState(() {
      _selectedCompany = null;
      _companySearchController.clear();
    });
    ref.read(profileJobsProvider.notifier).clearCompanySearch();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une date de début'),
        ),
      );
      return;
    }

    if (!_isCurrent && _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez sélectionner une date de fin ou cocher "Poste actuel"',
          ),
        ),
      );
      return;
    }

    if (_selectedCompany == null &&
        _companySearchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir le nom de l\'entreprise'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final jobEntity = JobEntity(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      startDate: _startDate!,
      endDate: _isCurrent ? null : _endDate,
      isCurrent: _isCurrent,
      companyId: _selectedCompany?.id,
      temporaryCompanyName: _selectedCompany == null
          ? _companySearchController.text.trim()
          : null,
    );

    final success = await ref
        .read(profileJobsProvider.notifier)
        .addJob(jobEntity);

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expérience ajoutée avec succès')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'ajout')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final jobsState = ref.watch(profileJobsProvider);

    return Dialog(
      backgroundColor: isDarkMode ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Ajouter une expérience',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title field
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Titre du poste *',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.work_outline,
                      color: isDarkMode ? Colors.white70 : AppColors.primary,
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? AppColors.darkInput
                        : AppColors.lightBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le titre est requis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Company search field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _companySearchController,
                      onChanged: _onCompanySearchChanged,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Entreprise *',
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        hintText: 'Rechercher ou saisir le nom',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white38 : Colors.black38,
                        ),
                        prefixIcon: Icon(
                          Icons.business,
                          color: isDarkMode
                              ? Colors.white70
                              : AppColors.primary,
                        ),
                        suffixIcon:
                            _selectedCompany != null ||
                                _companySearchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: _clearCompanySelection,
                              )
                            : null,
                        filled: true,
                        fillColor: isDarkMode
                            ? AppColors.darkInput
                            : AppColors.lightBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (jobsState.searchedCompanies.isNotEmpty &&
                        _selectedCompany == null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: jobsState.searchedCompanies.length,
                          itemBuilder: (context, index) {
                            final company = jobsState.searchedCompanies[index];
                            return ListTile(
                              leading: company.logo != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        company.logo!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) {
                                          return Icon(
                                            Icons.business,
                                            color: AppColors.primary,
                                          );
                                        },
                                      ),
                                    )
                                  : Icon(
                                      Icons.business,
                                      color: AppColors.primary,
                                    ),
                              title: Text(
                                company.name,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () => _selectCompany(company),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description field
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: isDarkMode
                        ? AppColors.darkInput
                        : AppColors.lightBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Start date
                InkWell(
                  onTap: () => _selectDate(context, true),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkInput
                          : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: isDarkMode
                              ? Colors.white70
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomText(
                            text: _startDate == null
                                ? 'Date de début *'
                                : 'Début: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                            color: _startDate == null
                                ? (isDarkMode ? Colors.white54 : Colors.black54)
                                : (isDarkMode ? Colors.white : Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Current job checkbox
                CheckboxListTile(
                  value: _isCurrent,
                  onChanged: (value) {
                    setState(() {
                      _isCurrent = value ?? false;
                      if (_isCurrent) {
                        _endDate = null;
                      }
                    });
                  },
                  title: CustomText(
                    text: 'Je travaille actuellement dans cette entreprise',
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                // End date
                if (!_isCurrent) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, false),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkInput
                            : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: isDarkMode
                                ? Colors.white70
                                : AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomText(
                              text: _endDate == null
                                  ? 'Date de fin *'
                                  : 'Fin: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                              color: _endDate == null
                                  ? (isDarkMode
                                        ? Colors.white54
                                        : Colors.black54)
                                  : (isDarkMode
                                        ? Colors.white
                                        : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Ajouter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
