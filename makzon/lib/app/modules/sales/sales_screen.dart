import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
// تأكد من أن هذه المسارات صحيحة لمشروعك
import '../models/product_model.dart';
import '../models/client_model.dart';
import '../models/sale_model.dart';

// لقد قمت بتعريف SaleItem هنا لأنه لم يكن موجودًا في الكود الذي أرسلته
// إذا كان موجودًا في ملف آخر، يمكنك حذف هذا الجزء واستيراد الملف الصحيح
class SaleItem {
  final Product product;
  int quantity;

  SaleItem({required this.product, this.quantity = 1});

  // لقد غيرت اسم السعر هنا ليتوافق مع نموذج المنتج الخاص بك
  double get totalPrice => product.salePrice * quantity;
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
  Client? _selectedClient; // تم تغيير هذا ليكون متغيرًا عامًا لتسهيل الوصول إليه

  // --- دالة البيع الموحدة والمحسنة ---
  void _processSale({required bool isCreditSale}) async {
    if (_saleItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن إتمام عملية البيع، الفاتورة فارغة!')),
      );
      return;
    }

    // الخطوة 1: التعامل مع البيع الآجل واختيار العميل
    if (isCreditSale) {
      // استخدام مربع حوار لاختيار العميل
      final Client? client = await _showClientSelectionDialog();
      if (client == null) {
        // إذا لم يختر المستخدم عميلاً، نوقف العملية
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إلغاء البيع الآجل لعدم اختيار عميل.')),
        );
        return;
      }
      _selectedClient = client;
    }

    // إذا استمرت العملية، نتأكد أن الواجهة لا تزال موجودة
    if (!mounted) return;

    // الخطوة 2: حساب إجمالي الفاتورة
    final double totalAmount = _totalBill;

    // الخطوة 3: فتح صناديق قاعدة البيانات
    final salesBox = Hive.box<Sale>('sales');
    final productsBox = Hive.box<Product>('products');

    // الخطوة 4: إنشاء سجل بيع جديد
    final newSale = Sale(
      id: _uuid.v4(),
      // استخدام saleItems لإنشاء القوائم المطلوبة في نموذج Sale
      items: _saleItems.map((item) => SaleItemDb(productId: item.product.id, quantity: item.quantity, price: item.product.salePrice)).toList(),
      totalAmount: totalAmount,
      paymentType: isCreditSale ? PaymentType.credit : PaymentType.cash,
      date: DateTime.now(),
      clientId: _selectedClient?.id, // حفظ هوية العميل فقط في البيع الآجل
    );
    await salesBox.add(newSale);

    // الخطوة 5: تحديث كميات المنتجات في المخزون
    for (var item in _saleItems) {
      // البحث عن المنتج باستخدام مفتاحه لضمان التحديث الصحيح
      final product = productsBox.get(item.product.key);
      if (product != null) {
        product.quantity -= item.quantity;
        await product.save();
      }
    }

    // الخطوة 6: تحديث دين العميل (الإصلاح الرئيسي هنا)
    if (isCreditSale && _selectedClient != null) {
      _selectedClient!.debt += totalAmount;
      await _selectedClient!.save();
    }

    // الخطوة 7: إظهار رسالة نجاح ومسح الواجهة
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت عملية البيع بنجاح!')),
    );

    setState(() {
      _saleItems.clear(); // مسح سلة المشتريات
      _selectedClient = null; // إعادة تعيين العميل المختار
      _typeAheadController.clear(); // مسح حقل البحث
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
      // التحقق إذا كان المنتج موجودًا بالفعل في السلة
      for (var item in _saleItems) {
        if (item.product.id == product.id) {
          // التحقق من الكمية المتاحة في المخزون
          if (item.quantity < product.quantity) {
            item.quantity++;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('الكمية المطلوبة غير متوفرة في المخزون')));
          }
          _typeAheadController.clear();
          return; // الخروج من الدالة بعد زيادة الكمية
        }
      }

      // إذا لم يكن المنتج في السلة، قم بإضافته
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
                  autofocus: false,
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
                  subtitle: Text(
                      'السعر: ${suggestion.salePrice} ريال | الكمية: ${suggestion.quantity}'),
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
                            subtitle: Text('السعر: ${item.product.salePrice} ريال'),
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
