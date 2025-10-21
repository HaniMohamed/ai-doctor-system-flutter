import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/symptom_checker_controller.dart';
import '../../domain/entities/symptom.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _symptomController = TextEditingController();
  bool _canAddSymptom = false;
  late SymptomCheckerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SymptomCheckerController>();
    _symptomController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _symptomController.removeListener(_onTextChanged);
    _symptomController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _canAddSymptom = _symptomController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Checker'),
        actions: [
          Obx(() {
            if (_controller.symptoms.isNotEmpty) {
              return IconButton(
                onPressed: _clearSymptoms,
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear all symptoms',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Describe your symptoms',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _symptomController,
              decoration: const InputDecoration(
                hintText: 'Enter your symptoms (e.g., headache, fever, nausea)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              maxLines: 3,
              onSubmitted: _addSymptom,
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
            Expanded(
              child: Card(
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
                      Expanded(
                        child: Obx(() {
                          if (_controller.result.value != null) {
                            return _buildAnalysisResults(context);
                          } else {
                            return Center(
                              child: Text(
                                _controller.symptoms.isEmpty
                                    ? 'Add symptoms above to get AI-powered analysis'
                                    : 'Click "Analyze Symptoms" to get recommendations',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                        }),
                      ),
                    ],
                  ),
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
    await _controller.analyze();
  }

  Widget _buildAnalysisResults(BuildContext context) {
    final result = _controller.result.value!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            children: result.recommendedSpecialties
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

          // Confidence Score
          Text(
            'Confidence: ${(result.confidence * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
}
