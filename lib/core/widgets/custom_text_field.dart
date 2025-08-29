import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: '', // Remove character counter
      ),
    );
  }
}

class CustomPasswordField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const CustomPasswordField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: widget.labelText,
      hintText: widget.hintText,
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      validator: widget.validator,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
