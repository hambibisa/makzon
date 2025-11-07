import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'client_model.dart';

class AddClientScreen extends StatefulWidget {
    const AddClientScreen({super.key});

      @override
        State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
    final _formKey = GlobalKey<FormState>();
      final _nameController = TextEditingController();
        final _phoneController = TextEditingController();

          void _saveClient() {
                if (_formKey.currentState!.validate()) {
                        final client = Client(
                                  name: _nameController.text,
                                          phone: _phoneController.text,
                        );
                              Hive.box<Client>('clients').add(client);
                                    Navigator.of(context).pop();
                }
          }

            @override
              Widget build(BuildContext context) {
                    return Scaffold(
                            appBar: AppBar(
                                      title: const Text('إضافة عميل جديد'),
                            ),
                                  body: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                                    child: Form(
                                                                key: _formKey,
                                                                          child: Column(
                                                                                        children: [
                                                                                                        TextFormField(
                                                                                                                          controller: _nameController,
                                                                                                                                          decoration: const InputDecoration(labelText: 'اسم العميل'),
                                                                                                                                                          validator: (value) =>
                                                                                                                                                                              value!.isEmpty ? 'الرجاء إدخال الاسم' : null,
                                                                                                        ),
                                                                                                                      const SizedBox(height: 16),
                                                                                                                                    TextFormField(
                                                                                                                                                      controller: _phoneController,
                                                                                                                                                                      decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                                                                                                                                                                                      keyboardType: TextInputType.phone,
                                                                                                                                                                                                      validator: (value) =>
                                                                                                                                                                                                                          value!.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
                                                                                                                                    ),
                                                                                                                                                  const SizedBox(height: 32),
                                                                                                                                                                ElevatedButton(
                                                                                                                                                                                  onPressed: _saveClient,
                                                                                                                                                                                                  child: const Text('حفظ العميل'),
                                                                                                                                                                ),
                                                                                        ],
                                                                          ),
                                                    ),
                                  ),
                    );
              }
}

                                                                  