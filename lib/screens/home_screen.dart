import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../services/progress_service.dart';
import 'learning_screen.dart';
import 'practice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProgressService _progress = ProgressService();
  int _unlockedLevel = 1;
  int _stars = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final lvl = await _progress.getUnlockedLevel();
    final st = await _progress.getTotalStars();
    setState(() {
      _unlockedLevel = lvl;
      _stars = st;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FC3F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Sidebar Kiri: Profil & Mode Bermain
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text('🐻 ABACUS ADVENTURE', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('⭐ Total Bintang: $_stars', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PracticeScreen(isMentalMode: false)));
                      },
                      child: const Text('🧮 Digital Soroban & Latihan', style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PracticeScreen(isMentalMode: true)));
                      },
                      child: const Text('🧠 Mental Arithmetic', style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Area Kanan: Peta Kurikulum 12 Level
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Peta Belajar Soroban (Level 1–12)', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0277BD))),
                      const SizedBox(height: 12),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1.35,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: kCurriculumLevels.length,
                          itemBuilder: (context, index) {
                            final lesson = kCurriculumLevels[index];
                            final isUnlocked = lesson.level <= _unlockedLevel;
                            return InkWell(
                              onTap: isUnlocked
                                  ? () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => LearningScreen(lesson: lesson)),
                                      );
                                      _loadProgress();
                                    }
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isUnlocked ? (lesson.isAdvanced ? Colors.orange.shade100 : Colors.lightGreen.shade100) : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isUnlocked ? Colors.green : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isUnlocked ? 'Level ${lesson.level}' : '🔒 Level ${lesson.level}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      lesson.title,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
