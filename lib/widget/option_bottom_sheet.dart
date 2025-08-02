import 'package:epubreader/enum/enums.dart';
import 'package:epubreader/model/novel_option.dart';
import 'package:epubreader/resources/size.dart';
import 'package:epubreader/viewModel/novel_view_controller.dart';
import 'package:epubreader/widget/custom_button.dart';
import 'package:epubreader/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<NovelViewerOption?> showNovelOptionSettingBottomSheet({NovelViewerOption? initOption}) async {
  var result = await showModalBottomSheet(
    context: navigatorKey.currentContext!,
    barrierColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return NovelOptionSettingBottomSheet(option: initOption);
    },
  );
  return result;
}

class NovelOptionSettingBottomSheet extends StatefulWidget {
  const NovelOptionSettingBottomSheet({super.key, this.option});

  final NovelViewerOption? option;

  @override
  State<NovelOptionSettingBottomSheet> createState() => _NovelOptionSettingBottomSheetState();
}

class _NovelOptionSettingBottomSheetState extends State<NovelOptionSettingBottomSheet> {
  Rx<NovelViewerOption> novelOption = NovelViewerOption().obs;
  final backgroundColors = [
    Colors.white,
    Color.fromRGBO(231, 231, 231, 1.0),
    Color.fromRGBO(31, 31, 31, 1.0),
    Colors.black,
    Color.fromRGBO(255, 243, 215, 1.0),
    Color.fromRGBO(32, 55, 52, 1.0),
  ];
  final fontColors = [
    Colors.black,
    Color.fromRGBO(48, 54, 64, 1.0),
    Color.fromRGBO(176, 176, 176, 1.0),
    Color.fromRGBO(231, 235, 237, 1.0),
    Color.fromRGBO(95, 69, 48, 1.0),
    Color.fromRGBO(204, 210, 209, 1.0),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.option != null) {
      novelOption.value = widget.option!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(vertical: 12.s),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
          border: Border.all(color: Theme.of(context).colorScheme.outline)),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.s),
            Container(
              width: 40.s,
              height: 4.s,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20.s),
              child: Text(
                '옵션 설정',
                style: TextStyle(
                    fontSize: 20.fs,
                    color: Theme.of(context).colorScheme.surfaceDim),
              ),
            ),
            SizedBox(height: 12.s),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20.s),
                child: Divider(
                  height: 2,
                  color: Theme.of(context).colorScheme.outline,
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle("테마"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(6, (index) => _themeCircle(index)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 12.s),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle("글꼴"),
                  Row(
                    children: [
                      ...List.generate(
                          FontFamily.values.length,
                              (index){
                            return _buildOption<FontFamily?>(
                              index: index,
                              selectedValue: novelOption.value.fontFamily,
                              values: FontFamily.values,
                              title: FontFamily.values[index].title,
                              onTap: (){
                                novelOption.update((val){
                                  val?.fontFamily = FontFamily.values[index];
                                });
                              }
                            );
                      })
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 12.s),
            _settingItem("글자 크기", novelOption.value.fontSize),
            _settingItem("줄 간격", novelOption.value.lineHeight),
            _settingItem("좌우 여백", novelOption.value.horizontalPadding),
            _settingItem("상하 여백", novelOption.value.verticalPadding),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 16.s),
                child: Divider(
                  height: 2,
                  color: Theme.of(context).colorScheme.outline,
                )),
            bottomButtons(),
            SizedBox(
              height: MediaQuery.of(context).viewPadding.bottom.s,
            )
          ],
        );
      }),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16.fs,
            color: Theme.of(context).colorScheme.surfaceDim,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOption<T>({
    required int index,
    required T selectedValue,
    required List<T> values,
    required String title,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedValue == values[index];

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.s),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.s),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.fs,
              color: isSelected
                  ? Theme.of(context).colorScheme.surfaceDim
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _themeCircle(int index) {
    return InkWell(
      onTap: () {
        Color fontColor = fontColors[index];
        Color backgroundColor = backgroundColors[index];
        if(Get.isRegistered<NovelViewerController>()){
          final controller = Get.find<NovelViewerController>();
          controller.changeFontBGColor(fontColor, backgroundColor);
        }
        novelOption.update((val) {
          val?.fontColor = fontColor;
          val?.backgroundColor = backgroundColor;
        });
      },
      child: Stack(
        children: [
          Container(
            width: 32.s,
            height: 32.s,
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              right: (index < 5) ? 8.s : 0,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColors[index],
            ),
            child: Text(
              '가',
              style: TextStyle(
                  fontSize: 16.fs, color: fontColors[index], letterSpacing: -0.53),
            ),
          ),
          if(novelOption.value.fontColor == fontColors[index])
            Container(
              width: 32.s,
              height: 32.s,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                right: (index < 5) ? 8.s : 0,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColors[index],
              ),
              child: Icon(
                Icons.check,
                size: 20,
                  color: fontColors[index]),
            )
        ],
      ),
    );
  }

  Widget _settingItem(String title, int? currentValue) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.s, horizontal: 16.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16.fs,
                  color: Theme.of(context).colorScheme.surfaceDim)),
          Row(
            children: [
              _roundButton(isPlus: false, type: title),
              Container(
                width: 80.s,
                alignment: Alignment.center,
                child: Text('$currentValue',
                    style: TextStyle(
                        fontSize: 16.fs,
                        color: Theme.of(context).colorScheme.surfaceDim)),
              ),
              _roundButton(isPlus: true, type: title),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundButton({required bool isPlus, required String type}) {
    return InkWell(
      onTap: () {
        switch (type) {
          case '글자 크기':
            novelOption.update((val) {
              val?.fontSize = adjust(val.fontSize, isPlus);
            });
            break;
          case '줄 간격':
            novelOption.update((val) {
              val?.lineHeight = adjust(val.lineHeight, isPlus);
            });
            break;
          case '좌우 여백':
            novelOption.update((val) {
              val?.horizontalPadding = adjust(val.horizontalPadding, isPlus);
            });
            break;
          case '상하 여백':
            novelOption.update((val) {
              val?.verticalPadding = adjust(val.verticalPadding, isPlus);
            });
            break;
        }
      },
      child: Container(
        width: 28.s,
        height: 28.s,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).colorScheme.outline)),
        child: Icon(isPlus == true ? Icons.add : Icons.remove,
            size: 16.s, color: Theme.of(context).colorScheme.surfaceDim),
      ),
    );
  }

  Widget bottomButtons() {
    return Container(
      height: 56.s,
      padding: EdgeInsets.symmetric(horizontal: 16.s),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              onPressed: () {
                novelOption.value = NovelViewerOption();
                novelOption.refresh();
              },
              height: 52.s,
              buttonText: '초기화',
              horizontalPadding: 0,
              buttonColor: Theme.of(context).primaryColorDark.withAlpha(50),
              style: TextStyle(color: Colors.black, fontSize: 20.fs),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: CustomButton(
              onPressed: () {
                Navigator.pop(context, novelOption.value);
              },
              buttonText: '설정',
              buttonColor: Theme.of(context).primaryColorDark,
              height: 52.s,
              horizontalPadding: 0,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 20.fs,
              ),
            ),
          )
        ],
      ),
    );
  }

  int adjust(int? value, bool isPlus) {
    if (value == null) {
      return 0;
    }
    if (isPlus == true) {
      return value + 1;
    } else {
      return (value > 0 ? value - 1 : value);
    }
  }
}

