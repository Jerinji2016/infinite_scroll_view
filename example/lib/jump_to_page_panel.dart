import 'package:example/primary_button.dart';
import 'package:flutter/material.dart';

typedef OnPageIndexSelected = void Function(int index, bool shouldAnimate);

const _values = [-1000, -500, -250, -100, -50, -10, -5, 0, 5, 10, 50, 100, 250, 500, 1000];

class JumpToPagePanel extends StatefulWidget {
  final OnPageIndexSelected onPageIndexSelected;

  const JumpToPagePanel({
    Key? key,
    required this.onPageIndexSelected,
  }) : super(key: key);

  @override
  State<JumpToPagePanel> createState() => _JumpToPagePanelState();
}

class _JumpToPagePanelState extends State<JumpToPagePanel> {
  bool _shouldAnimate = true;
  double _sliderValue = 0.5;

  void _onAnimateToggled(bool value) {
    setState(
      () => _shouldAnimate = value,
    );
  }

  void _onSliderEnd(double value) {
    int index = (_sliderValue * (_values.length - 1)).toInt();
    int page = _values[index];
    widget.onPageIndexSelected.call(page, _shouldAnimate);
  }

  void _onSliderValueChanged(double value) => setState(
        () => _sliderValue = value,
      );

  void _onBackToOriginTapped() {
    int index = (_values.length - 1) ~/ 2;
    debugPrint("_JumpToPagePanelState._onBackToOriginTapped: $index");

    widget.onPageIndexSelected.call(_values[index], _shouldAnimate);
    setState(
      () => _sliderValue = index / (_values.length - 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black.withOpacity(0.07),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Jump To Page",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    "Should animate:",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: _shouldAnimate,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: _onAnimateToggled,
                  ),
                ],
              ),
              Builder(builder: (context) {
                int index = (_sliderValue * (_values.length - 1)).toInt();

                return Slider(
                  label: "${_values[index]}",
                  value: _sliderValue,
                  divisions: _values.length - 1,
                  onChanged: _onSliderValueChanged,
                  onChangeEnd: _onSliderEnd,
                );
              }),
              Center(
                child: PrimaryButton(
                  text: "Back to Origin",
                  borderRadius: 8.0,
                  onTap: _onBackToOriginTapped,
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
