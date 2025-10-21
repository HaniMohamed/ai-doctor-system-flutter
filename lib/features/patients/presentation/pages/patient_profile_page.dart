import 'package:flutter/material.dart';
import '../../../../generated/l10n/app_localizations.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@email.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _dateOfBirthController = TextEditingController(text: '1990-05-15');
  final _addressController =
      TextEditingController(text: '123 Main St, City, State 12345');
  final _emergencyContactController =
      TextEditingController(text: 'Jane Doe - (555) 987-6543');

  bool _isEditing = false;
  String _bloodType = 'O+';
  String _allergies = 'None known';
  String _medications = 'None';
  String _medicalHistory = 'No significant medical history';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        actions: [
          IconButton(
            onPressed: _toggleEdit,
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            tooltip: _isEditing ? 'Cancel' : 'Edit Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(),
              const SizedBox(height: 24),

              // Personal Information
              _buildSectionTitle('Personal Information'),
              const SizedBox(height: 16),
              _buildPersonalInfoSection(),
              const SizedBox(height: 24),

              // Medical Information
              _buildSectionTitle('Medical Information'),
              const SizedBox(height: 16),
              _buildMedicalInfoSection(),
              const SizedBox(height: 24),

              // Emergency Contact
              _buildSectionTitle('Emergency Contact'),
              const SizedBox(height: 16),
              _buildEmergencyContactSection(),
              const SizedBox(height: 24),

              // Action Buttons
              if (_isEditing) _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Patient ID: P-12345',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoField(
              label: 'Full Name',
              controller: _nameController,
              icon: Icons.person_outline,
            ),
            _buildInfoField(
              label: 'Email',
              controller: _emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildInfoField(
              label: 'Phone',
              controller: _phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            _buildInfoField(
              label: 'Date of Birth',
              controller: _dateOfBirthController,
              icon: Icons.cake_outlined,
              readOnly: true,
              onTap: _isEditing ? _selectDate : null,
            ),
            _buildInfoField(
              label: 'Address',
              controller: _addressController,
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdownField(
              label: 'Blood Type',
              value: _bloodType,
              items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
              onChanged: _isEditing
                  ? (value) {
                      setState(() {
                        _bloodType = value!;
                      });
                    }
                  : null,
            ),
            _buildTextAreaField(
              label: 'Allergies',
              value: _allergies,
              onChanged: _isEditing
                  ? (value) {
                      setState(() {
                        _allergies = value;
                      });
                    }
                  : null,
            ),
            _buildTextAreaField(
              label: 'Current Medications',
              value: _medications,
              onChanged: _isEditing
                  ? (value) {
                      setState(() {
                        _medications = value;
                      });
                    }
                  : null,
            ),
            _buildTextAreaField(
              label: 'Medical History',
              value: _medicalHistory,
              maxLines: 3,
              onChanged: _isEditing
                  ? (value) {
                      setState(() {
                        _medicalHistory = value;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildInfoField(
          label: 'Emergency Contact',
          controller: _emergencyContactController,
          icon: Icons.emergency_outlined,
          helperText: 'Name and phone number',
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    int maxLines = 1,
    VoidCallback? onTap,
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        maxLines: maxLines,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          helperText: helperText,
          suffixIcon: readOnly && onTap != null
              ? const Icon(Icons.calendar_today)
              : null,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    ValueChanged<String?>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextAreaField({
    required String label,
    required String value,
    int maxLines = 2,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _cancelEdit,
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveProfile,
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ),
      ],
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      // Reset controllers to original values
      _nameController.text = 'John Doe';
      _emailController.text = 'john.doe@email.com';
      _phoneController.text = '+1 (555) 123-4567';
      _dateOfBirthController.text = '1990-05-15';
      _addressController.text = '123 Main St, City, State 12345';
      _emergencyContactController.text = 'Jane Doe - (555) 987-6543';
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 5, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _dateOfBirthController.text = picked.toIso8601String().split('T')[0];
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.success),
        backgroundColor: Colors.green,
      ),
    );
  }
}
