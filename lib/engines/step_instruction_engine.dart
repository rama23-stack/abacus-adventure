class SorobanStep {
  final String instruction;
  final String ruleType; // 'Langsung', 'Teman Kecil', 'Teman Besar'
  final int targetValue;

  SorobanStep({
    required this.instruction,
    required this.ruleType,
    required this.targetValue,
  });
}

class StepInstructionEngine {
  /// Menghasilkan langkah-langkah penambahan satu digit (1..9) pada nilai saat ini
  static List<SorobanStep> explainAddition(int currentTotal, int addend) {
    int ones = currentTotal % 10;
    int lowerAvailable = 4 - (ones % 5);
    bool upperAvailable = ones < 5;

    // 1. Cek Penambahan Langsung
    if (addend < 5 && lowerAvailable >= addend) {
      return [
        SorobanStep(
          instruction: 'Naikkan $addend manik bawah secara langsung.',
          ruleType: 'Langsung',
          targetValue: currentTotal + addend,
        )
      ];
    }
    if (addend == 5 && upperAvailable) {
      return [
        SorobanStep(
          instruction: 'Turunkan manik atas (nilai 5) secara langsung.',
          ruleType: 'Langsung',
          targetValue: currentTotal + 5,
        )
      ];
    }
    if (addend > 5 && upperAvailable && lowerAvailable >= (addend - 5)) {
      return [
        SorobanStep(
          instruction:
              'Jepit manik atas (5) dan ${addend - 5} manik bawah bersamaan.',
          ruleType: 'Langsung',
          targetValue: currentTotal + addend,
        )
      ];
    }

    // 2. Cek Teman Kecil (Komplemen 5: +a = +5 - (5-a))
    if (addend < 5 && upperAvailable && (ones % 5) >= (5 - addend)) {
      int smallFriend = 5 - addend;
      return [
        SorobanStep(
          instruction:
              'Manik bawah tidak cukup! Gunakan Teman Kecil $addend yaitu $smallFriend: Turunkan manik atas (5) dan turunkan $smallFriend manik bawah.',
          ruleType: 'Teman Kecil',
          targetValue: currentTotal + addend,
        )
      ];
    }

    // 3. Cek Teman Besar (Komplemen 10: +a = +10 - (10-a))
    int bigFriend = 10 - addend;
    return [
      SorobanStep(
        instruction:
            'Satuan penuh! Gunakan Teman Besar $addend yaitu $bigFriend: Kurangi $bigFriend di batang satuan, lalu naikkan 1 manik di batang puluhan.',
        ruleType: 'Teman Besar',
        targetValue: currentTotal + addend,
      )
    ];
  }
}
