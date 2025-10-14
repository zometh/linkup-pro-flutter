import 'package:flutter/material.dart';
import 'package:linkup_pro/features/register/data/entities/sector.dart';

class RegisterCompany extends StatelessWidget {
  final Sector sector;

  const RegisterCompany({super.key, required this.sector});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Column(
            children: [

              Text(
                'Company Page for sector: ${sector.name}',
                style: TextStyle(fontSize: constraints.maxWidth * 0.05),
              ),
            ],
          )
        );
      })),
    );
  }
}
