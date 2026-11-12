import 'package:flutter/material.dart';
import 'questions.dart';

void main() {
  runApp(const MillionaireApp());
}

class MillionaireApp extends StatelessWidget {
  const MillionaireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'من سيربح المليار',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentQuestionIndex = 0;
  bool isGameOver = false;
  bool hasWon = false;
  int earnedMoney = 0;

  void answerQuestion(int selectedIndex) {
    bool isCorrect = selectedIndex == arabicTriviaQuestions[currentQuestionIndex].correctAnswerIndex;

    if (isCorrect) {
      setState(() {
        earnedMoney = arabicTriviaQuestions[currentQuestionIndex].prizeMoney;
        if (currentQuestionIndex < arabicTriviaQuestions.length - 1) {
          currentQuestionIndex++;
        } else {
          hasWon = true;
          isGameOver = true;
        }
      });
    } else {
      setState(() {
        isGameOver = true;
      });
    }
  }

  void restartGame() {
    setState(() {
      currentQuestionIndex = 0;
      isGameOver = false;
      hasWon = false;
      earnedMoney = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = arabicTriviaQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('من سيربح المليار'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: isGameOver
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hasWon ? '🎉 مبروك! لقد فزت بالمليون! 🎉' : 'انتهت اللعبة!',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'المبلغ الذي ربحته: \$$earnedMoney',
                      style: const TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      onPressed: restartGame,
                      child: const Text('العب من جديد', style: TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'السؤال ${currentQuestionIndex + 1} من ${arabicTriviaQuestions.length}',
                        style: const TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                      Text(
                        'الجائزة: \$${currentQ.prizeMoney}',
                        style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
                    ),
                    child: Text(
                      currentQ.questionText,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ...List.generate(currentQ.options.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF334155),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.amber, width: 1),
                          ),
                        ),
                        onPressed: () => answerQuestion(index),
                        child: Text(
                          currentQ.options[index],
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
