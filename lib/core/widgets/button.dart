import 'package:flutter/material.dart';
import 'package:weather_app/core/assets/colors.dart';
import 'package:weather_app/core/constants/local.dart';
import 'package:weather_app/core/utils/buttons.dart';
import 'package:weather_app/core/utils/text_styles.dart';
import 'package:weather_app/core/widgets/gradient_border.dart';

class AppButton extends StatefulWidget implements AppButtons {
  AppButton({
    super.key,
    this.title,
    this.titleStyle,
    this.iconLeft,
    this.titleWidget,
    this.width,
    this.height = 32,
    this.onPressed,
    this.borderRadius = 8,
    this.border,
    this.backroundColor = Colors.white,
    this.backroundColorPressed,
    this.padding,
    this.shadow,
    this.iconSize,
    this.spacing = 6,
    this.iconRight,
    this.titleAlignment = CrossAxisAlignment.center,
    this.constraints,
    this.disabled = false,
    this.maxLines = 1,
  });


  String? title;
  TextStyle? titleStyle;
  Widget? titleWidget;
  CrossAxisAlignment titleAlignment;
  int maxLines;

  double? spacing;
  double? iconSize;
  Widget? iconLeft;
  Widget? iconRight;

  double borderRadius;
  BoxBorder? border;

  double? width;
  double? height;
  Color backroundColor;
  Color? backroundColorPressed;
  EdgeInsets? padding;
  List<BoxShadow>? shadow;
  BoxConstraints? constraints;
  bool disabled;
  Function()? onPressed;

  @override
  State<StatefulWidget> createState() => _ApButton();

  @override
  Widget outline({AppColor? apColor}) {
    border = GradientBorder(borderGradient: LinearGradient(colors: (apColor ?? appColors).primaryGradient));
    titleStyle = AppTextStyles.body_highlight.copyWith(color: (apColor ?? appColors).onBackground_9);
    backroundColor = (apColor ?? appColors).background;
    backroundColorPressed = (apColor ?? appColors).primary_0;
    return this;
  }

  @override
  Widget primary({AppColor? apColor}) {
    titleStyle = AppTextStyles.body_highlight.copyWith(color: (apColor ?? appColors).onPrimaryDark);
    backroundColor = (apColor ?? appColors).primary_3;
    backroundColorPressed = (apColor ?? appColors).primary_6;
    return this;
  }

  @override
  Widget secondary({AppColor? apColor}) {
    titleStyle = AppTextStyles.body_highlight.copyWith(color: (apColor ?? appColors).onBackground_9);
    backroundColor = (apColor ?? appColors).onBackground_1;
    backroundColorPressed = (apColor ?? appColors).onBackground_3;
    return this;
  }

  @override
  Widget subtle({AppColor? apColor}) {
    titleStyle = AppTextStyles.body_highlight.copyWith(color: (apColor ?? appColors).onBackground_9);
    backroundColor = (apColor ?? appColors).background;
    backroundColorPressed = (apColor ?? appColors).onBackground_1;
    return this;
  }

}

class _ApButton extends State<AppButton> {
  bool _onTap = false;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.disabled,
      child: Opacity(
        opacity:widget.disabled ? 0.3:1,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
        onTap: widget.onPressed,
        onTapDown: widget.backroundColorPressed == null ? null : (v)=> setState(() {_onTap = true;}),
        onTapCancel: widget.backroundColorPressed == null ? null : ()=> setState(() {_onTap = false;}),
        onTapUp: widget.backroundColorPressed == null ? null : (v)=> setState(() {_onTap = false;}),
        child: Container(
            constraints: widget.constraints,
            width: widget.width,
            height: widget.height,
            decoration:BoxDecoration(
              color: _onTap ? widget.backroundColorPressed : widget.backroundColor,
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
              border: widget.border,
              boxShadow: widget.shadow,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: widget.titleAlignment,
              children: [
                Padding(
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                            child: widget.iconLeft!= null?Padding(
                              padding: EdgeInsets.only(right: (widget.title?.isNotEmpty ?? false) ? widget.spacing??0:0, top: 3),
                              child: SizedBox(width: widget.iconSize, height: widget.iconSize,child: widget.iconLeft,),
                            ) : const SizedBox(),
                            alignment: PlaceholderAlignment.middle
                        ),
                        TextSpan(text: widget.title ?? '',
                          style: widget.titleStyle ?? const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        WidgetSpan(
                            child: widget.titleWidget!= null?Padding(
                              padding: EdgeInsets.only(left: widget.spacing??0),
                              child: widget.titleWidget,
                            ) : const SizedBox(),
                            alignment: PlaceholderAlignment.middle
                        ),
                        WidgetSpan(
                            child: widget.iconRight!= null?Padding(
                              padding: EdgeInsets.only(left: widget.spacing??0),
                              child: SizedBox(width: widget.iconSize, height: widget.iconSize,child: widget.iconRight,),
                            ) : const SizedBox(),
                            alignment: PlaceholderAlignment.middle
                        ),
                      ],
                    ),
                    maxLines: widget.maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
        )
    );
  }
}