import 'dart:io';

import '../entities/reaction_data_entity.dart';
import 'parse_double.dart';
import 'safe_string.dart';

/// Парсит файлы с данными о реакциях (rct)
void parseReactionFile(File file, Map<String, ReactionDataEntry> reactionData, bool isRct1, int startLine) {
  if (!file.existsSync()) {
    print('Файл не найден: ${file.path}');
    return;
  }
  final lines = file.readAsLinesSync();

  for (int i = startLine; i < lines.length - 1; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) continue;
    try {
      // Формат rct отличается от mass.mas20 в идентификации нуклидов
      // A(cols 2-4), Z(cols 10-12)
      final a = int.parse(line.safeSubstring(1, 4).trim());
      final z = int.parse(line.safeSubstring(9, 12).trim());
      final key = '$a-$z';

      final entry = reactionData.putIfAbsent(key, () => ReactionDataEntry(z: z, a: a));

      final dataStart = 13;
      if (isRct1) {
        // rct1.mas20.txt: S(2n), S(2p), Q(a), Q(2B-), Q(ep), Q(B-n)
        // Формат: a1,i3,1x,a3,i3,1x,6(f12.4,f10.4)
        // Позиции: 13-24 (S2n), 25-34 (unc), 35-46 (S2p), 47-56 (unc),
        //          57-68 (Qa), 69-78 (unc), 79-90 (Q2b), 91-100 (unc),
        //          101-112 (Qep), 113-122 (unc), 123-134 (Qbn), 135-144 (unc)
        entry.s2n = parseDouble(line.safeSubstring(dataStart, dataStart + 12));
        entry.s2nUncertainty = parseDouble(line.safeSubstring(dataStart + 12, dataStart + 22));
        entry.s2p = parseDouble(line.safeSubstring(dataStart + 22, dataStart + 34));
        entry.s2pUncertainty = parseDouble(line.safeSubstring(dataStart + 34, dataStart + 44));
        entry.qa = parseDouble(line.safeSubstring(dataStart + 44, dataStart + 56));
        entry.qaUncertainty = parseDouble(line.safeSubstring(dataStart + 56, dataStart + 66));
        entry.q2b = parseDouble(line.safeSubstring(dataStart + 66, dataStart + 78));
        entry.q2bUncertainty = parseDouble(line.safeSubstring(dataStart + 78, dataStart + 88));
        entry.qep = parseDouble(line.safeSubstring(dataStart + 88, dataStart + 100));
        entry.qepUncertainty = parseDouble(line.safeSubstring(dataStart + 100, dataStart + 110));
        entry.qbn = parseDouble(line.safeSubstring(dataStart + 110, dataStart + 122));
        entry.qbnUncertainty = parseDouble(line.safeSubstring(dataStart + 122, dataStart + 132));
      } else {
        // rct2_1.mas20.txt: S(n), S(p), Q(4B-), Q(d,a), Q(p,a), Q(n,a)
        // Формат: a1,i3,1x,a3,i3,1x,6(f12.4,f10.4)
        // Позиции: 13-24 (Sn), 25-34 (unc), 35-46 (Sp), 47-56 (unc),
        //          57-68 (Q4b), 69-78 (unc), 79-90 (Qda), 91-100 (unc),
        //          101-112 (Qpa), 113-122 (unc), 123-134 (Qna), 135-144 (unc)
        entry.sn = parseDouble(line.safeSubstring(dataStart, dataStart + 12));
        entry.snUncertainty = parseDouble(line.safeSubstring(dataStart + 12, dataStart + 22));
        entry.sp = parseDouble(line.safeSubstring(dataStart + 22, dataStart + 34));
        entry.spUncertainty = parseDouble(line.safeSubstring(dataStart + 34, dataStart + 44));
        entry.q4b = parseDouble(line.safeSubstring(dataStart + 44, dataStart + 56));
        entry.q4bUncertainty = parseDouble(line.safeSubstring(dataStart + 56, dataStart + 66));
        entry.qda = parseDouble(line.safeSubstring(dataStart + 66, dataStart + 78));
        entry.qdaUncertainty = parseDouble(line.safeSubstring(dataStart + 78, dataStart + 88));
        entry.qpa = parseDouble(line.safeSubstring(dataStart + 88, dataStart + 100));
        entry.qpaUncertainty = parseDouble(line.safeSubstring(dataStart + 100, dataStart + 110));
        entry.qna = parseDouble(line.safeSubstring(dataStart + 110, dataStart + 122));
        entry.qnaUncertainty = parseDouble(line.safeSubstring(dataStart + 122, dataStart + 132));
      }
      reactionData[key] = entry;
    } catch (e, s) {
      print('Ошибка парсинга строки реакции: "$line"\n$e\n$s');
    }
  }
}
