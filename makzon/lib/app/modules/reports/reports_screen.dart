import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

    @override
      Widget build(BuildContext context) {
          return Scaffold(
                appBar: AppBar(
                        title: const Text("التقارير"),
                              ),
                                    body: Center(
                                            child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                            Icon(Icons.bar_chart_outlined, size: 60, color: Colors.grey.shade400),
                                                                                        const SizedBox(height: 16),
                                                                                                    const Text(
                                                                                                                  'التقارير والتحليلات',
                                                                                                                                style: TextStyle(fontSize: 18, color: Colors.grey),
                                                                                                                                            ),
                                                                                                                                                         const SizedBox(height: 8),
                                                                                                                                                                     const Text(
                                                                                                                                                                                   'سيتم تصميمها قريبًا',
                                                                                                                                                                                                 style: TextStyle(color: Colors.grey),
                                                                                                                                                                                                             ),
                                                                                                                                                                                                                       ],
                                                                                                                                                                                                                               ),
                                                                                                                                                                                                                                     ),
                                                                                                                                                                                                                                         );
                                                                                                                                                                                                                                           }
                                                                                                                                                                                                                                           }
                                                                                                                                                                                                                                           