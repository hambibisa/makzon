import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../products/product_model.dart';
import '../clients/client_model.dart';
import 'sale_model.dart';

class SaleItem {
  final Product product;
  int quantity;
  SaleItem({required this.product, this.quantity = 1});
  // تم التصحيح هنا لاستخدام 'price'
  double get totalPrice => product.price * quantity;
}

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});
  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final List<SaleItem> _saleItems = [];
  final TextEditingController _typeAheadController = TextEditingController();
  final Uuid _uuid = Uuid();
  Client? _selectedClient;

  // --- الدالة المُصححة بالكامل ---
  void _processSale({required bool isCreditSale}) async {
    if (_saleItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن إتمام عملية البيع، الفاتورة فارغة!')),
      );
      return;
    }

    if (isCreditSale) {
      final Client? client = await _showClientSelectionDialog();
      if (client == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إلغاء البيع الآجل لعدم اختيار عميل.')),
        );
        return;
      }
      _selectedClient = client;
    }

    if (!mounted) return;

    final double totalAmount = _totalBill;
    final salesBox = Hive.box<Sale>('sales');
    final productsBox = Hive.box<Product>('products');

    final newSale = Sale()
      ..id = _uuid.v4()
      ..productIds = _saleItems.map((item) => item.product.id).toList()
      ..quantities = _saleItems.map((item) => item.quantity).toList()
      ..prices = _saleItems.map((item) => item.product.price).toList() // تصحيح
      ..totalAmount = totalAmount
      ..saleDate = DateTime.now()
      ..isCredit = isCreditSale
      ..clientId = _selectedClient?.id;

    await salesBox.add(newSale);

    for (var item in _saleItems) {
      final product = productsBox.get(item.product.key);
      if (product != null) {
        product.quantity -= item.quantity;
        await product.save();
      }
    }

    if (isCreditSale && _selectedClient != null) {
      _selectedClient!.debt += totalAmount; // تصحيح
      await _selectedClient!.save();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت عملية البيع بنجاح!')),
    );

    setState(() {
      _saleItems.clear();
      _selectedClient = null;
      _typeAheadController.clear();
    });
  }

  Future<Client?> _showClientSelectionDialog() async {
    final clientsBox = Hive.box<Client>('clients');
    return await showDialog<Client>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('اختر العميل للبيع الآجل'),
          content: SizedBox(
            width: double.maxFinite,
            child: clientsBox.isEmpty
                ? const Center(child: Text('لا يوجد عملاء مضافون.'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: clientsBox.length,
                    itemBuilder: (context, index) {
                      final client = clientsBox.getAt(index) as Client;
                      return ListTile(
                        title: Text(client.name),
                        subtitle: Text('الدين الحالي: ${client.debt.toStringAsFixed(2)} ريال'),
                        onTap: () => Navigator.of(context).pop(client),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  void _addProductToSale(Product product) {
    setState(() {
      for (var item in _saleItems) {
        if (item.product.id == product.id) {
          if (item.quantity < product.quantity) {
            item.quantity++;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('الكمية المطلوبة غير متوفرة في المخزون')));
          }
          _typeAheadController.clear();
          return;
        }
      }
      if (product.quantity > 0) {
        _saleItems.add(SaleItem(product: product));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('هذا المنتج نفد من المخزون')));
      }
      _typeAheadController.clear();
    });
  }

  double get _totalBill {
    return _saleItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("نقطة البيع"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => setState(() => _saleItems.clear()),
            tooltip: 'فاتورة جديدة',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadField<Product>(
              controller: _typeAheadController,
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) return [];
                final box = Hive.box<Product>('products');
                return box.values
                    .where((product) => product.name
                        .toLowerCase()
                        .contains(pattern.toLowerCase()))
                    .toList();
              },
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'ابحث بالباركود أو اسم المنتج',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                );
              },
              itemBuilder: (context, Product suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                  // تم التصحيح هنا
                  subtitle: Text(
                      'السعر: ${suggestion.price} ريال | الكمية: ${suggestion.quantity}'),
                );
              },
              onSelected: (Product suggestion) {
                _addProductToSale(suggestion);
              },
              emptyBuilder: (context) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('لم يتم العثور على المنتج',
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _saleItems.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Text('لم يتم إضافة منتجات إلى الفاتورة بعد')))
                  : ListView.builder(
                      itemCount: _saleItems.length,
                      itemBuilder: (context, index) {
                        final item = _saleItems[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(item.product.name),
                            // تم التصحيح هنا
                            subtitle: Text('السعر: ${item.product.price} ريال'),
                            leading: IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () =>
                                    setState(() => _saleItems.removeAt(index))),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () => setState(() {
                                          if (item.quantity > 1) item.quantity--;
                                        }),
                                    icon: const Icon(Icons.remove)),
                                Text(item.quantity.toString(),
                                    style: const TextStyle(fontSize: 16)),
                                IconButton(
                                    onPressed: () => setState(() {
                                          if (item.quantity < item.product.quantity) {
                                            item.quantity++;
                                          }
                                        }),
                                    icon: const Icon(Icons.add)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الإجمالي:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('${_totalBill.toStringAsFixed(2)} ريال',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => _processSale(isCreditSale: false),
                        child: const Text('دفع نقدي'))),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => _processSale(isCreditSale: true),
                        child: const Text('دفع آجل'))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
