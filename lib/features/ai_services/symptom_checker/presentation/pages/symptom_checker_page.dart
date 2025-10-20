import 'package:flutter/material.dart';

class SymptomAnalysisResult {
  final List<String> possibleConditions;
  final List<String> recommendations;
  final double confidence;
  final String severity;
  final bool shouldSeeDoctor;

  SymptomAnalysisResult({
    required this.possibleConditions,
    required this.recommendations,
    required this.confidence,
    required this.severity,
    required this.shouldSeeDoctor,
  });
}

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _symptomController = TextEditingController();
  final List<String> _symptoms = [];
  bool _isAnalyzing = false;
  SymptomAnalysisResult? _analysisResult;

  @override
  void dispose() {
    _symptomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Checker'),
        actions: [
          if (_symptoms.isNotEmpty)
            IconButton(
              onPressed: _clearSymptoms,
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear all symptoms',
            ),
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
              onPressed: _symptoms.isEmpty ? null : _analyzeSymptoms,
              icon: const Icon(Icons.add),
              label: const Text('Add Symptom'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),
            if (_symptoms.isNotEmpty) ...[
              Text(
                'Current Symptoms',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _symptoms.map((symptom) => Chip(
                  label: Text(symptom),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _removeSymptom(symptom),
                )).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeSymptoms,
                  icon: _isAnalyzing 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.analytics),
                  label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze Symptoms'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                ),
              ),
            ],
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
                        child: _analysisResult != null 
                            ? _buildAnalysisResults(context)
                            : Center(
                                child: Text(
                                  _symptoms.isEmpty 
                                      ? 'Add symptoms above to get AI-powered analysis'
                                      : 'Click "Analyze Symptoms" to get recommendations',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
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

  void _addSymptom(String? symptom) {
    if (symptom != null && symptom.trim().isNotEmpty) {
      setState(() {
        _symptoms.add(symptom.trim());
        _symptomController.clear();
      });
    }
  }

  void _removeSymptom(String symptom) {
    setState(() {
      _symptoms.remove(symptom);
    });
  }

  void _clearSymptoms() {
    setState(() {
      _symptoms.clear();
    });
  }

  Future<void> _analyzeSymptoms() async {
    if (_symptoms.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    // Simulate AI analysis processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Generate realistic analysis results based on symptoms
      final result = _generateAnalysisResult(_symptoms);
      
      setState(() {
        _isAnalyzing = false;
        _analysisResult = result;
      });
    }
  }

  SymptomAnalysisResult _generateAnalysisResult(List<String> symptoms) {
    // Simple rule-based analysis (in real app, this would call AI service)
    final symptomText = symptoms.join(' ').toLowerCase();
    
    List<String> possibleConditions = [];
    List<String> recommendations = [];
    double confidence = 0.7;
    String severity = 'Low';
    bool shouldSeeDoctor = false;

    // Analyze based on common symptom patterns
    if (symptomText.contains('fever') || symptomText.contains('temperature')) {
      possibleConditions.addAll(['Viral Infection', 'Bacterial Infection', 'Flu']);
      recommendations.addAll([
        'Rest and stay hydrated',
        'Monitor temperature regularly',
        'Use fever reducers if temperature exceeds 38.5°C'
      ]);
      if (symptomText.contains('high') || symptomText.contains('severe')) {
        severity = 'High';
        shouldSeeDoctor = true;
        confidence = 0.9;
      }
    }

    if (symptomText.contains('headache') || symptomText.contains('head pain')) {
      possibleConditions.addAll(['Tension Headache', 'Migraine', 'Sinusitis']);
      recommendations.addAll([
        'Apply cold compress to forehead',
        'Ensure adequate sleep',
        'Stay hydrated and avoid caffeine'
      ]);
      if (symptomText.contains('severe') || symptomText.contains('throbbing')) {
        severity = 'Medium';
        shouldSeeDoctor = true;
      }
    }

    if (symptomText.contains('cough') || symptomText.contains('throat')) {
      possibleConditions.addAll(['Common Cold', 'Bronchitis', 'Allergies']);
      recommendations.addAll([
        'Use throat lozenges',
        'Drink warm liquids',
        'Avoid irritants like smoke'
      ]);
    }

    if (symptomText.contains('nausea') || symptomText.contains('vomit')) {
      possibleConditions.addAll(['Gastroenteritis', 'Food Poisoning', 'Morning Sickness']);
      recommendations.addAll([
        'Eat bland foods (BRAT diet)',
        'Stay hydrated with small sips',
        'Avoid dairy and fatty foods'
      ]);
      if (symptomText.contains('severe') || symptomText.contains('persistent')) {
        severity = 'Medium';
        shouldSeeDoctor = true;
      }
    }

    if (symptomText.contains('rash') || symptomText.contains('skin')) {
      possibleConditions.addAll(['Allergic Reaction', 'Contact Dermatitis', 'Viral Rash']);
      recommendations.addAll([
        'Avoid scratching the affected area',
        'Use gentle, fragrance-free moisturizers',
        'Identify and avoid potential allergens'
      ]);
      severity = 'Medium';
      shouldSeeDoctor = true;
    }

    // Default recommendations if no specific conditions found
    if (possibleConditions.isEmpty) {
      possibleConditions = ['General Malaise', 'Stress-related Symptoms'];
      recommendations = [
        'Get adequate rest',
        'Maintain a healthy diet',
        'Stay hydrated',
        'Consider stress management techniques'
      ];
    }

    // Add general recommendations
    recommendations.addAll([
      'Monitor symptoms and seek medical attention if they worsen',
      'Maintain good hygiene practices',
      'Consider over-the-counter medications for symptom relief'
    ]);

    return SymptomAnalysisResult(
      possibleConditions: possibleConditions,
      recommendations: recommendations,
      confidence: confidence,
      severity: severity,
      shouldSeeDoctor: shouldSeeDoctor,
    );
  }

  Widget _buildAnalysisResults(BuildContext context) {
    if (_analysisResult == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Severity and Confidence
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getSeverityColor(_analysisResult!.severity),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_analysisResult!.severity} Risk',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Confidence: ${(_analysisResult!.confidence * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Should see doctor warning
          if (_analysisResult!.shouldSeeDoctor)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Consider consulting a healthcare professional',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_analysisResult!.shouldSeeDoctor) const SizedBox(height: 16),

          // Possible Conditions
          Text(
            'Possible Conditions',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _analysisResult!.possibleConditions.map((condition) => Chip(
              label: Text(condition),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),

          // Recommendations
          Text(
            'Recommendations',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ..._analysisResult!.recommendations.map((recommendation) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
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
