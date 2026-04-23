import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String type; // "Pemasukan" atau "Pengeluaran"

  @HiveField(2)
  final String category; // "Makan", "Transportasi", "Hiburan", dll

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final DateTime date;

  Transaction({
    required this.title,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
  });
}