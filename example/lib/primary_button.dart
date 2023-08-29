import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color, suffixIconColor, prefixIconColor;
  final String text;
  final IconData? suffixIcon, prefixIcon;
  final TextStyle textStyle;
  final double? borderRadius;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.prefixIcon,
    this.prefixIconColor = Colors.white,
    this.suffixIcon,
    this.suffixIconColor = Colors.white,
    this.borderRadius,
    this.color = Colors.orange,
    TextStyle? textStyle,
  })  : textStyle = textStyle ??
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                Icon(
                  prefixIcon,
                  color: prefixIconColor,
                ),
                const SizedBox(width: 4.0),
              ],
              Text(
                text,
                style: textStyle,
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: 4.0),
                Icon(
                  suffixIcon,
                  color: suffixIconColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
