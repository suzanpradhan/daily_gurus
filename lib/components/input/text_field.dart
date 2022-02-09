import 'package:dailygurus/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String imagePath;
  final Function validatorFunction;
  final TextInputType keyboardType;
  final Function onChanged;
  final bool isPasswordField;
  final TextEditingController textEditingController;
  final int maxlines;
  final int minlines;

  CustomTextField({
    @required this.hintText,
    @required this.imagePath,
    this.maxlines,
    this.minlines,
    this.validatorFunction,
    this.keyboardType,
    this.onChanged,
    this.isPasswordField,
    this.textEditingController,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  void _passwordVisibilityToggle(bool val) {
    setState(() {
      _obscureText = !val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.imagePath != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Image.asset(
                        widget.imagePath,
                        height: 28.0,
                        width: 44.0,
                      ),
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: TextFormField(
                    maxLines: widget.maxlines ?? 1,
                    minLines: widget.minlines ?? 1,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      isDense: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorStyle: TextStyle(
                        fontFamily: 'Proxima Nova',
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Proxima Nova',
                        color: kColorGrey,
                        fontSize: 16.0,
                      ),
                    ),
                    onChanged: widget.onChanged,
                    obscureText:
                        widget.isPasswordField == true ? _obscureText : false,
                    style: TextStyle(
                      fontFamily: 'Proxima Nova',
                      color: kColorBlack,
                      fontSize: 16.0,
                    ),
                    keyboardType: widget.keyboardType ?? TextInputType.text,
                    validator: widget.validatorFunction ?? null,
                    controller: widget.textEditingController ?? null,
                  ),
                ),
              ),
              widget.isPasswordField == true
                  ? GestureDetector(
                      onTap: () {
                        _passwordVisibilityToggle(_obscureText);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.remove_red_eye,
                          color: kColorBlack,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: kColorBlack,
          ),
          SizedBox(
            height: 6.0,
          )
        ],
      ),
    );
  }
}
