import 'package:flutter/material.dart';
import '../services/currency_service.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _service = CurrencyService();
  final _amountController = TextEditingController(); // Controller untuk input nominal
  String _selectedCurrency = 'USD';
  double _conversionResult = 0.0;
  bool _isLoading = false;

  void _convert() async {
    // Validasi jika input kosong
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nominal Rupiah terlebih dahulu')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final double rate = await _service.getConversionRate(_selectedCurrency);
      final double inputAmount = double.parse(_amountController.text);
      
      setState(() {
        _conversionResult = inputAmount * rate;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Mata Uang', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan Nominal (IDR)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            ),
            const SizedBox(height: 10),
            // Field Input Nominal
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 50000',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixText: 'Rp ',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pilih Mata Uang Asing',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: _selectedCurrency,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ['USD', 'EUR', 'JPY'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedCurrency = val.toString()),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _convert,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC3B1E1), // Pastel Blue
                foregroundColor: Colors.blueGrey[900],
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 55),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Konversi Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Text('Hasil Konversi:', style: TextStyle(fontSize: 14, color: Colors.blueGrey[500])),
                  const SizedBox(height: 10),
                  Text(
                    '${_conversionResult.toStringAsFixed(2)} $_selectedCurrency',
                    style: TextStyle(
                      fontSize: 36, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.blueGrey[900],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}