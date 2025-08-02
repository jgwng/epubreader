import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {super.key,
        this.onPressed,
        this.buttonText,
        this.buttonColor,
        this.height,
        this.horizontalPadding,
        this.style});

  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? buttonColor;
  final double? height;
  final double? horizontalPadding;
  final TextStyle? style;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin{
  late Animation<double> _scale;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _controller.forward();
      },
      onPointerUp: (_) {
        _controller.reverse().then((value){
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        });
      },
      onPointerCancel: (_) {
        _controller.reverse();
      },
      child: ScaleTransition(
          scale: _scale,
          child: Container(
            height: widget.height ?? 48,
            margin: EdgeInsetsDirectional.symmetric(horizontal: widget.horizontalPadding ?? 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.buttonColor ?? Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.buttonText ?? '',
              textAlign: TextAlign.center,
              style: widget.style ??
                  TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ),
    );
  }
}
