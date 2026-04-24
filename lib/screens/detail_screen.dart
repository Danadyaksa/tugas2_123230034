import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class DetailScreen extends StatelessWidget {
  final Transaction transaction;
  const DetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formatDate = DateFormat('dd MMMM yyyy HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon besar di tengah atas
              CircleAvatar(
                radius: 40,
                backgroundColor: transaction.type == 'Pemasukan' 
                    ? Colors.green.shade50 
                    : Colors.red.shade50,
                child: Icon(
                  transaction.type == 'Pemasukan' ? Icons.arrow_downward : Icons.shopping_cart,
                  size: 40,
                  color: transaction.type == 'Pemasukan' ? Colors.green : Colors.redAccent,
                ),
              ),
              const SizedBox(height: 24),

              // Judul Transaksi
              Text(
                transaction.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 8),

              // Nominal Besar
              Text(
                formatCurrency.format(transaction.amount),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: transaction.type == 'Pemasukan' ? Colors.green[700] : Colors.red[700],
                ),
              ),
              
              const SizedBox(height: 32),
              const Divider(thickness: 1, color: Colors.black12),
              const SizedBox(height: 32),

              // Detail-detail lainnya (Kategori, Tipe, Tanggal)
              _buildDetailItem('Kategori', transaction.category),
              const SizedBox(height: 20),
              _buildDetailItem('Tipe Transaksi', transaction.type),
              const SizedBox(height: 20),
              _buildDetailItem('Waktu Transaksi', formatDate.format(transaction.date)),
              
              const SizedBox(height: 50),
              
              // Tombol Kembali dengan gaya pastel
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA7C7E7), // Pastel Blue
                  foregroundColor: Colors.blueGrey[900],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Kembali ke Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk membuat baris detail yang terpusat
  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.blueGrey[400],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[800],
          ),
        ),
      ],
    );
  }
}