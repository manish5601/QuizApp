class QuizQuestion {
  final String question;
  final List<String> options;
  final String answer;
  QuizQuestion(
      {required this.question, required this.options, required this.answer});
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<String> options = List<String>.from(json['incorrect_answers']);
    options.add(json['correct_answer']);
    options.shuffle();
    return QuizQuestion(
      question: json['question'],
      options: options,
      answer: json['correct_answer'],
    );
  }
}
