import 'kingdom.dart';
import 'quests/quest.dart';

class QuestGain {
  final int row;
  final int col;
  final int points;

  const QuestGain(this.row, this.col, this.points);
}

extension KingdomQuestGains on Kingdom {
  List<QuestGain> computeQuestGains(Iterable<QuestType> selectedQuests) {
    final n = kingdomSize.size;
    final cells = <int, int>{};

    for (final type in selectedQuests) {
      final quest = createQuest(type);
      final reward = quest.reward;
      for (final place in quest.getPlaces(this)) {
        final key = place.$1 * n + place.$2;
        cells[key] = (cells[key] ?? 0) + reward;
      }
    }

    return [
      for (final entry in cells.entries)
        QuestGain(entry.key ~/ n, entry.key % n, entry.value),
    ];
  }
}