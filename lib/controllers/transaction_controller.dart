import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionController {
  static final TransactionController _instance = TransactionController._internal();
  factory TransactionController() => _instance;
  TransactionController._internal();

  ValueListenable<Box<Transaction>> get transactions => Hive.box<Transaction>('transactions').listenable();

  Future<void> addTransaction(Transaction transaction) async {
    final box = Hive.box<Transaction>('transactions');
    await box.add(transaction);
  }

  double getTotalSaldo() {
    final box = Hive.box<Transaction>('transactions');
    double total = 0;
    for (var tx in box.values) {
      if (tx.type == 'Pemasukan') total += tx.amount;
      else total -= tx.amount;
    }
    return total;
  }
  
  double getTotalPengeluaran() {
    final box = Hive.box<Transaction>('transactions');
    double total = 0;
    for (var tx in box.values) {
      if (tx.type == 'Pengeluaran') total += tx.amount;
    }
    return total;
  }

  double getTotalPemasukan() {
    final box = Hive.box<Transaction>('transactions');
    double total = 0;
    for (var tx in box.values) {
      if (tx.type == 'Pemasukan') total += tx.amount;
    }
    return total;
  }
}