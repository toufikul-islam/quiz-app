import 'package:hive/hive.dart';
import '../models/question.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String _boxName = 'questions';

  DatabaseHelper._init();

  Future<Box> get _box async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  Future<void> createQuestion(Question question) async {
    try {
      final box = await _box;
      await box.put(question.id, question.toMap());
    } catch (e) {
      throw Exception('Failed to add question: $e');
    }
  }

  Future<List<Question>> getAllQuestions() async {
    try {
      final box = await _box;
      return box.values
          .map((item) => Question.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  Future<Question?> getQuestion(String id) async {
    try {
      final box = await _box;
      final data = box.get(id);
      if (data != null) {
        return Question.fromMap(Map<String, dynamic>.from(data as Map));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get question: $e');
    }
  }

  Future<void> updateQuestion(Question question) async {
    try {
      final box = await _box;
      await box.put(question.id, question.toMap());
    } catch (e) {
      throw Exception('Failed to update question: $e');
    }
  }

  Future<void> deleteQuestion(String id) async {
    try {
      final box = await _box;
      await box.delete(id);
    } catch (e) {
      throw Exception('Failed to delete question: $e');
    }
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box(_boxName).close();
    }
  }
}
