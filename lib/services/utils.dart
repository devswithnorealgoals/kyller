import 'package:random_words/random_words.dart';

randomMissions(int i) {
  return generateWordPairs().take(i).map((word) => word.toString()).toList();
}