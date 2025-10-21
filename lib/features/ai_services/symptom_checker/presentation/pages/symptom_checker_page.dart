import 'package:ai_doctor_system/features/ai_services/symptom_checker/domain/entities/analysis_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/symptom.dart';
import '../controllers/symptom_checker_controller.dart';
import '../../../../../shared/widgets/ai_loading_animation.dart';
import '../../../../../shared/services/ai_progress_service.dart';
import '../../../../../generated/l10n/app_localizations.dart';
import '../../../../../shared/widgets/base_scaffold.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _symptomController = TextEditingController();
  final FocusNode _symptomFocusNode = FocusNode();
  bool _canAddSymptom = false;
  late SymptomCheckerController _controller;
  final AIProgressService _progressService = AIProgressService();
  String _currentLoadingMessage = "🧠 Initializing AI analysis...";
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SymptomCheckerController>();
    _symptomController.addListener(_onTextChanged);

    // Listen to progress updates
    _progressService.progressStream.listen((progress) {
      if (mounted) {
        setState(() {
          _currentProgress = progress;
        });
      }
    });

    _progressService.messageStream.listen((message) {
      if (mounted) {
        setState(() {
          _currentLoadingMessage = message;
        });
      }
    });
  }

  @override
  void dispose() {
    _symptomController.removeListener(_onTextChanged);
    _symptomController.dispose();
    _symptomFocusNode.dispose();
    _progressService.stopProgress();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _canAddSymptom = _symptomController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: AppLocalizations.of(context)!.symptomChecker,
      actions: [
        Obx(() {
          if (_controller.symptoms.isNotEmpty) {
            return IconButton(
              onPressed: _clearSymptoms,
              icon: const Icon(Icons.clear_all),
              tooltip: AppLocalizations.of(context)!.clearAllSymptoms,
            );
          }
          return const SizedBox.shrink();
        }),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.describeYourSymptoms,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _symptomController,
              focusNode: _symptomFocusNode,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterSymptomsHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onSubmitted: _addSymptom,
              onChanged: (value) {
                // Handle Enter key in multi-line text field
                if (value.contains('\n')) {
                  // Remove the newline and submit
                  final textWithoutNewline = value.replaceAll('\n', '').trim();
                  if (textWithoutNewline.isNotEmpty) {
                    _symptomController.text = textWithoutNewline;
                    _addSymptom(textWithoutNewline);
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _canAddSymptom
                  ? () => _addSymptom(_symptomController.text)
                  : null,
              icon: const Icon(Icons.add),
              label: const Text('Add Symptom'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (_controller.symptoms.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Symptoms',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _controller.symptoms
                          .map((symptom) => Chip(
                                label: Text(symptom.name),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => _removeSymptom(symptom),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _controller.isLoading.value
                            ? null
                            : _analyzeSymptoms,
                        icon: _controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.analytics),
                        label: Text(_controller.isLoading.value
                            ? 'Analyzing...'
                            : 'Analyze Symptoms'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analysis Results',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      // Show error message if there's an error
                      if (_controller.errorMessage.value.isNotEmpty) {
                        return _buildErrorMessage(context);
                      }

                      // Show AI loading animation when analyzing
                      if (_controller.isLoading.value) {
                        return MedicalAiLoadingIndicator(
                          initialText: _currentLoadingMessage,
                          primaryColor: Theme.of(context).colorScheme.primary,
                          secondaryColor:
                              Theme.of(context).colorScheme.secondary,
                        );
                      }

                      if (_controller.result.value != null) {
                        return _buildAnalysisResults(context);
                      } else {
                        return Center(
                          child: Text(
                            _controller.symptoms.isEmpty
                                ? 'Add symptoms above to get AI-powered analysis'
                                : 'Click "Analyze Symptoms" to get recommendations',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSymptom(String? symptomText) {
    if (symptomText != null && symptomText.trim().isNotEmpty) {
      final symptom =
          Symptom(name: symptomText.trim(), severity: 5); // Default severity
      _controller.symptoms.add(symptom);
      _symptomController.clear();
      // Clear any previous error messages when adding new symptoms
      _controller.errorMessage.value = '';
      // Return focus to the text field after adding symptom
      // Use addPostFrameCallback to ensure the UI has updated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _symptomFocusNode.canRequestFocus) {
          _symptomFocusNode.requestFocus();
        }
      });
    }
  }

  void _removeSymptom(Symptom symptom) {
    _controller.symptoms.remove(symptom);
  }

  void _clearSymptoms() {
    _controller.symptoms.clear();
  }

  Future<void> _analyzeSymptoms() async {
    if (_controller.symptoms.isEmpty) return;

    // Prevent multiple rapid clicks
    if (_controller.isLoading.value) {
      return;
    }

    // Clear any previous error messages when starting new analysis
    _controller.errorMessage.value = '';

    // Start AI progress animation
    _progressService.startProgress();

    await _controller.analyze();

    // Stop progress animation when analysis is complete
    _progressService.stopProgress();
  }

  Widget _buildAnalysisResults(BuildContext context) {
    final AnalysisResult result = _controller.result.value!;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Top Row: Urgency Level and Confidence
      Row(
        children: [
          // Urgency Level
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getUrgencyColor(result.urgencyLevel),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${result.urgencyLevel.toUpperCase()} URGENCY',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Confidence Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Confidence: ${((result.confidence) * 100).toInt()}%',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Recommended Specialties
      Text(
        'Recommended Specialties',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: (result.recommendedSpecialties)
            .map((specialty) => Chip(
                  label: Text(specialty),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ))
            .toList(),
      ),
      const SizedBox(height: 16),

      // Bottom Row: Explanation and Suggested Questions
      if (result.explanation.isNotEmpty ||
          result.suggestedQuestions.isNotEmpty) ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Explanation Section
            if (result.explanation.isNotEmpty) ...[
              Expanded(
                flex: 1,
                child: _buildExplanationCard(context, result.explanation),
              ),
              if (result.suggestedQuestions.isNotEmpty)
                const SizedBox(width: 16),
            ],
            // Suggested Questions Section
            if (result.suggestedQuestions.isNotEmpty) ...[
              Expanded(
                flex: 1,
                child: _buildSuggestedQuestionsCard(
                    context, result.suggestedQuestions),
              ),
            ],
          ],
        ),
      ],
    ]);
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Analysis Failed',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _controller.errorMessage.value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _controller.errorMessage.value = '';
              _analyzeSymptoms();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildExplanationCard(BuildContext context, String explanation) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.1),
            Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI Analysis',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                explanation,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestionsCard(
      BuildContext context, List<String> questions) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withValues(alpha: 0.1),
            Theme.of(context)
                .colorScheme
                .tertiaryContainer
                .withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.quiz,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Suggested Questions',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return Container(
                margin: EdgeInsets.only(
                    bottom: index < questions.length - 1 ? 8 : 0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _handleQuestionTap(question),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withValues(alpha: 0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              question,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    height: 1.3,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _handleQuestionTap(String question) {
    // Add the question to the symptom input field
    _symptomController.text = question;
    _onTextChanged(); // Update the UI state
  }
}
