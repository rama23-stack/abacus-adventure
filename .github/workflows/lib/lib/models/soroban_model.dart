class SorobanRod {
  final int index; // 0 = satuan (kanan), 8 = ratusan juta (kiri)
  bool upperActive; // Manik atas (nilai 5) menyentuh balok tengah
  int lowerActiveCount; // Jumlah manik bawah (0..4) menyentuh balok tengah

  SorobanRod({
    required this.index,
    this.upperActive = false,
    this.lowerActiveCount = 0,
  });

  int get digitValue => (upperActive ? 5 : 0) + lowerActiveCount;

  void setDigit(int digit) {
    assert(digit >= 0 && digit <= 9);
    upperActive = digit >= 5;
    lowerActiveCount = digit % 5;
  }

  SorobanRod copy() => SorobanRod(
        index: index,
        upperActive: upperActive,
        lowerActiveCount: lowerActiveCount,
      );
}
