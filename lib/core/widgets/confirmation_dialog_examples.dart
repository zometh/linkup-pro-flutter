/// Example usage of CustomConfirmationDialog
///
/// This file demonstrates various ways to use the CustomConfirmationDialog widget

import 'package:flutter/material.dart';
import 'package:linkup_pro/core/widgets/custom_confirmation_dialog.dart';

class ConfirmationDialogExamples {

  /// Example 1: Basic confirmation dialog
  static Future<void> showBasicExample(BuildContext context) async {
    final result = await CustomConfirmationDialog.show(
      context: context,
      title: 'Confirm Action',
      message: 'Are you sure you want to proceed with this action?',
      confirmText: 'Yes, Continue',
      cancelText: 'No, Cancel',
    );

    if (result == true) {
      // User confirmed the action
      debugPrint('User confirmed');
    } else {
      // User cancelled or dismissed the dialog
      debugPrint('User cancelled');
    }
  }

  /// Example 2: Delete confirmation (dangerous action)
  static Future<void> showDeleteExample(BuildContext context) async {
    final result = await CustomConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: 'Delete Item',
      message: 'Are you sure you want to delete this item? This action cannot be undone.',
      onConfirm: () {
        // This callback is called when user confirms
        debugPrint('Item deleted');
      },
      onCancel: () {
        // This callback is called when user cancels
        debugPrint('Delete cancelled');
      },
    );

    // You can also check the result
    if (result == true) {
      // Perform delete operation
    }
  }

  /// Example 3: Warning confirmation
  static Future<void> showWarningExample(BuildContext context) async {
    await CustomConfirmationDialog.showWarningConfirmation(
      context: context,
      title: 'Warning',
      message: 'This action may have unintended consequences. Do you want to continue?',
      confirmText: 'I Understand',
    );
  }

  /// Example 4: Success confirmation
  static Future<void> showSuccessExample(BuildContext context) async {
    await CustomConfirmationDialog.showSuccessConfirmation(
      context: context,
      title: 'Success',
      message: 'Your changes have been saved successfully!',
      confirmText: 'Great!',
      cancelText: 'View Details',
    );
  }

  /// Example 5: Info confirmation
  static Future<void> showInfoExample(BuildContext context) async {
    await CustomConfirmationDialog.showInfoConfirmation(
      context: context,
      title: 'Information',
      message: 'Please review the information before continuing.',
      confirmText: 'Got it',
    );
  }

  /// Example 6: Custom styled confirmation
  static Future<void> showCustomExample(BuildContext context) async {
    await CustomConfirmationDialog.show(
      context: context,
      title: 'Custom Dialog',
      message: 'This dialog has custom colors and icon.',
      icon: Icons.rocket_launch_rounded,
      iconColor: Colors.purple,
      confirmColor: Colors.purple,
      cancelColor: Colors.grey,
      confirmText: 'Launch',
      cancelText: 'Not Yet',
    );
  }

  /// Example 7: Logout confirmation
  static Future<bool> showLogoutConfirmation(BuildContext context) async {
    final result = await CustomConfirmationDialog.showWarningConfirmation(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout from your account?',
      confirmText: 'Logout',
      cancelText: 'Stay',
    );

    return result ?? false;
  }

  /// Example 8: Discard changes confirmation
  static Future<bool> showDiscardChangesConfirmation(BuildContext context) async {
    final result = await CustomConfirmationDialog.show(
      context: context,
      title: 'Discard Changes',
      message: 'You have unsaved changes. Are you sure you want to discard them?',
      icon: Icons.warning_rounded,
      iconColor: Colors.orange,
      confirmText: 'Discard',
      cancelText: 'Keep Editing',
      isDangerous: true,
    );

    return result ?? false;
  }

  /// Example 9: Delete account confirmation (very dangerous)
  static Future<bool> showDeleteAccountConfirmation(BuildContext context) async {
    final result = await CustomConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: 'Delete Account',
      message: 'This will permanently delete your account and all associated data. This action cannot be undone.',
      confirmText: 'Delete Forever',
      cancelText: 'Cancel',
    );

    return result ?? false;
  }

  /// Example 10: Share confirmation
  static Future<void> showShareConfirmation(BuildContext context) async {
    await CustomConfirmationDialog.show(
      context: context,
      title: 'Share Post',
      message: 'Do you want to share this post with your followers?',
      icon: Icons.share_rounded,
      iconColor: Colors.blue,
      confirmText: 'Share',
      cancelText: 'Cancel',
      onConfirm: () {
        debugPrint('Post shared');
      },
    );
  }
}

