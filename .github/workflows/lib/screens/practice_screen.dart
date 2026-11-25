import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../engines/soroban_engine.dart';
import '../widgets/soroban_widget.dart';

class PracticeScreen extends StatefulWidget {
  final bool isMentalMode;
  const PracticeScreen({super.key, this.isMentalMode = false});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final SorobanEngine _engine = SorobanEngine();
  final Random _rng = Random();

  int _numA = 0;
  int _numB = 0;
  bool _hideAbacus = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    _engine.reset();
    _numA = _rng.nextInt(15) + 1;
    _numB = _rng.nextInt(9) + 1;
    _hideAbacus = false;
    _status = 'Bayangkan manik sempoa untuk: $_numA + $_numB';

    if (widget.isMentalMode) {
      // Tampilkan angka pertama di sempoa selama 2 detik lalu sembunyikan
      _engine.setNumber(_numA);
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _hideAbacus = true;
            _status = 'Sempoa disembunyikan! Hitung $_numA + $_numB di kepalamu lalu masukkan hasilnya.';
          });
        }
      });
    } else {
      _status = 'Hitung: $_numA + $_numB';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.isMentalMode ? 'Mental Arithmetic' : 'Latihan Soroban'),
        actions: [
          TextButton(
            onPressed: _engine.reset,
            child: const Text('Reset Sempoa', style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(_status, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                  onPressed: () {
                    setState(() => _hideAbacus = false);
                    int target = _numA + _numB;
                    if (_engine.totalValue == target) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Benar sekali!'), backgroundColor: Colors.green),
                      );
                      _nextQuestion();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Jawabanmu ${_engine.totalValue}, seharusnya $target.'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: const Text('Cek Jawaban', style: TextStyle(fontSize: 18)),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _hideAbacus
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          '🧠 Bayangkan posisi manik di pikiranmu!\n(Klik Cek Jawaban jika sudah siap)',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : SorobanWidget(engine: _engine),
            ),
          ],
        ),
      ),
    );
  }
}
