enum Boss {
  zakkum("00100", "Zakkum", "자쿰"),
  magnus("01011", "Magnus", "매그너스"),
  hila("01000", "Hila", "힐라"),
  papulatus("00100", "Papulatus", "파풀라투스"),
  pierre("00100", "Pierre", "피에르"),
  vanvon("00100", "Vanvon", "반반"),
  bloodyqueen("00100", "Bloody Queen", "블러디퀸"),
  vellum("00100", "Vellum", "벨룸"),
  pinkbean("00100", "Pinkbean", "핑크빈"),
  cygnus("00011", "Lotus", "시그너스"),
  lotus("01010", "Zakkum", "스우"),
  damien("01010", "Damien", "데미안"),
  gas("00110", "Guardian Angel Slime", "가디언 엔젤 슬라임"),
  lucid("01011", "Lucid", "루시드"),
  will("01011", "Will", "윌"),
  dusk("00110", "Dusk", "더스크"),
  jinhila("01010", "Jinhila", "진 힐라"),
  dunkel("01010", "Dunkel", "듄켈"),
  blackmage("11000", "Black Mage", "검은 마법사"),
  seren("11011", "Seren", "선택받은 세렌"),
  calos("11011", "Calos", "감시자 칼로스"),
  karing("11011", "Karing", "카링");

  const Boss(this.diffIndex, this.name, this.korName);
  final String diffIndex;
  final String name;
  final String korName;

  factory Boss.getByName(String name) {
    return Boss.values.firstWhere((element) => element.name == name);
  }

  static List<Boss> getKorList() {
    return Boss.values.map((element) => element).toList();
  }
}