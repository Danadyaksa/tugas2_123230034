import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String baseUrl = 'https://api.frankfurter.app/latest?from=IDR';

  Future<double> getConversionRate(String targetCurrency) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['rates'];
        if (rates.containsKey(targetCurrency)) {
          return rates[targetCurrency].toDouble();
        }
      }
      throw Exception('Gagal memuat data dari API');
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi');
    }
  }
}