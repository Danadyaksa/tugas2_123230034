import 'package:flutter/material.dart';
import '../controllers/transaction_controller.dart';
import '../services/currency_service.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _service = CurrencyService();
  String _selectedCurrency = 'USD';
  double _conversionResult = 0.0;
  bool _isLoading = false;

  void _convert() async {
    setState(() => _isLoading = true);
    try {
      final double rate = await _service.getConversionRate(_selectedCurrency);
      final double totalPengeluaran = TransactionController().getTotalPengeluaran();
      setState(() {
        _conversionResult = totalPengeluaran * rate;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalPengeluaran = TransactionController().getTotalPengeluaran();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Mata Uang')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8)),
              child: Text('Total Pengeluaran: Rp $totalPengeluaran', style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: _selectedCurrency,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ['USD', 'EUR', 'JPY'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedCurrency = val.toString()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _convert,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(double.infinity, 50)),
              child: const Text('Konversi Sekarang', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 40),
            const Text('Hasil Konversi:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    '${_conversionResult.toStringAsFixed(2)} $_selectedCurrency',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
          ],
        ),
      ),
    );
  }
}