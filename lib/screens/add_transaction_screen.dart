import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../controllers/transaction_controller.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _type = 'Pengeluaran';
  String _category = 'Makan';
  
  final List<String> _categories = ['Makan', 'Transportasi', 'Hiburan', 'Gaji', 'Lainnya'];

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final tx = Transaction(
        title: _titleController.text,
        type: _type,
        category: _category,
        amount: double.parse(_amountController.text),
        date: DateTime.now(),
      );
      await TransactionController().addTransaction(tx);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi Berhasil Disimpan'))
        );
        _titleController.clear();
        _amountController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Ditambahkan agar tidak error overflow saat keyboard muncul
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Nama Transaksi', 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nominal (Rp)', 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nominal tidak boleh kosong';
                    if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Nominal tidak valid/negatif';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: _type,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  items: ['Pemasukan', 'Pengeluaran']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _type = val.toString()),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: _category,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  items: _categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _category = val.toString()),
                ),
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC3B1E1), // Pastel Purple
                    foregroundColor: Colors.blueGrey[900],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 55),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Simpan Transaksi', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}