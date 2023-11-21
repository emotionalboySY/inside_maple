import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
  cygnus("00011", "Cygnus", "시그너스"),
  lotus("01010", "Lotus", "스우"),
  damien("01010", "Damien", "데미안"),
  gas("00110", "Guardian Angel Slime", "가디언 엔젤 슬라임"),
  lucid("01011", "Lucid", "루시드"),
  will("01011", "Will", "윌"),
  dusk("00110", "Dusk", "더스크"),
  jinhila("01010", "Jinhila", "진 힐라"),
  dunkel("01010", "Dunkel", "듄켈"),
  blackmage("11000", "Black Mage", "검은 마법사"),
  seren("11010", "Seren", "선택받은 세렌"),
  kalos("11011", "Kalos", "감시자 칼로스"),
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

  static List<Boss> getKorListAfterCygnus() {
    int cygnusIndex = Boss.values.indexWhere((boss) => boss.name == "Cygnus");

    return Boss.values.where((boss) => Boss.values.indexOf(boss) > cygnusIndex).toList();
  }
}

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

List<Item> itemCanDuplicated = [
  Item.item1, Item.item2, Item.item3, Item.item4, Item.item5, Item.item6, Item.item7, Item.item8, Item.item9, Item.item10, Item.item11, Item.item12
];

enum Item {
  item1("추가 경험치 50% 쿠폰", "assets/images/drop_item/extra_experience_50%_coupon.png"),
  item2("반짝이는 파란 별 물약", "assets/images/drop_item/shining_blue_star_portion.png"),
  item3("반짝이는 빨간 별 물약", "assets/images/drop_item/shining_red_star_portion.png"),
  item4("소형 경험 축적의 비약", "assets/images/drop_item/small_experience_portion.png"),
  item5("대형 보스 명예의 훈장", "assets/images/drop_item/big_boss_medal_of_honor.png"),
  item6("꺼지지 않는 불꽃", "assets/images/drop_item/flame_indelible.png"),
  item7("영원히 꺼지지 않는 불꽃", "assets/images/drop_item/flame_eternal.png"),
  item8("영원히 꺼지지 않는 검은 불꽃", "assets/images/drop_item/flame_black.png"),
  item9("놀라운 긍정의 혼돈 주문서 60%", "assets/images/drop_item/incredible_positive_chaos_spell.png"),
  item10("강력한 환생의 불꽃", "assets/images/drop_item/reincarnation_powerful.png"),
  item11("영원한 환생의 불꽃", "assets/images/drop_item/reincarnation_eternal.png"),
  item12("검은 환생의 불꽃", "assets/images/drop_item/reincarnation_black.png"),
  item13("악세서리 스크롤 교환권", "assets/images/drop_item/accessory_scroll.png"),
  item14("프리미엄 악세서리 스크롤 교환권", "assets/images/drop_item/accessory_scroll_premium.png"),
  item15("프리미엄 펫장비 스크롤 교환권", "assets/images/drop_item/pet_equip_scroll_premium.png"),
  item16("매지컬 주문서 교환권", "assets/images/drop_item/magical_weapon_scroll.png"),
  item17("태초의 정수", "assets/images/drop_item/essence_of_beginning.png"),
  item18("앱솔랩스 방어구 상자", "assets/images/drop_item/absorblapse_armor_box.png"),
  item19("앱솔랩스 무기 상자", "assets/images/drop_item/absorblapse_weapon_box.png"),
  item20("아케인셰이드 방어구 상자", "assets/images/drop_item/arcane_armor_box.png"),
  item21("아케인셰이드 무기 상자", "assets/images/drop_item/arcane_weapon_box.png"),
  item22("녹옥의 보스 반지 상자", "assets/images/drop_item/green_ring_box.png"),
  item23("홍옥의 보스 반지 상자", "assets/images/drop_item/red_ring_box.png"),
  item24("흑옥의 보스 반지 상자", "assets/images/drop_item/black_ring_box.png"),
  item25("백옥의 보스 반지 상자", "assets/images/drop_item/white_ring_box.png"),
  item26("스우로이드", "assets/images/drop_item/lotusroid.png"),
  item27("데미안로이드", "assets/images/drop_item/damienroid.png"),
  item28("루시드로이드", "assets/images/drop_item/lucidroid.png"),
  item29("루인 포스실드", "assets/images/drop_item/ruined_force_shield"),
  item30("손상된 블랙 하트", "assets/images/drop_item/damaged_black_heart.png"),
  item31("루즈 컨트롤 머신 마크", "assets/images/drop_item/lose_control_machine_mark.png"),
  item32("마력이 깃든 안대", "assets/images/drop_item/magical_eye_patch.png"),
  item33("트와일라이트 마크", "assets/images/drop_item/twilight_mark.png"),
  item34("에스텔라 이어링", "assets/images/drop_item/estella_ear_ring.png"),
  item35("데이브레이크 펜던트", "assets/images/drop_item/daybreak_pendant.png"),
  item36("몽환의 벨트", "assets/images/drop_item/dreamy_belt.png"),
  item37("저주받은 마도서 교환권", "assets/images/drop_item/cursed_magic_book_box.png"),
  item38("고통의 근원", "assets/images/drop_item/source_of_pain.png"),
  item39("커맨더 포스 이어링", "assets/images/drop_item/commander_force_ear_ring.png"),
  item40("거대한 공포", "assets/images/drop_item/massive_fear.png"),
  item41("가디언 엔젤 링", "assets/images/drop_item/guardian_angel_ring.png"),
  item42("창세의 뱃지", "assets/images/drop_item/badge_of_world_creation.png"),
  item43("미트라의 분노 교환권", "assets/images/drop_item/anger_of_mitra_box.png"),
  item44("악몽의 조각", "assets/images/drop_item/crack_of_nightmare.png"),
  item45("그라비티 모듈", "assets/images/drop_item/gravity_module.png"),
  item46("파멸의 징표", "assets/images/drop_item/sign_of_destruction.png"),
  item47("충정의 투구", "assets/images/drop_item/pitch_of_royalty.png"),
  item48("생명의 연마석", "assets/images/drop_item/abrasice_stone_of_life.png");

  const Item(this.korLabel, this.imagePath);
  final String korLabel;
  final String imagePath;

  @override
  String toString() {
    return korLabel;
  }
}

Map<String, Map<String, List<int>>> dropData = {
  "lotus": {
    "normal": [0 ,1, 2, 3, 4, 9, 21],
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 22, 25, 29, 30],
  },
  "damien": {
    "normal": [0, 1, 2, 3, 4, 9, 21, 28],
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 22, 26, 28, 31],
  },
  "gas": {
    "normal": [0, 1, 2, 3, 4, 9, 10, 21, 40],
    "chaos": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 23, 40],
  },
  "lucid": {
    "easy": [0, 1, 2, 3, 4, 9, 10, 21],
    "normal": [0, 1, 2, 3, 4, 9, 10, 21, 32],
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 19, 20, 22, 27, 32, 35],
  },
  "will": {
    "easy": [0, 1, 2, 3, 4, 9, 10, 21],
    "normal": [0, 1, 2, 3, 4, 9, 10, 21, 32],
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 19, 20, 22, 32, 36],
  },
  "dusk": {
    "normal": [0, 1, 2, 3, 4, 9, 10, 11, 21, 33],
    "chaos": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 19, 20, 23, 33, 39],
  },
  "jinhila": {
    "normal": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 19, 20, 22, 34],
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 19, 20, 23, 34, 37],
  },
  "dunkel": {
    "normal": [0, 1, 2, 3, 4, 9, 10, 11, 21, 33],
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 19, 20, 23, 33, 38],
  },
  "blackmage": {
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 19, 20, 24, 41],
    "extreme": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 19, 20, 24, 41, 43],
  },
  "seren": {
    "normal": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 23, 34],
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 24, 34, 42],
    "extreme": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 24, 34, 42, 44],
  },
  "kalos": {
    "easy": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 47],
    "normal": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 24, 47],
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 47],
    "extreme": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 45, 47],
  },
  "karing": {
    "easy": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 47],
    "normal": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 24, 47],
    "hard": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 47],
    "extreme": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 46, 47],
  },
};

enum LoadStatus { empty, loading, success, failed }

Widget separator({
  required Axis axis,
}) {
  return Container(
    width: (axis == Axis.vertical) ? 1 : double.infinity,
    height: (axis == Axis.horizontal) ? 1 : double.infinity,
    decoration: const BoxDecoration(
      color: Colors.black,
    ),
  );
}

class DifficultyAdapter extends TypeAdapter<Difficulty> {

  @override
  final typeId = 0;

  @override
  Difficulty read(BinaryReader reader) {
    var index = reader.readInt();
    return Difficulty.values[index];
  }

  @override
  void write(BinaryWriter writer, Difficulty obj) {
    writer.writeInt(obj.index);
  }

}

class BossAdapter extends TypeAdapter<Boss> {

  @override
  final typeId = 1;

  @override
  Boss read(BinaryReader reader) {
    var index = reader.readInt();
    return Boss.values[index];
  }

  @override
  void write(BinaryWriter writer, Boss obj) {
    writer.writeInt(obj.index);
  }

}

class ItemAdapter extends TypeAdapter<Item> {

  @override
  final typeId = 2;

  @override
  Item read(BinaryReader reader) {
    var index = reader.readInt();
    return Item.values[index];
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer.writeInt(obj.index);
  }

}