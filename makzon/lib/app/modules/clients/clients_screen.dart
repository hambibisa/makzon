import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'client_model.dart';
import 'add_client_screen.dart'; // استيراد الشاشة الجديدة

class ClientsScreen extends StatelessWidget {
    const ClientsScreen({super.key});

      @override
        Widget build(BuildContext context) {
              return Scaffold(
                      appBar: AppBar(
                                title: const Text('العملاء'),
                      ),
                            body: ValueListenableBuilder(
                                      valueListenable: Hive.box<Client>('clients').listenable(),
                                              builder: (context, Box<Client> box, _) {
                                                          if (box.values.isEmpty) {
                                                                        return const Center(child: Text('لا يوجد عملاء.'));
                                                          }
                                                                    return ListView.builder(
                                                                                  itemCount: box.length,
                                                                                              itemBuilder: (context, index) {
                                                                                                              final client = box.getAt(index)!;
                                                                                                                            return ListTile(
                                                                                                                                              title: Text(client.name),
                                                                                                                                                              subtitle: Text(client.phone),
                                                                                                                                                                              trailing: Text(
                                                                                                                                                                                                  'الدين: ${client.debt.toStringAsFixed(2)}',
                                                                                                                                                                                                                    style: TextStyle(
                                                                                                                                                                                                                                            color: client.debt > 0 ? Colors.red : Colors.black),
                                                                                                                                                                              ),
                                                                                                                            );
                                                                                              },
                                                                    );
                                              },
                            ),
                                  floatingActionButton: FloatingActionButton(
                                            onPressed: () {
                                                        Navigator.of(context).push(
                                                                      MaterialPageRoute(builder: (context) => const AddClientScreen()),
                                                        );
                                            },
                                                    child: const Icon(Icons.add),
                                  ),
              );
        }
}

                                                    