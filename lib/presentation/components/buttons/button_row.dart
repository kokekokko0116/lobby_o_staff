import 'package:flutter/material.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    super.key,
    this.primaryText,
    this.secondaryText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.spacing = 10.0,
    this.flex = const [1, 1],
    this.reserveSecondarySpace = true,
  });

  final String? primaryText;
  final String? secondaryText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final double spacing;
  final List<int> flex;
  final bool reserveSecondarySpace;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];

    if (secondaryText != null) {
      buttons.add(
        Expanded(
          flex: flex[0],
          child: SecondaryButton(
            text: secondaryText!,
            onPressed: onSecondaryPressed,
            isFullWidth: false,
          ),
        ),
      );
    } else if (reserveSecondarySpace) {
      buttons.add(Expanded(flex: flex[0], child: const SizedBox.shrink()));
    }

    if (primaryText != null &&
        (secondaryText != null || reserveSecondarySpace)) {
      buttons.add(SizedBox(width: spacing));
    }

    if (primaryText != null) {
      buttons.add(
        Expanded(
          flex: flex.length > 1 ? flex[1] : flex[0],
          child: PrimaryButton(
            text: primaryText!,
            onPressed: onPrimaryPressed,
            isFullWidth: false,
          ),
        ),
      );
    }

    return Row(children: buttons);
  }
}
