import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme.dart';

class OtpInputWidget extends StatefulWidget {
  const OtpInputWidget({
    super.key,
    required this.onChanged,
    this.onCompleted,
    this.autoFocus = true,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autoFocus;

  @override
  State<OtpInputWidget> createState() => OtpInputWidgetState();
}

class OtpInputWidgetState extends State<OtpInputWidget> {
  static const int _otpLength = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());

    if (widget.autoFocus && _focusNodes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNodes[0].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get currentOtp => _controllers.map((c) => c.text).join();

  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _notifyChange();
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
  }

  void _notifyChange() {
    final otp = currentOtp;
    widget.onChanged(otp);
    if (otp.length == _otpLength && widget.onCompleted != null) {
      widget.onCompleted!(otp);
    }
  }

  void _handlePaste(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return;

    for (int i = 0; i < _otpLength; i++) {
      if (i < digits.length) {
        _controllers[i].text = digits[i];
      } else {
        _controllers[i].text = '';
      }
    }

    final focusIndex = digits.length >= _otpLength ? _otpLength - 1 : digits.length;
    _focusNodes[focusIndex].requestFocus();
    _notifyChange();
  }

  void _onTextChanged(int index, String value) {
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_otpLength, (index) {
        final isFilled = _controllers[index].text.isNotEmpty;

        return SizedBox(
          width: 46,
          height: 46,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                if (_controllers[index].text.isEmpty && index > 0) {
                  _controllers[index - 1].clear();
                  _focusNodes[index - 1].requestFocus();
                  _notifyChange();
                }
              }
            },
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(23),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(23),
                  borderSide: BorderSide(
                    color: isFilled ? AppColors.softBlue : AppColors.inputBorder,
                    width: isFilled ? 1.8 : 1.3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(23),
                  borderSide: const BorderSide(
                    color: AppColors.softBlue,
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: isFilled
                    ? const Color(0xFFEBF3FC)
                    : Colors.white,
              ),
              onChanged: (val) => _onTextChanged(index, val),
            ),
          ),
        );
      }),
    );
  }
}
