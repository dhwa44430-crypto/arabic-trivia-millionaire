class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final int prizeMoney;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.prizeMoney,
  });
}

List<Question> arabicTriviaQuestions = [
  Question(
    questionText: 'ما هي عاصمة العراق؟',
    options: ['بغداد', 'البصرة', 'الموصل', 'أربيل'],
    correctAnswerIndex: 0,
    prizeMoney: 100,
  ),
  Question(
    questionText: 'أي من الكواكب التالية هو الأقرب إلى الشمس؟',
    options: ['المريخ', 'عطارد', 'الزهرة', 'المشتري'],
    correctAnswerIndex: 1,
    prizeMoney: 200,
  ),
  Question(
    questionText: 'كم عدد سور القرآن الكريم؟',
    options: ['112', '113', '114', '115'],
    correctAnswerIndex: 2,
    prizeMoney: 500,
  ),
  Question(
    questionText: 'ما هو العنصر الكيميائي الذي يرمز له بالرمز (Au)؟',
    options: ['الفضة', 'الحديد', 'النحاس', 'الذهب'],
    correctAnswerIndex: 3,
    prizeMoney: 1000,
  ),
  Question(
    questionText: 'في أي سنة هجرية وقعت غزوة بدر الكبرى؟',
    options: ['السنة 1 هـ', 'السنة 2 هـ', 'السنة 3 هـ', 'السنة 4 هـ'],
    correctAnswerIndex: 1,
    prizeMoney: 5000,
  ),
  Question(
    questionText: 'من هو مخترع المصباح الكهربائي؟',
    options: ['ألبرت أينشتاين', 'توماس إديسون', 'نيكولا تسلا', 'ألكسندر غراهام بيل'],
    correctAnswerIndex: 1,
    prizeMoney: 10000,
  ),
  Question(
    questionText: 'ما هي أكبر بحر أو محطة مائية مغلقة في العالم؟',
    options: ['البحر الأحمر', 'بحر قزوين', 'البحر الميت', 'البحر الأسود'],
    correctAnswerIndex: 1,
    prizeMoney: 50000,
  ),
  Question(
    questionText: 'ما هي عاصمة أستراليا؟',
    options: ['سيدني', 'ملبورن', 'كانبيرا', 'بريزبان'],
    correctAnswerIndex: 2,
    prizeMoney: 100000,
  ),
  Question(
    questionText: 'من هو السباح العربي أو الشخصية التي لقبت بصقر قريش؟',
    options: ['عبد الرحمن الداخل', 'معاوية بن أبي سفيان', 'هارون الرشيد', 'عمر بن عبد العزيز'],
    correctAnswerIndex: 0,
    prizeMoney: 500000,
  ),
  Question(
    questionText: 'ما هو أثقل عنصر طبيعي موجود على الأرض؟',
    options: ['اليورانيوم', 'البلوتونيوم', 'الذهب', 'الأوسميوم'],
    correctAnswerIndex: 3,
    prizeMoney: 1000000,
  ),
];
