class LessonLevel {
  final int level;
  final String title;
  final String targetSkill;
  final bool isAdvanced;

  const LessonLevel({
    required this.level,
    required this.title,
    required this.targetSkill,
    this.isAdvanced = false,
  });
}

const List<LessonLevel> kCurriculumLevels = [
  LessonLevel(level: 1, title: 'Mengenal Soroban', targetSkill: 'Memahami manik atas & bawah'),
  LessonLevel(level: 2, title: 'Angka 0–4', targetSkill: 'Menggerakkan manik bawah'),
  LessonLevel(level: 3, title: 'Angka 5', targetSkill: 'Memahami manik atas'),
  LessonLevel(level: 4, title: 'Angka 6–9', targetSkill: 'Menggabungkan manik'),
  LessonLevel(level: 5, title: 'Puluhan & Ratusan', targetSkill: 'Membentuk nilai tempat'),
  LessonLevel(level: 6, title: 'Teman Kecil', targetSkill: 'Komplemen 5'),
  LessonLevel(level: 7, title: 'Teman Besar', targetSkill: 'Komplemen 10'),
  LessonLevel(level: 8, title: 'Penjumlahan', targetSkill: 'Operasi bertingkat'),
  LessonLevel(level: 9, title: 'Pengurangan', targetSkill: 'Operasi bertingkat'),
  LessonLevel(level: 10, title: 'Perkalian', targetSkill: 'Perkalian Soroban', isAdvanced: true),
  LessonLevel(level: 11, title: 'Pembagian', targetSkill: 'Pembagian Soroban', isAdvanced: true),
  LessonLevel(level: 12, title: 'Mental Arithmetic', targetSkill: 'Membayangkan sempoa', isAdvanced: true),
];
