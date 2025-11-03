import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

    @override
      Widget build(BuildContext context) {
          return Scaffold(
                appBar: AppBar(
                        title: const Text("الرئيسية"),
                              ),
                                    body: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                  children: [
                                                                                              const Spacer(),
                                                                                                          const Icon(Icons.storefront, size: 80, color: Colors.green),
                                                                                                                      const SizedBox(height: 20),
                                                                                                                                  const Text(
                                                                                                                                                "مرحبًا بك في Makzon",
                                                                                                                                                              textAlign: TextAlign.center,
                                                                                                                                                                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                                                                                                                                                                        ),
                                                                                                                                                                                                    const SizedBox(height: 8),
                                                                                                                                                                                                                Text(
                                                                                                                                                                                                                              "مخزونك وراحة بالك في جيبك",
                                                                                                                                                                                                                                            textAlign: TextAlign.center,
                                                                                                                                                                                                                                                          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                                                                                                                                                                                                                                                                      ),
                                                                                                                                                                                                                                                                                  const Spacer(),
                                                                                                                                                                                                                                                                                              const Text(
                                                                                                                                                                                                                                                                                                            "✨ برمجة وتطوير: النبراس البعداني",
                                                                                                                                                                                                                                                                                                                          textAlign: TextAlign.center,
                                                                                                                                                                                                                                                                                                                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                                                                                                                                                                                                                                                                                                                                    ),
                                                                                                                                                                                                                                                                                                                                                                const SizedBox(height: 16),
                                                                                                                                                                                                                                                                                                                                                                          ],
                                                                                                                                                                                                                                                                                                                                                                                  ),
                                                                                                                                                                                                                                                                                                                                                                                        ),
                                                                                                                                                                                                                                                                                                                                                                                            );
                                                                                                                                                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                                                                                                                                                                                                              