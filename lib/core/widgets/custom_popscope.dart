import 'package:flutter/material.dart';

class CustomPopscope extends StatelessWidget {
  final Widget widget;
  final Function()? executeOnPop;

  const CustomPopscope(
      {super.key, required this.widget, this.executeOnPop});

  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 10),
            Text(
              'Confirmer le retour',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir revenir en arrière ?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close, color: Colors.red),
            label: const Text('Non'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              if (executeOnPop != null){
                await executeOnPop!();
              }

              Navigator.of(context).pop(true);
              //Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check, color: Colors.green),
            label: const Text('Oui'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        //WidgetsBinding.instance.addPostFrameCallback((_) async {
        final shouldPop = await _showExitDialog(context);
        if (shouldPop) {

            Navigator.pop(context);

        }
        //});
      },
      child: widget,
    );
  }
}
