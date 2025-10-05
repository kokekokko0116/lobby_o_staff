import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';

class ServiceEvaluationWidget extends StatefulWidget {
  const ServiceEvaluationWidget({
    super.key,
    this.rating = 0,
    this.primaryButtonText = '送信',
    this.secondaryButtonText = '戻る',
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.onRatingChanged,
  });

  final int rating;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final Function(int)? onRatingChanged;

  @override
  State<ServiceEvaluationWidget> createState() =>
      _ServiceEvaluationWidgetState();
}

class _ServiceEvaluationWidgetState extends State<ServiceEvaluationWidget> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildEvaluationTitle(),
        const SizedBox(height: 32),
        _buildStarRating(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildEvaluationTitle() {
    return Text(
      '今回のサービスを★5つで評価してください\n（1つ→5つ=悪い→良い）',
      textAlign: TextAlign.center,
      style: AppTextStyles.h6,
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isSelected = starNumber <= _rating;

        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = starNumber;
            });
            widget.onRatingChanged?.call(_rating);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(
              isSelected ? Icons.star : Icons.star_border,
              size: 60,
              color: isSelected
                  ? const Color(0xFFFFD700)
                  : const Color(0xFFE0E0E0),
            ),
          ),
        );
      }),
    );
  }
}
