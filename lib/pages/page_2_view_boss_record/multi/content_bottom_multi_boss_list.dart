import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inside_maple/constants.dart';
import 'package:inside_maple/controllers/record_manage_multi.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../controllers/record_manage_single.dart';

class ContentBottomMultiBossList extends StatelessWidget {
  ContentBottomMultiBossList({super.key});

  final recordManageSingleController = Get.find<RecordManageSingleController>();
  final recordManageMultiController = Get.find<RecordManageMultiController>();

  @override
  Widget build(BuildContext context) {
    return switch (recordManageSingleController.recordLoadStatus.value) {
      LoadStatus.loading => Center(
          child: LoadingAnimationWidget.prograssiveDots(
            color: Colors.deepPurple,
            size: 24.0,
          ),
        ),
      LoadStatus.success => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    _selectPrefixButton(title: "스데", bossList: [Boss.lotus, Boss.damien]),
                    _selectPrefixButton(title: "루윌", bossList: [Boss.lucid, Boss.will]),
                    _selectPrefixButton(title: "진듄더슬", bossList: [Boss.jinhila, Boss.dunkel, Boss.dusk, Boss.gas]),
                    _selectPrefixButton(title: "검세칼", bossList: [Boss.blackmage, Boss.seren, Boss.kalos]),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: recordManageMultiController.recordedBossList.length,
                  itemBuilder: (context, index) {
                    Boss boss = recordManageMultiController.recordedBossList.keys.elementAt(index);
                    List<Difficulty> diffList = recordManageMultiController.recordedBossList[boss]!;
                    bool? checkedStatus = recordManageMultiController.checkStatus(boss);
                    return ExpansionTile(
                      shape: Border.all(color: Colors.transparent),
                      childrenPadding: const EdgeInsets.only(left: 55.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            boss.korName,
                          ),
                          Checkbox(
                            onChanged: (value) {
                              // loggerNoStack.d("Change boss check status of ${boss.korName}: $value");
                              bool setStatus = true;
                              if (value == true) {
                                setStatus = true;
                              } else {
                                setStatus = false;
                              }
                              recordManageMultiController.setSelectedBossListGrouped(boss, setStatus);
                            },
                            value: checkedStatus,
                            tristate: true,
                          )
                        ],
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      children: diffList.map((diff) {
                        return Obx(
                          () => ListTile(
                            title: Text(diff.korName),
                            trailing: Checkbox(
                              tristate: false,
                              onChanged: (value) {
                                recordManageMultiController.setSelectedBossList(boss, diff, value!);
                              },
                              value: recordManageMultiController.selectedBossList.containsKey(boss)
                                  ? recordManageMultiController.selectedBossList[boss]!.contains(diff)
                                  : false,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      LoadStatus.failed => const Center(
          child: Text(
            "데이터 로드에 실패하였습니다.",
          ),
        ),
      LoadStatus.empty => const Center(
          child: Text("아직 데이터가 로드되지 않았습니다."),
        ),
    };
  }

  Widget _selectPrefixButton({
    required String title,
    required List<Boss> bossList,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 20,
        maxHeight: 20,
        maxWidth: 60,
        minWidth: 0,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          recordManageMultiController.setParamsByPressingPrefix(bossList);
        },
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
