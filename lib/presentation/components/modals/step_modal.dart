import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class StepModal extends StatefulWidget {
  const StepModal({
    super.key,
    required this.steps,
    required this.stepTitles,
    this.initialStep = 0,
    this.onStepChanged,
    this.onClose,
    this.maxHeight = 600,
    this.showCloseButton = true,
    this.headerPadding = const EdgeInsets.all(16),
    this.contentPadding = const EdgeInsets.all(24),
  });

  final List<Widget> steps;
  final List<String> stepTitles;
  final int initialStep;
  final Function(int step)? onStepChanged;
  final VoidCallback? onClose;
  final double maxHeight;
  final bool showCloseButton;
  final EdgeInsets headerPadding;
  final EdgeInsets contentPadding;

  @override
  State<StepModal> createState() => StepModalState();
}

class StepModalState extends State<StepModal> {
  late int _currentStep;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        decoration: BoxDecoration(
          color: backgroundDefault,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: widget.contentPadding,
                child: _buildCurrentStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: widget.headerPadding,
      decoration: BoxDecoration(
        color: backgroundMuted,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _currentStep < widget.stepTitles.length 
                  ? widget.stepTitles[_currentStep]
                  : '',
              style: AppTextStyles.h5.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (widget.showCloseButton)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onClose?.call();
              },
              icon: Icon(
                Icons.close,
                color: textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    if (_currentStep >= 0 && _currentStep < widget.steps.length) {
      return StepModalController(
        stepModal: this,
        child: widget.steps[_currentStep],
      );
    }
    return const SizedBox();
  }

  void goToNextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      widget.onStepChanged?.call(_currentStep);
    }
  }

  void goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      widget.onStepChanged?.call(_currentStep);
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < widget.steps.length) {
      setState(() {
        _currentStep = step;
      });
      widget.onStepChanged?.call(_currentStep);
    }
  }

  void closeModal() {
    Navigator.of(context).pop();
    widget.onClose?.call();
  }

  int get currentStep => _currentStep;
  int get totalSteps => widget.steps.length;
  bool get canGoNext => _currentStep < widget.steps.length - 1;
  bool get canGoPrevious => _currentStep > 0;
  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == widget.steps.length - 1;
}

class StepModalController extends InheritedWidget {
  const StepModalController({
    super.key,
    required this.stepModal,
    required super.child,
  });

  final StepModalState stepModal;

  static StepModalController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StepModalController>();
  }

  @override
  bool updateShouldNotify(StepModalController oldWidget) {
    return stepModal != oldWidget.stepModal;
  }
}

extension StepModalExtension on BuildContext {
  StepModalState? get stepModal => StepModalController.of(this)?.stepModal;
}