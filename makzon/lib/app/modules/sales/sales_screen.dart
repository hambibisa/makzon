import 'package:flutter/material.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

    @override
      Widget build(BuildContext context) {
          return Scaffold(
                appBar: AppBar(
                        title: const Text("نقطة البيع"),
                              ),
                                    body: Center(
                                            child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                            Icon(Icons.point_of_sale_outlined, size: 60, color: Colors.grey.shade400),
                                                                                        const SizedBox(height: 16),
                                                                                                    const Text(
                                                                                                                  'شاشة نقطة البيع (POS)',
                                                                                                                                style: TextStyle(fontSize: 18, color: Colors.grey),
                                                                                                                                            ),
                                                                                                                                                         const SizedBox(height: 8),
                                                                                                                                                                     const Text(
                                                                                                                                                                                   'سيتم تصميمها في المرحلة القادمة',
                                                                                                                                                                                                 style: TextStyle(color: Colors.grey),
                                                                                                                                                                                                             ),
                                                                                                                                                                                                                       ],
                                                                                                                                                                                                                               ),
                                                                                                                                                                                                                                     ),
                                                                                                                                                                                                                                         );
                                                                                                                                                                                                                                           }
                                                                                                                                                                                                                                           }
                                                                                                                                                                                                                                           