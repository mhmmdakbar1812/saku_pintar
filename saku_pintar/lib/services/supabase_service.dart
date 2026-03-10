import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // Mengambil semua transaksi
  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await _supabase
        .from('transaksi')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((data) => TransactionModel.fromMap(data))
        .toList();
  }

  // Menghitung total saldo (Pemasukan - Pengeluaran)
  Future<double> getTotalBalance() async {
    final response = await _supabase.from('transaksi').select('harga');
    double total = 0;
    for (var item in response) {
      total += (item['harga'] as num).toDouble();
    }
    return total;
  }
}