enum Difficulty {
  easy("easy", "이지"),
  normal("normal", "노멀"),
  chaos("chaos", "카오스"),
  hard("hard", "하드"),
  extreme("extreme", "익스트림");

  const Difficulty(this.engName, this.korName);

  final String engName;
  final String korName;

  factory Difficulty.getByKorName(String name) {
    return Difficulty.values.firstWhere((element) => element.korName == name);
  }
}

enum LoadStatus { empty, loading, success, failed }