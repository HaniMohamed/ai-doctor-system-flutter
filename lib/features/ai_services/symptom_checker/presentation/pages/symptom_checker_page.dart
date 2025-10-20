import 'package:flutter/material.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _symptomController = TextEditingController();
  final List<String> _symptoms = [];
  bool _isAnalyzing = false;

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
                        child: Center(
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
    });

    // TODO: Implement actual symptom analysis
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
      });

      // TODO: Show analysis results
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Symptom analysis feature coming soon!'),
        ),
      );
    }
  }
}
