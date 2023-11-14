import 'constants.dart';

class SelectedItem {

  SelectedItem({
    required Item itemData,
    required int count,
}) : _itemData = itemData, _count = count;

  final Item _itemData;
  int _count;

  void increaseCount() {
    _count++;
  }

  void decreaseCount() {
    if(_count > 1) {
      _count--;
    }
  }

  Item get itemData => _itemData;
  int get count => _count;

  @override
  String toString() {
    return "${_itemData.korLabel} : $_count";
  }
}