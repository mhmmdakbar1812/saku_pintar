class TransactionModel {
  final dynamic id;
  final String description;
  final double amount;
  final String category;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    // Ambil nilai harga dari Supabase
    double basePrice = (map['harga'] ?? 0).toDouble();
    
    // Jika tipenya 'keluar', kita jadikan angkanya minus agar grafik & saldo otomatis menyesuaikan
    if (map['tipe'] == 'keluar') {
      basePrice = -basePrice;
    }

    return TransactionModel(
      id: map['id'], 
      description: map['item'] ?? 'Tanpa Keterangan', // Sesuai kolom di Supabase
      amount: basePrice, 
      category: map['kategori'] ?? 'Umum',
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}