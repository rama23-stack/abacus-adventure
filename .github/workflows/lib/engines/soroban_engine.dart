import 'package:flutter/foundation.dart';
import '../models/soroban_model.dart';

class SorobanEngine extends ChangeNotifier {
  static const int rodCount = 9;
  late List<SorobanRod> _rods;

  SorobanEngine() {
    reset();
  }

  List<SorobanRod> get rods => _rods;

  void reset() {
    // Index 0 adalah paling kiri (10^8), index 8 adalah paling kanan (satuan)
    _rods = List.generate(rodCount, (i) => SorobanRod(index: i));
    notifyListeners();
  }

  int get totalValue {
    int total = 0;
    for (int i = 0; i < rodCount; i++) {
      int placeValue = 1;
      for (int p = 0; p < (rodCount - 1 - i); p++) {
        placeValue *= 10;
      }
      total += _rods[i].digitValue * placeValue;
    }
    return total;
  }

  void setNumber(int number) {
    if (number < 0 || number > 999999999) return;
    String padded = number.toString().padLeft(rodCount, '0');
    for (int i = 0; i < rodCount; i++) {
      _rods[i].setDigit(int.parse(padded[i]));
    }
    notifyListeners();
  }

  void toggleUpperBead(int rodIndex) {
    _rods[rodIndex].upperActive = !_rods[rodIndex].upperActive;
    notifyListeners();
  }

  void tapLowerBead(int rodIndex, int beadPosition) {
    // beadPosition: 1 (paling atas di bawah balok) sampai 4 (paling bawah)
    if (_rods[rodIndex].lowerActiveCount >= beadPosition) {
      // Turunkan manik dari posisi ini ke bawah
      _rods[rodIndex].lowerActiveCount = beadPosition - 1;
    } else {
      // Naikkan manik sampai posisi ini
      _rods[rodIndex].lowerActiveCount = beadPosition;
    }
    notifyListeners();
  }
}
