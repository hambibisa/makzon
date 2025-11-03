import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'add_client_screen.dart';
import 'client_model.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

    @override
      Widget build(BuildContext context) {
          return Scaffold(
                appBar: AppBar(title: const Text("العملاء")),
                      body: ValueListenableBuilder(
                              valueListenable: Hive.box<Client>('clients').listenable(),
                                      builder: (context, Box<Client> box, _) {
                                                final clients = box.values.toList().cast<Client>();
                                                          if (clients.isEmpty) {
                                                                      return const Center(
                                                                                    child: Text('لا يوجد عملاء بعد. اضغط "+" للإضافة.'),
                                                                                                );
                                                                                                          }
                                                                                                                    return ListView.builder(
                                                                                                                                padding: const EdgeInsets.all(8),
                                                                                                                                            itemCount: clients.length,
                                                                                                                                                        itemBuilder: (context, index) {
                                                                                                                                                                      final client = clients[index];
                                                                                                                                                                                    return Card(
                                                                                                                                                                                                    child: ListTile(
                                                                                                                                                                                                                      leading: const CircleAvatar(child: Icon(Icons.person)),
                                                                                                                                                                                                                                        title: Text(client.name),
                                                                                                                                                                                                                                                          subtitle: Text(client.phone ?? 'لا يوجد رقم هاتف'),
                                                                                                                                                                                                                                                                            trailing: Text('${client.totalDebt} ريال', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                                                                                                                                                                                                                                                            ),
                                                                                                                                                                                                                                                                                                          );
                                                                                                                                                                                                                                                                                                                      },
                                                                                                                                                                                                                                                                                                                                );
                                                                                                                                                                                                                                                                                                                                        },
                                                                                                                                                                                                                                                                                                                                              ),
                                                                                                                                                                                                                                                                                                                                                    floatingActionButton: FloatingActionButton(
                                                                                                                                                                                                                                                                                                                                                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddClientScreen())),
                                                                                                                                                                                                                                                                                                                                                                    child: const Icon(Icons.add),
                                                                                                                                                                                                                                                                                                                                                                          ),
                                                                                                                                                                                                                                                                                                                                                                              );
                                                                                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                                                                                