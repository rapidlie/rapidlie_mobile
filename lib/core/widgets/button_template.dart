import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum ButtonType { elevated, outlined }

class ButtonTemplate extends StatefulWidget {
  final String buttonName;
  final Function() buttonAction;
  final bool loading;
  final ButtonType buttonType;

  const ButtonTemplate({
    required this.buttonName,
    required this.buttonAction,
    this.loading = false,
    this.buttonType = ButtonType.elevated,
  });

  @override
  _ButtonTemplateState createState() => _ButtonTemplateState();
}

class _ButtonTemplateState extends State<ButtonTemplate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.loading) {
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (!widget.loading) {
          _controller.reverse();
        }
      },
      onTapCancel: () {
        if (!widget.loading) {
          _controller.reverse();
        }
      },
      onTap: widget.loading ? null : widget.buttonAction,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 45.h,
          child: _buildButton(),
        ),
      ),
    );
  }

  Widget _buildButton() {
    final Widget buttonWidget;

    if (widget.buttonType == ButtonType.outlined) {
      buttonWidget = OutlinedButton(
        onPressed: widget.buttonAction,
        child: _buildChild(context),
      );
    } else {
      buttonWidget = ElevatedButton(
        onPressed: widget.buttonAction,
        child: _buildChild(context),
      );
    }

    return buttonWidget;
  }

  Widget _buildChild(BuildContext context) {
    return widget.loading
        ? SizedBox(
            height: 16.h,
            width: 16.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.buttonType == ButtonType.outlined
                  ? Theme.of(context)
                          .outlinedButtonTheme
                          .style
                          ?.foregroundColor
                          ?.resolve({WidgetState.pressed}) ??
                      Colors.black
                  : Theme.of(context)
                          .elevatedButtonTheme
                          .style
                          ?.foregroundColor
                          ?.resolve({WidgetState.pressed}) ??
                      Colors.white,
            ),
          )
        : Text(
            widget.buttonName.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: widget.buttonType == ButtonType.outlined
                  ? Theme.of(context)
                          .outlinedButtonTheme
                          .style
                          ?.foregroundColor
                          ?.resolve({WidgetState.pressed}) ??
                      Colors.black
                  : Theme.of(context)
                          .elevatedButtonTheme
                          .style
                          ?.foregroundColor
                          ?.resolve({WidgetState.pressed}) ??
                      Colors.white,
            ),
          );
  }
}
