import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../clients/client_model.dart';
import '../sales/sale_model.dart';

class ReportsScreen extends StatelessWidget {
    const ReportsScreen({super.key});

      @override
        Widget build(BuildContext context) {
              final salesBox = Hive.box<Sale>('sales');
                  final clientsBox = Hive.box<Client>('clients');

                      // حساب إجمالي المبيعات
                          final double totalSales = salesBox.values
                                  .fold(0.0, (sum, sale) => sum + sale.totalAmount);

                                      // حساب إجمالي الديون
                                          final double totalDebt = clientsBox.values
                                                  .fold(0.0, (sum, client) => sum + client.debt);

                                                      return Scaffold(
                                                              appBar: AppBar(
                                                                        title: const Text('التقارير'),
                                                              ),
                                                                    body: Padding(
                                                                              padding: const EdgeInsets.all(16.0),
                                                                                      child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                                          _buildReportCard('إجمالي المبيعات', '${totalSales.toStringAsFixed(2)} ريال', Colors.blue),
                                                                                                                                      const SizedBox(height: 16),
                                                                                                                                                  _buildReportCard('إجمالي الديون على العملاء', '${totalDebt.toStringAsFixed(2)} ريال', Colors.red),
                                                                                                            ],
                                                                                      ),
                                                                    ),
                                                      );
        }

          Widget _buildReportCard(String title, String value, Color color) {
                return Card(
                        elevation: 4,
                              child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                                child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                                                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                                                                      ],
                                                ),
                              ),
                );
          }
}

                                                                    