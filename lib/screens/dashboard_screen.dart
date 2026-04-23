import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction.dart';
import 'detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TransactionController();
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formatDate = DateFormat('dd MMMM yyyy HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Kartu Total Saldo dengan Warna Pastel
          ValueListenableBuilder(
            valueListenable: controller.transactions,
            builder: (context, box, _) {
              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA7C7E7), Color(0xFFC3B1E1)], // Pastel Blue ke Pastel Purple
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      'Total Saldo',
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency.format(controller.getTotalSaldo()),
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Judul Riwayat Transaksi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Transaksi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey[800]),
              ),
            ),
          ),
          
          // Daftar Riwayat Transaksi
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: controller.transactions,
              builder: (context, box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada transaksi',
                      style: TextStyle(color: Colors.blueGrey[400], fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    // Mengambil data dari yang terbaru (reverse index)
                    final Transaction tx = box.getAt(box.length - 1 - index)!;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: tx.type == 'Pemasukan' 
                              ? Colors.green.shade50 
                              : Colors.red.shade50,
                          child: Icon(
                            tx.type == 'Pemasukan' ? Icons.arrow_downward : Icons.shopping_cart,
                            color: tx.type == 'Pemasukan' ? Colors.green : Colors.redAccent,
                          ),
                        ),
                        title: Text(
                          tx.title, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                        subtitle: Text(
                          formatDate.format(tx.date),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        trailing: Text(
                          (tx.type == 'Pemasukan' ? '+' : '-') + formatCurrency.format(tx.amount),
                          style: TextStyle(
                            color: tx.type == 'Pemasukan' ? Colors.green : Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailScreen(transaction: tx)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}