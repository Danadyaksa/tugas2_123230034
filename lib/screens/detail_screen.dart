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
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nama: ${transaction.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Kategori: ${transaction.category}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Jenis: ${transaction.type}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Nominal: ${formatCurrency.format(transaction.amount)}', style: const TextStyle(fontSize: 16, color: Colors.teal)),
                const SizedBox(height: 8),
                Text('Tanggal: ${formatDate.format(transaction.date)}', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}