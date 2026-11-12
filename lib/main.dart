import 'package:flutter/material.dart';
import 'questions.dart';
import 'dart:async';

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
        scaffoldBackgroundColor: const Color(0xFF020617),
        primaryColor: Colors.amber,
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

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  bool isGameOver = false;
  bool hasWon = false;
  int earnedMoney = 0;
  
  // مؤقت الوقت
  int timeLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      timeLeft = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          isGameOver = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void answerQuestion(int selectedIndex) {
    _timer?.cancel();
    bool isCorrect = selectedIndex == arabicTriviaQuestions[currentQuestionIndex].correctAnswerIndex;

    if (isCorrect) {
      setState(() {
        earnedMoney = arabicTriviaQuestions[currentQuestionIndex].prizeMoney;
        if (currentQuestionIndex < arabicTriviaQuestions.length - 1) {
          currentQuestionIndex++;
          startTimer();
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
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = arabicTriviaQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('من سيربح المليار 🏆', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: Colors.amber),
            onPressed: () => _showPrizeLadder(context),
          ),
        ],
      ),
      body: isGameOver
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hasWon ? '🎉 مبروك! أصبحت مليونيراً! 🎉' : 'انتهت اللعبة!',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.amber),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'مجموع أرباحك: \$${earnedMoney.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(fontSize: 22, color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: restartGame,
                      child: const Text('العب من جديد', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
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
                  // شريط المعلومات العلوية (المؤقت والجوائز)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: timeLeft <= 10 ? Colors.red.withOpacity(0.3) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: timeLeft <= 10 ? Colors.red : Colors.amber),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer, size: 18, color: Colors.amber),
                            const SizedBox(width: 5),
                            Text('$timeLeft ثوانٍ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Text(
                          'السؤال ${currentQuestionIndex + 1} / ${arabicTriviaQuestions.length}',
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // شريط الجائزة الحالية والمليون
                  Center(
                    child: Text(
                      'السؤال بقيمة: \$${currentQ.prizeMoney}',
                      style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // صندوق السؤال بتصميم أنيق ومتحرك
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      key: ValueKey<int>(currentQuestionIndex),
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.amber, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.15),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Text(
                        currentQ.questionText,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // وسائل المساعدة (حسب الصورة الاحترافية)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHelpButton(Icons.people, 'الجمهور'),
                      const SizedBox(width: 15),
                      _buildHelpButton(Icons.phone, 'صديق'),
                      const SizedBox(width: 15),
                      _buildHelpButton(Icons.tv, 'جمهور'),
                      const SizedBox(width: 15),
                      _buildHelpButton(Icons.close, '50:50'),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // خيارات الإجابة (جنباً إلى جنب - شبكية احترافية مثل الصورة)
                  Expanded(
                    child: GridView.builder(
                      itemCount: currentQ.options.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // خيارين في كل صف تماماً مثل الصورة
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        List<String> labels = ['A.', 'B.', 'C.', 'D.'];
                        return InkWell(
                          onTap: () => answerQuestion(index),
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1E293B), Color(0xFF334155)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.amber.withOpacity(0.7), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    labels[index],
                                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      currentQ.options[index],
                                      style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ودجت أزرار المساعدة العلوية
  Widget _buildHelpButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.amber),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // نافذة شجرة الجوائز (عرض مستويات المليون)
  void _showPrizeLadder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('شجرة الجوائز والمبالغ', style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(color: Colors.amber),
              Expanded(
                child: ListView.builder(
                  itemCount: arabicTriviaQuestions.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final prize = arabicTriviaQuestions[index].prizeMoney;
                    final isCurrent = index == currentQuestionIndex;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isCurrent ? Colors.amber.withOpacity(0.3) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isCurrent ? Border.all(color: Colors.amber) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('السؤال ${index + 1}', style: TextStyle(color: isCurrent ? Colors.amber : Colors.white70)),
                          Text('\$$prize', style: TextStyle(color: isCurrent ? Colors.amber : Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
