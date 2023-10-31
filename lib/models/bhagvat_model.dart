class Bhagwatphrasemodel {
  final chapter_no;
  final verse_no;
  final language;
  final chapter_name;
  final verse;
  final transliteration;
  final synonyms;
  final audio_link;
  final translation;
  final purport;

  Bhagwatphrasemodel(
      {required this.chapter_no,
      required this.verse_no,
      required this.language,
      required this.chapter_name,
      required this.verse,
      required this.transliteration,
      required this.synonyms,
      required this.audio_link,
      required this.translation,
      required this.purport});

  factory Bhagwatphrasemodel.fromJson(Map<String, dynamic> json) {
    return Bhagwatphrasemodel(
        chapter_no: json['chapter_no'],
        verse_no: json['verse_no'],
        language: json['language'],
        chapter_name: json['chapter_name'],
        verse: json['verse'],
        transliteration: json['transliteration'] ?? '',
        synonyms: json['synonyms'],
        audio_link: json['audio_link'],
        translation: json['translation'],
        purport: json['purport']);
  }
}
