import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/supabase_service.dart';
import '../models/transaction.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  
  List<TransactionModel> _transactions = [];
  double _totalBalance = 0;
  Map<String, double> _categoryTotals = {};
  bool _isLoading = true;

  // Variabel untuk Insight Boros vs Hemat
  String _insightMessage = "";
  bool _isBoros = false;

  // Daftar warna untuk tiap potongan Pie Chart
  final List<Color> _chartColors = [
    Colors.teal, Colors.orange, Colors.blue, Colors.red, 
    Colors.purple, Colors.green, Colors.amber, Colors.indigo
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Fungsi untuk mengambil data dari Supabase dan memproses Insight
  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await _supabaseService.fetchTransactions();
      final balance = await _supabaseService.getTotalBalance();

      // 1. Mengelompokkan nominal berdasarkan kategori untuk grafik
      Map<String, double> catTotals = {};
      
      // 2. Variabel untuk menghitung Boros vs Hemat
      double currentMonthExpense = 0;
      double lastMonthExpense = 0;
      DateTime now = DateTime.now();

      for (var t in transactions) {
        // --- LOGIKA GRAFIK ---
        double amountAbs = t.amount.abs(); 
        if (catTotals.containsKey(t.category)) {
          catTotals[t.category] = catTotals[t.category]! + amountAbs;
        } else {
          catTotals[t.category] = amountAbs;
        }

        // --- LOGIKA INSIGHT BOROS VS HEMAT ---
        // Asumsi pengeluaran bernilai negatif (< 0)
        if (t.amount < 0) {
          DateTime tDate = t.createdAt; 
          
          // Cek apakah transaksi di bulan ini
          if (tDate.year == now.year && tDate.month == now.month) {
            currentMonthExpense += amountAbs;
          } 
          // Cek apakah transaksi di bulan lalu
          else if ((now.month == 1 && tDate.year == now.year - 1 && tDate.month == 12) ||
                   (now.month > 1 && tDate.year == now.year && tDate.month == now.month - 1)) {
            lastMonthExpense += amountAbs;
          }
        }
      }

      // 3. Menentukan Teks Kesimpulan Insight
      String conclusion = "";
      bool isBoros = false;

      if (lastMonthExpense == 0 && currentMonthExpense > 0) {
        conclusion = "Pengeluaran bulan ini Rp ${currentMonthExpense.toStringAsFixed(0)}. Belum ada data bulan lalu untuk dibandingkan.";
      } else if (lastMonthExpense == 0 && currentMonthExpense == 0) {
        conclusion = "Yuk, mulai catat pengeluaran pertamamu di Saku Pintar!";
      } else {
        double diff = currentMonthExpense - lastMonthExpense;
        double percentage = (diff.abs() / lastMonthExpense) * 100;

        if (diff > 0) {
          isBoros = true;
          conclusion = "Waduh! Kamu lebih boros ${percentage.toStringAsFixed(1)}% (Rp ${diff.toStringAsFixed(0)}) dibanding bulan lalu. Yuk, rem pengeluaranmu!";
        } else if (diff < 0) {
          isBoros = false;
          conclusion = "Hebat! Kamu lebih hemat ${percentage.toStringAsFixed(1)}% (Rp ${diff.abs().toStringAsFixed(0)}) dibanding bulan lalu. Pertahankan!";
        } else {
          isBoros = false;
          conclusion = "Pengeluaranmu bulan ini persis sama dengan bulan lalu.";
        }
      }

      // Update State
      setState(() {
        _transactions = transactions;
        _totalBalance = balance;
        _categoryTotals = catTotals;
        _insightMessage = conclusion;
        _isBoros = isBoros;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  // Fungsi untuk merender potongan grafik Pie tanpa teks di dalamnya
  List<PieChartSectionData> _generateChartSections() {
    if (_categoryTotals.isEmpty) {
      return [PieChartSectionData(value: 1, color: Colors.grey.shade300, title: '', showTitle: false)];
    }

    int colorIndex = 0;
    return _categoryTotals.entries.map((entry) {
      final color = _chartColors[colorIndex % _chartColors.length];
      colorIndex++;
      
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '', 
        showTitle: false, // Teks disembunyikan
        radius: 60,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Dashboard Keuangan"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.teal))
        : RefreshIndicator(
            onRefresh: _loadDashboardData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- 1. KARTU SALDO UTAMA ---
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text("Total Saldo Saat Ini", 
                              style: TextStyle(fontSize: 16, color: Colors.grey)),
                            const SizedBox(height: 8),
                            Text(
                              "Rp ${_totalBalance.toStringAsFixed(0)}", 
                              style: const TextStyle(
                                fontSize: 32, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.teal
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- 2. KARTU INSIGHT (Boros/Hemat) ---
                    if (_insightMessage.isNotEmpty)
                      Card(
                        color: _isBoros ? Colors.red.shade50 : Colors.teal.shade50,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            color: _isBoros ? Colors.red.shade200 : Colors.teal.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _isBoros ? Colors.red.shade100 : Colors.teal.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isBoros ? Icons.trending_up : Icons.trending_down,
                                  color: _isBoros ? Colors.red.shade700 : Colors.teal.shade700,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Insight AI",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: _isBoros ? Colors.red.shade700 : Colors.teal.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _insightMessage,
                                      style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // --- 3. GRAFIK PIE CHART ---
                    const Text("Distribusi Kategori", 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: _generateChartSections(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- 4. CUSTOM LEGEND GRAFIK ---
                    if (_categoryTotals.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _categoryTotals.length,
                        itemBuilder: (context, index) {
                          String categoryName = _categoryTotals.keys.elementAt(index);
                          double categoryAmount = _categoryTotals.values.elementAt(index);
                          Color dotColor = _chartColors[index % _chartColors.length];

                          double totalAllCategories = _categoryTotals.values.fold(0, (sum, item) => sum + item);
                          double percentage = (categoryAmount / totalAllCategories) * 100;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    categoryName,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${percentage.toStringAsFixed(1)}%",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      "Rp ${categoryAmount.toStringAsFixed(0)}",
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 32),

                    // --- 5. DAFTAR TRANSAKSI TERAKHIR ---
                    const Text("Transaksi Terakhir", 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final t = _transactions[index];
                        final isIncome = t.amount >= 0;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isIncome ? Colors.green[100] : Colors.red[100],
                              child: Icon(
                                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(t.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("${t.category} • ${t.createdAt.day}/${t.createdAt.month}/${t.createdAt.year}"),
                            trailing: Text(
                              "${isIncome ? '+' : ''}Rp ${t.amount.abs().toStringAsFixed(0)}",
                              style: TextStyle(
                                color: isIncome ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }
}