import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'questions.dart';
import 'dart:async';
import 'dart:math' as math;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
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

// ---------------------------------------------------------
// نظام محتوى الاستوديو المطور (أقوال، معلومات، حكم، تشجيع جمهور) بدون تكرار
// ---------------------------------------------------------
class StudioContentManager {
  static final math.Random _random = math.Random();

  static final List<String> _famousQuotes = [
    '«هل أنت متأكد من هذه الإجابة، أم أنك تريد الانسحاب؟»',
    '«هذا السؤال يفصلك عن المجد، فكر جيدا!»',
    '«الجمهور يترقب إجابتك بفارغ الصبر يا أسطورة!»',
    '«خطوة واحدة تفصلك عن القمة، ركز جيداً.»',
    '«القرارات الصعبة هي التي تصنع الأبطال الحقيقيين.»',
    '«العقل السليم في التفكير السليم، خذ وقتك.»',
    '«الاستوديو كله صامت بانتظار قرارك النهائي!»',
    '«لا تهاب الصعاب، فالملايين تنتظر البطل المناسب.»',
    '«الذكاء ليس في معرفة كل شيء، بل في معرفة كيف تفكر.»',
    '«هذه اللحظات هي التي تبقى في الذاكرة للأبد!»',
  ];

  static final List<String> _generalInfo = [
    'هل تعلم؟ الدماغ البشري يولد طاقة كهربائية كافية لتشغيل مصباح صغير.',
    'هل تعلم؟ العسل هو الطعام الوحيد الذي لا يفسد أبداً ويبقى صالحاً لآلاف السنين.',
    'هل تعلم؟ النعامة تمتلك عيوناً أكبر من حجم دماغها بالكامل.',
    'هل تعلم؟ الماء الساخن يتجمد أسرع من الماء البارد في ظروف معينة.',
    'هل تعلم؟ بصمة الإصبع تختلف لدى البشر تماماً مثل بصمة اللسان.',
    'هل تعلم؟ اليابان تتكون من أكثر من 6,800 جزيرة مختلفة.',
    'هل تعلم؟ قلب الحوت الأزرق بحجم سيارة صغيرة، ولسانه يزن كوزن فيل.',
    'هل تعلم؟ الحبر المستخدم في الأقلام ليس أسوداً بالضرورة بل يتكون من مزيج معقد.',
    'هل تعلم؟ ضوء الشمس يستغرق حوالي 8 دقائق و20 ثانية ليصل إلى كوكب الأرض.',
    'هل تعلم؟ النحل يستطيع التعرف على وجوه البشر بدقة مذهلة.',
  ];

  static final List<String> _wisdoms = [
    '«من يلاحق عصفورين يفقدهما معاً، ركز على خيار واحد.»',
    '«رحلة الألف ميل تبدأ بخطوة، وكل سؤال سؤال خطوة نحو القمة.»',
    '«التجربة في معرفة الخطأ هي أول طريق الصواب.»',
    '«الناجحون لا ينجحون بالصدفة بل بالتخطيط والثقة.»',
    '«من زرع حصد، ومن فكر وصل إلى مبتغاه.»',
    '«الوقت كالسيف إن لم تقطعه قطعك، فاستغل وقت إجابتك.»',
    '«العلم نور، وجهل الإنسان عدو نفسه.»',
    '«الصبر مفتاح الفرج، والتأنى في التفكير سبيل النجاة.»',
    '«لا توجد نهايات سيئة، بل هي تجارب لتقوية العقل.»',
    '«الفرص تأتي لمن ينتظرها بذكاء ويعمل لها.»',
  ];

  static final List<String> _audienceCheers = [
    'واو، أنت أسطورة حقيقية!',
    'استمر، أنت في الطريق الصحيح نحو المليون!',
    'الجمهور يهتف باسمك، لا تخيب ظنهم!',
    'عاش الذكاء، إجابة في الصميم!',
    'ما شاء الله، إجابة عبقرية من لاعب محترف!',
    'الكل واقف على أطراف أصابعه بانتظار إبداعك!',
    'استمر يا بطل، القمة أصبحت قريبة جداً!',
    'تفجير إبداعي، أنت الملك اليوم!',
    'الجمهور يصفق لك بحرارة شديدة!',
    'خطوات واثقة وثابتة نحو المجد!',
  ];

  // قوائم مؤقتة للاستهلاك لمنع التكرار حتى نفاد العناصر ثم إعادة تعبئتها تلقائياً
  static List<String> _shuffledMasterList = [];

  // تهيئة وتعبئة القائمة وخلطها عشوائياً بدون تكرار
  static void _initMasterList() {
    if (_shuffledMasterList.isEmpty) {
      List<String> combined = [
        ..._famousQuotes,
        ..._generalInfo,
        ..._wisdoms,
        ..._audienceCheers,
      ];
      combined.shuffle(_random);
      _shuffledMasterList = combined;
    }
  }

  // جلب عبارة عشوائية فريدة تماماً تضمن عدم التكرار حتى تنفد المجموعة
  static String getRandomMessage() {
    _initMasterList();
    if (_shuffledMasterList.isEmpty) {
      _initMasterList();
    }
    return _shuffledMasterList.removeAt(0);
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

  // قائمة لتخزين الأسئلة الخاصة بالجلسة الحالية بدون تكرار
  List<Question> sessionQuestions = [];

  // سلم الجوائز الثابت والمتصاعد بدقة لـ 15 سؤالاً
  final List<int> prizeLadder = [
    100,
    200,
    300,
    500,
    1000,
    2000,
    4000,
    8000,
    16000,
    32000,
    64000,
    125000,
    250000,
    500000,
    1000000,
  ];

  // متغير لتخزين النص الاحترافي الحالي المتغير مع كل حدث
  String currentStudioMessage = '';

  // تحديد الحد الأقصى بـ 15 سؤالاً
  final int maxQuestions = 15;

  int timeLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeGameQuestions();
    currentStudioMessage = StudioContentManager.getRandomMessage();
    startTimer();
  }

  // دمج واختيار 15 سؤالاً عشوائياً بدون تكرار من قائمة الأسئلة الكلية
  void _initializeGameQuestions() {
    final random = math.Random();
    List<Question> shuffledPool = List.from(arabicTriviaQuestions);
    shuffledPool.shuffle(random);
    
    int count = math.min(maxQuestions, shuffledPool.length);
    sessionQuestions = shuffledPool.sublist(0, count);
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
        sessionQuestions[currentQuestionIndex].correctAnswerIndex;

    if (isCorrect) {
      int totalAllowedQuestions = sessionQuestions.length;
      bool isLastQuestion =
          currentQuestionIndex >= totalAllowedQuestions - 1;

      // استخدام سلم الجوائز التصاعدي المرتب حسب رقم السؤال الحالي
      final currentPrize = prizeLadder[currentQuestionIndex.clamp(0, prizeLadder.length - 1)];

      setState(() {
        earnedMoney = currentPrize;
        currentStudioMessage = StudioContentManager.getRandomMessage();
      });

      _showCorrectAnswerDialog(currentPrize, isLastQuestion);
    } else {
      setState(() {
        isGameOver = true;
        currentStudioMessage = StudioContentManager.getRandomMessage();
      });
    }
  }

  // نافذة منبثقة للجائزة عند الإجابة الصحيحة
  void _showCorrectAnswerDialog(int prize, bool isLastQuestion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.amber, width: 1.5),
          ),
          title: const Text(
            '🎉 إجابة صحيحة! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'لقد ربحت حتى الآن مبلغ:',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${formatMoney(prize)}',
                style: const TextStyle(color: Colors.amber, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (isLastQuestion) {
                    hasWon = true;
                    isGameOver = true;
                  } else {
                    currentQuestionIndex++;
                    startTimer();
                  }
                });
              },
              child: Text(
                isLastQuestion ? 'إنهاء اللعبة' : 'السؤال التالي',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void restartGame() {
    setState(() {
      currentQuestionIndex = 0;
      isGameOver = false;
      hasWon = false;
      earnedMoney = 0;
      _initializeGameQuestions();
      currentStudioMessage = StudioContentManager.getRandomMessage();
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
    int totalAllowedQuestions = sessionQuestions.length;
    final currentQ = sessionQuestions[currentQuestionIndex];
    final currentPrize = prizeLadder[currentQuestionIndex.clamp(0, prizeLadder.length - 1)];

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      appBar: AppBar(
        title: const Text('من سيربح المليار 🏆', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet, color: Colors.amber),
            onPressed: () => _showPrizeLadder(context),
            tooltip: 'شجرة الجوائز',
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: StudioBackgroundPainter(),
          ),
          SafeArea(
            child: isGameOver
                ? _buildGameOver()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'السؤال ${currentQuestionIndex + 1} / $totalAllowedQuestions',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildTimer(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              // صندوق السؤال بتصميمه الأصلي مع إطار ذهبي كامل من الجهات الأربع
                              SizedBox(
                                height: 105,
                                child: AnimatedSwitcher(
                                  duration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  child: _buildQuestion(
                                    currentQ.questionText,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // صندوق الجائزة الحالية بتصميمه الأصلي مع إطار ذهبي كامل من الجهات الأربع
                              SizedBox(
                                height: 50,
                                child: _buildCurrentPrizeBox(currentPrize),
                              ),
                              const SizedBox(height: 12),
                              // أزرار المساعدة
                              SizedBox(
                                height: 46,
                                child: Center(
                                  child: _buildHelpButtons(),
                                ),
                              ),
                              const SizedBox(height: 14),
                              // اختيارات الإجابة بتصميمه الأصلي مع إطار ذهبي كامل من الجهات الأربع
                              SizedBox(
                                height: 165,
                                child: GridView.builder(
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: currentQ.options.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2.3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return _buildAnswerButton(
                                      index,
                                      currentQ.options[index],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              // شريط تقدم النقاط الدائري المحدث ليدعم 15 مرحلة
                              SizedBox(
                                height: 35,
                                child: _buildGameProgressBar(),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 62,
                                child: _buildProfessionalStudioMessageCard(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalStudioMessageCard() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey<String>(currentStudioMessage),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF132B4D),
              Color(0xFF071326),
              Color(0xFF132B4D),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFFD77B).withOpacity(0.6),
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.18),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome,
              color: Color(0xFFFFD77B),
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                currentStudioMessage,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFFFEFA6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.campaign_outlined,
              color: Color(0xFFFFD77B),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // شريط تقدم نقاط اللعبة الأفقي بالأسفل ليدعم 15 سؤالاً
  Widget _buildGameProgressBar() {
    int totalStages = sessionQuestions.length;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF071326).withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 6,
            ),
          ],
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalStages,
          itemBuilder: (context, index) {
            bool isPassed = index < currentQuestionIndex;
            bool isCurrent = index == currentQuestionIndex;

            return Container(
              width: totalStages > 10 ? 16 : 22,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent
                    ? Colors.amber
                    : (isPassed ? Colors.amber[700] : const Color(0xFF132B4D)),
                border: Border.all(
                  color: isCurrent ? Colors.white : Colors.amber.withOpacity(0.5),
                  width: isCurrent ? 1.5 : 1,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.8),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isCurrent ? Colors.black : Colors.white70,
                    fontSize: totalStages > 10 ? 8 : 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // صندوق الجائزة الحالية مع الحفاظ على الشكل الأصلي وإطار ذهبي يحيط به بالكامل
  Widget _buildCurrentPrizeBox(int prize) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: CustomPaint(
          painter: QuestionBorderPainter(),
          child: ClipPath(
            clipper: QuestionShapeClipper(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF142B4D),
                    Color(0xFF061329),
                    Color(0xFF142B4D),
                  ],
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'جائزة السؤال الحالي: ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${formatMoney(prize)}',
                      style: const TextStyle(
                        color: Color(0xFFFFD77B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                          ),
                        ],
                      ),
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

  Widget _buildTimer() {
    final timerColor =
        timeLeft <= 10 ? Colors.redAccent : const Color(0xFFFF7043);

    return Container(
      width: 45,
      height: 45,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF071326),
        boxShadow: [
          BoxShadow(
            color: timerColor.withOpacity(0.35),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: timeLeft / 30,
              strokeWidth: 2.5,
              backgroundColor: const Color(0xFF462D32),
              valueColor: AlwaysStoppedAnimation<Color>(
                timerColor,
              ),
            ),
          ),
          Center(
            child: Text(
              '$timeLeft',
              style: TextStyle(
                color: timerColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // صندوق السؤال مع الحفاظ على الشكل الأصلي وإطار ذهبي يحيط به بالكامل
  Widget _buildQuestion(String question) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: CustomPaint(
          painter: QuestionBorderPainter(),
          child: ClipPath(
            clipper: QuestionShapeClipper(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF142B4D),
                    Color(0xFF061329),
                    Color(0xFF142B4D),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  question,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpButtons() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHelpButton(
            Icons.groups_outlined,
            'الجمهور',
          ),
          const SizedBox(width: 8),
          _buildHelpButton(
            Icons.phone_in_talk_outlined,
            'صديق',
          ),
          const SizedBox(width: 8),
          _buildHelpButton(
            Icons.swap_horiz,
            'تبديل',
          ),
          const SizedBox(width: 8),
          _buildHelpButton(
            Icons.percent,
            '50:50',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF15365D),
            Color(0xFF06152C),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF55CFFF),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlueAccent.withOpacity(0.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFFFFE6A1),
          ),
          const SizedBox(width: 5),
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

  // أزرار الإجابات مع الحفاظ على الشكل الأصلي وإطار ذهبي يحيط به بالكامل من الأربع جهات
  Widget _buildAnswerButton(int index, String answer) {
    const labels = ['A.', 'B.', 'C.', 'D.'];

    return InkWell(
      onTap: () => answerQuestion(index),
      child: CustomPaint(
        painter: AnswerBorderPainter(),
        child: ClipPath(
          clipper: AnswerShapeClipper(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF19365D),
                  Color(0xFF07162F),
                  Color(0xFF19365D),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  labels[index],
                  style: const TextStyle(
                    color: Color(0xFFFFD77B),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  answer,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOver() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF142B4D),
              Color(0xFF061329),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFFD77B),
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.2),
              blurRadius: 20,
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'مجموع أرباحك: \$${formatMoney(earnedMoney)}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: restartGame,
              child: const Text(
                'العب من جديد',
                style: TextStyle(
                  fontSize: 16,
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

  // نافذة شجرة الجوائز الكاملة لـ 15 سؤالاً مترتبة تصاعدياً
  void _showPrizeLadder(BuildContext context) {
    int totalAllowedQuestions = sessionQuestions.length;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF07162F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              const Text(
                'شجرة الجوائز والمبالغ',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.amber),
              Expanded(
                child: ListView.builder(
                  itemCount: totalAllowedQuestions,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final prize = prizeLadder[index.clamp(0, prizeLadder.length - 1)];
                    final isCurrent = index == currentQuestionIndex;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? Colors.amber.withOpacity(0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
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
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '\$${formatMoney(prize)}',
                            style: TextStyle(
                              color: isCurrent
                                  ? Colors.amber
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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

// كلاسات رسم الحدود الذهبية المتكاملة حول الأشكال الأصلية تماماً من جميع الجهات
class QuestionBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD77B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final path = Path();
    final double w = size.width;
    final double h = size.height;

    path.moveTo(w * 0.09, 0);
    path.lineTo(w * 0.91, 0);
    path.quadraticBezierTo(w * 0.96, 0, w * 0.98, h * 0.25);
    path.lineTo(w, h * 0.5);
    path.lineTo(w * 0.98, h * 0.75);
    path.quadraticBezierTo(w * 0.96, h, w * 0.91, h);
    path.lineTo(w * 0.09, h);
    path.quadraticBezierTo(w * 0.04, h, w * 0.02, h * 0.75);
    path.lineTo(0, h * 0.5);
    path.lineTo(w * 0.02, h * 0.25);
    path.quadraticBezierTo(w * 0.04, 0, w * 0.09, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class AnswerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD27A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final path = Path();
    final double w = size.width;
    final double h = size.height;

    path.moveTo(w * 0.06, 0);
    path.lineTo(w * 0.94, 0);
    path.lineTo(w, h * 0.5);
    path.lineTo(w * 0.94, h);
    path.lineTo(w * 0.06, h);
    path.lineTo(0, h * 0.5);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
