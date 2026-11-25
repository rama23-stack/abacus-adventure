import 'package:flutter/material.dart';
import '../engines/soroban_engine.dart';
import '../engines/step_instruction_engine.dart';
import '../models/lesson_model.dart';
import '../services/progress_service.dart';
import '../widgets/soroban_widget.dart';

class LearningScreen extends StatefulWidget {
  final LessonLevel lesson;
  const LearningScreen({super.key, required this.lesson});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final SorobanEngine _engine = SorobanEngine();
  final ProgressService _progress = ProgressService();

  int _stepIndex = 0;
  late List> _tasks;
  String _bearMessage = '';

  @override
  void initState() {
    super.initState();
    _initTasksForLevel();
  }

  void _initTasksForLevel() {
    switch (widget.lesson.level) {
      case 1:
      case 2:
        _tasks = [
          {'prompt': 'Bentuk angka 2 di sempoa!', 'start': 0, 'target': 2},
          {'prompt': 'Bentuk angka 4 di sempoa!', 'start': 0, 'target': 4},
        ];
        break;
      case 3:
        _tasks = [
          {'prompt': 'Turunkan manik atas untuk membuat angka 5!', 'start': 0, 'target': 5},
        ];
        break;
      case 6: // Teman Kecil
        _tasks = [
          {'prompt': 'Hitung 3 + 4 menggunakan Teman Kecil!', 'start': 3, 'target': 7},
          {'prompt': 'Hitung 4 + 2 menggunakan Teman Kecil!', 'start': 4, 'target': 6},
        ];
        break;
      case 7: // Teman Besar
        _tasks = [
          {'prompt': 'Hitung 8 + 4 menggunakan Teman Besar!', 'start': 8, 'target': 12},
          {'prompt': 'Hitung 7 + 5 menggunakan Teman Besar!', 'start': 7, 'target': 12},
        ];
        break;
      default:
        _tasks = [
          {'prompt': 'Bentuk angka ${widget.lesson.level * 3} pada sempoa!', 'start': 0, 'target': widget.lesson.level * 3},
        ];
    }
    _loadCurrentTask();
  }

  void _loadCurrentTask() {
    final task = _tasks[_stepIndex];
    _engine.setNumber(task['start']);
    setState(() {
      _bearMessage = task['prompt'];
    });
  }

  void _showHint() {
    final task = _tasks[_stepIndex];
    int diff = task['target'] - _engine.totalValue;
    if (diff > 0 && diff <= 9) {
      final steps = StepInstructionEngine.explainAddition(_engine.totalValue, diff);
      setState(() {
        _bearMessage = 'Petunjuk Beruang (${steps.first.ruleType}): ${steps.first.instruction}';
      });
    } else {
      setState(() {
        _bearMessage = 'Ayo sesuaikan manik agar nilainya menjadi ${task['target']}!';
      });
    }
  }

  void _checkAnswer() async {
    final task = _tasks[_stepIndex];
    if (_engine.totalValue == task['target']) {
      if (_stepIndex < _tasks.length - 1) {
        setState(() {
          _stepIndex++;
        });
        _loadCurrentTask();
      } else {
        await _progress.completeLevel(widget.lesson.level, 3);
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Hebat! Level Selesai!'),
            content: const Text('Kamu mendapatkan 3 Bintang! Level berikutnya telah terbuka.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Lanjut'),
              )
            ],
          ),
        );
      }
    } else {
      setState(() {
        _bearMessage = 'Belum tepat, nilai saat ini ${_engine.totalValue}. Coba lagi ya!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0288D1),
        title: Text('Level ${widget.lesson.level}: ${widget.lesson.title}'),
        actions: [
          AnimatedBuilder(
            animation: _engine,
            builder: (_, __) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Nilai: ${_engine.totalValue}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
      body: Row(
        children: [
          // Panel Kiri: Maskot Beruang & Instruksi
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange, width: 3),
                    ),
                    child: Column(
                      children: [
                        const Text('🐻 Beruang Kecil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                        const SizedBox(height: 8),
                        Text(_bearMessage, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.all(14)),
                        onPressed: _showHint,
                        icon: const Icon(Icons.lightbulb),
                        label: const Text('Petunjuk'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(14)),
                        onPressed: _checkAnswer,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Periksa'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // Panel Kanan: Sempoa 9 Batang
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SorobanWidget(engine: _engine),
            ),
          ),
        ],
      ),
    );
  }
}
