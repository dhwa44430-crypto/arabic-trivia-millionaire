
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'questions.dart';
import 'dart:async';
import 'dart:math' as math;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

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
        fontFamily: 'Arial',
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

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  bool isGameOver = false;
  bool hasWon = false;
  int earnedMoney = 0;

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

    bool isCorrect = selectedIndex ==
        arabicTriviaQuestions[currentQuestionIndex].correctAnswerIndex;

    if (isCorrect) {
      bool isLastQuestion =
          currentQuestionIndex >= arabicTriviaQuestions.length - 1;

      setState(() {
        earnedMoney =
            arabicTriviaQuestions[currentQuestionIndex].prizeMoney;

        if (isLastQuestion) {
          hasWon = true;
          isGameOver = true;
        } else {
          currentQuestionIndex++;
        }
      });

      if (!isLastQuestion) {
        startTimer();
      }
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

  String formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ =
        arabicTriviaQuestions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: StudioBackgroundPainter(),
          ),
          SafeArea(
            child: isGameOver
                ? _buildGameOver()
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final screenHeight = constraints.maxHeight;

                      final prizeWidth =
                          (constraints.maxWidth * 0.19)
                              .clamp(125.0, 190.0);

                      return Row(
                        children: [
                          SizedBox(
                            width: prizeWidth,
                            height: screenHeight,
                            child: _buildPrizeLadder(),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.018,
                                vertical: 5,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.19,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        _buildTimer(),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    flex: 4,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 450,
                                      ),
                                      child: _buildQuestion(
                                        currentQ.questionText,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: screenHeight * 0.12,
                                    child: Center(
                                      child: _buildHelpButtons(),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 3,
                                    child: GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                        bottom: 5,
                                      ),
                                      itemCount: currentQ.options.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 3.5,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 9,
                                      ),
                                      itemBuilder: (context, index) {
                                        return _buildAnswerButton(
                                          index,
                                          currentQ.options[index],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizeLadder() {
    return Container(
      margin: const EdgeInsets.only(
        left: 3,
        top: 3,
        bottom: 3,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF071A35),
            Color(0xFF020D20),
            Color(0xFF071A35),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border(
          left: BorderSide(
            color: Colors.amber.withOpacity(0.65),
            width: 1.5,
          ),
          right: BorderSide(
            color: Colors.amber.withOpacity(0.65),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.18),
            blurRadius: 16,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemHeight =
              constraints.maxHeight / arabicTriviaQuestions.length;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 2,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: arabicTriviaQuestions.length,
            itemBuilder: (context, index) {
              final questionIndex =
                  arabicTriviaQuestions.length - 1 - index;

              final prize =
                  arabicTriviaQuestions[questionIndex].prizeMoney;

              final isCurrent =
                  questionIndex == currentQuestionIndex;

              return SizedBox(
                height: itemHeight,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: itemHeight * 0.78,
                    decoration: BoxDecoration(
                      gradient: isCurrent
                          ? const LinearGradient(
                              colors: [
                                Color(0xFFFFE89A),
                                Color(0xFFFFB82E),
                                Color(0xFFFFE89A),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color(0xFF10294B),
                                Color(0xFF07162E),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: isCurrent
                            ? const Color(0xFFFFE9A5)
                            : const Color(0xFF29466C),
                        width: isCurrent ? 1.8 : 1,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.65),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '\$${formatMoney(prize)}',
                          style: TextStyle(
                            color: isCurrent
                                ? const Color(0xFF17100A)
                                : const Color(0xFFFFE6A1),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTimer() {
    final timerColor =
        timeLeft <= 10 ? Colors.redAccent : const Color(0xFFFF7043);

    return Container(
      width: 76,
      height: 76,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF071326),
        boxShadow: [
          BoxShadow(
            color: timerColor.withOpacity(0.35),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: timeLeft / 30,
              strokeWidth: 4,
              backgroundColor: const Color(0xFF462D32),
              valueColor: AlwaysStoppedAnimation<Color>(
                timerColor,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'الوقت المتبقي',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$timeLeft ث',
                style: TextStyle(
                  color: timerColor,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(String question) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ClipPath(
          clipper: QuestionShapeClipper(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF142B4D),
                  Color(0xFF061329),
                  Color(0xFF142B4D),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFFFD77B),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.35),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Center(
              child: Text(
                question,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  height: 1.35,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHelpButton(
          Icons.groups_outlined,
          'الجمهور',
        ),
        const SizedBox(width: 13),
        _buildHelpButton(
          Icons.phone_in_talk_outlined,
          'صديق',
        ),
        const SizedBox(width: 13),
        _buildHelpButton(
          Icons.swap_horiz,
          'تبديل',
        ),
        const SizedBox(width: 13),
        _buildHelpButton(
          Icons.percent,
          '50:50',
        ),
      ],
    );
  }

  Widget _buildHelpButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF15365D),
            Color(0xFF06152C),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF55CFFF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlueAccent.withOpacity(0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 19,
            color: const Color(0xFFFFE6A1),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(int index, String answer) {
    const labels = ['A.', 'B.', 'C.', 'D.'];

    return InkWell(
      onTap: () => answerQuestion(index),
      child: ClipPath(
        clipper: AnswerShapeClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF19365D),
                Color(0xFF07162F),
                Color(0xFF19365D),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color: const Color(0xFFFFD27A),
              width: 1.7,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                labels[index],
                style: const TextStyle(
                  color: Color(0xFFFFD77B),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  answer,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOver() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF142B4D),
              Color(0xFF061329),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFFFFD77B),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.2),
              blurRadius: 25,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hasWon
                  ? '🎉 مبروك! أصبحت مليونيراً! 🎉'
                  : 'انتهت اللعبة!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'مجموع أرباحك: \$${formatMoney(earnedMoney)}',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: restartGame,
              child: const Text(
                'العب من جديد',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrizeLadder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF07162F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              const Text(
                'شجرة الجوائز والمبالغ',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.amber),
              Expanded(
                child: ListView.builder(
                  itemCount: arabicTriviaQuestions.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final prize =
                        arabicTriviaQuestions[index].prizeMoney;

                    final isCurrent =
                        index == currentQuestionIndex;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? Colors.amber.withOpacity(0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isCurrent
                            ? Border.all(color: Colors.amber)
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'السؤال ${index + 1}',
                            style: TextStyle(
                              color: isCurrent
                                  ? Colors.amber
                                  : Colors.white70,
                            ),
                          ),
                          Text(
                            '\$${formatMoney(prize)}',
                            style: TextStyle(
                              color: isCurrent
                                  ? Colors.amber
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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

class QuestionShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width * 0.09, 0);
    path.lineTo(size.width * 0.91, 0);
    path.quadraticBezierTo(
      size.width * 0.96,
      0,
      size.width * 0.98,
      size.height * 0.25,
    );
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.98, size.height * 0.75);
    path.quadraticBezierTo(
      size.width * 0.96,
      size.height,
      size.width * 0.91,
      size.height,
    );
    path.lineTo(size.width * 0.09, size.height);
    path.quadraticBezierTo(
      size.width * 0.04,
      size.height,
      size.width * 0.02,
      size.height * 0.75,
    );
    path.lineTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.02, size.height * 0.25);
    path.quadraticBezierTo(
      size.width * 0.04,
      0,
      size.width * 0.09,
      0,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AnswerShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width * 0.06, 0);
    path.lineTo(size.width * 0.94, 0);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.94, size.height);
    path.lineTo(size.width * 0.06, size.height);
    path.lineTo(0, size.height * 0.5);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class StudioBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF020817),
          Color(0xFF061B38),
          Color(0xFF020817),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      background,
    );

    final spotlightPaint = Paint()
      ..color = const Color(0xFF0755B5).withOpacity(0.17)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        35,
      );

    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.18 + i * 0.17);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, size.height * 0.3),
          width: size.width * 0.055,
          height: size.height * 1.3,
        ),
        spotlightPaint,
      );
    }

    final blueGlow = Paint()
      ..color = const Color(0xFF008CFF).withOpacity(0.22)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        25,
      );

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.35),
      size.width * 0.12,
      blueGlow,
    );

    final dotPaint = Paint()
      ..color = const Color(0xFF76C8FF).withOpacity(0.55)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        5,
      );

    for (int i = 0; i < 35; i++) {
      final x = (i * 83.0) % size.width;
      final y = (i * 47.0) % (size.height * 0.65);

      canvas.drawCircle(
        Offset(x, y),
        i % 3 == 0 ? 2.5 : 1.5,
        dotPaint,
      );
    }

    final goldLine = Paint()
      ..color = const Color(0xFFFFC75E).withOpacity(0.38)
      ..strokeWidth = 1.2;

    canvas.drawLine(
      Offset(0, size.height * 0.52),
      Offset(size.width, size.height * 0.52),
      goldLine,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.87),
      Offset(size.width, size.height * 0.87),
      goldLine,
    );

    final glowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.13)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        30,
      );

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.8),
      60,
      glowPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.8),
      60,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
