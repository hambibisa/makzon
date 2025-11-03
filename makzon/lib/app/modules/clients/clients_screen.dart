import 'package:flutter/material.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

    @override
      Widget build(BuildContext context) {
          return Scaffold(
                appBar: AppBar(
                        title: const Text("العملاء"),
                              ),
                                    body: Center(
                                            child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                            Icon(Icons.people_outline, size: 60, color: Colors.grey.shade400),
                                                                                        const SizedBox(height: 16),
                                                                                                    const Text(
                                                                                                                  'لا يوجد عملاء بعد',
                                                                                                                                style: TextStyle(fontSize: 18, color: Colors.grey),
                                                                                                                                            ),
                                                                                                                                                      ],
                                                                                                                                                              ),
                                                                                                                                                                    ),
                                                                                                                                                                           floatingActionButton: FloatingActionButton(
                                                                                                                                                                                   onPressed: () {
                                                                                                                                                                                             // سيتم هنا فتح شاشة إضافة عميل جديد لاحقًا
                                                                                                                                                                                                     },
                                                                                                                                                                                                             backgroundColor: Colors.green,
                                                                                                                                                                                                                     child: const Icon(Icons.add, color: Colors.white),
                                                                                                                                                                                                                           ),
                                                                                                                                                                                                                               );
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                 }
                                                                                                                                                                                                                                 