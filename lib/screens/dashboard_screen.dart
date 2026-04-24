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
          // Kartu Total Saldo dengan Warna Solid Pastel
          ValueListenableBuilder(
            valueListenable: controller.transactions,
            builder: (context, box, _) {
              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white, // Kartunya dibikin PUTIH BERSIH
                  borderRadius: BorderRadius.circular(20),
                  // Tapi kita kasih garis pinggir (border) warna pastel!
                  border: Border.all(color: const Color(0xFFC3B1E1), width: 2), 
                  boxShadow: [
                    BoxShadow(
                      // Shadownya kita kasih warna pastel ungu transparan biar seger
                      color: const Color(0xFFC3B1E1).withOpacity(0.3), 
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFA7C7E7).withOpacity(0.3), // Highlight biru pastel
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(
                        'Total Saldo',
                        style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatCurrency.format(controller.getTotalSaldo()),
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 36, // Digedein dikit biar tegas
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(color: Colors.black12, thickness: 1),
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Pemasukan', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              formatCurrency.format(controller.getTotalPemasukan()),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                            ),
                          ],
                        ),
                        Container(height: 30, width: 1, color: Colors.black12), // Garis pemisah tengah
                        Column(
                          children: [
                            const Text('Pengeluaran', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              formatCurrency.format(controller.getTotalPengeluaran()),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
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