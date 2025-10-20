---
title: "Developer Experience & Governance - AI Doctor System Flutter Client"
updated: "2024-12-01"
tags: ["developer-experience", "governance", "standards", "healthcare"]
summary: "Comprehensive developer experience framework and governance standards for healthcare-grade Flutter application"
---

## Bootstrap Log (Flutter Client)

- 2025-10-20: Initialized Flutter client scaffolding
  - Added `pubspec.yaml` with core dependencies (get, dio, websocket, sqflite, flutter_secure_storage)
  - Added `analysis_options.yaml` and `.gitignore`
  - Created `README.md` with setup/build instructions
  - Added `scripts/` (`build.sh`, `test.sh`, `deploy.sh`)
  - Next: Scaffold core app shell (`main.dart`, `app.dart`, routes) per modular structure

- 2025-10-20: Core app shell implemented
  - Created `lib/main.dart` with DI initialization
  - Created `lib/app.dart` with GetX MaterialApp and theme
  - Created `lib/routes/` with app routes, pages, and middleware
  - Created `lib/core/theme/` with app theme, colors, text, and components
  - Created `lib/core/di/` with service locator and injection container
  - Created `lib/core/network/api_client.dart` (placeholder)
  - Created `lib/core/storage/` (local, secure, cache manager)
  - Created `lib/shared/widgets/splash_screen.dart`
  - Created placeholder pages for all routes
  - Created auth service interface and implementation
  - Implemented network layer interceptors (auth, error, logging) and wired into `ApiClient`
  - Implemented storage layer: `LocalStorage`, `SecureStorage`, `CacheManager`
  - Implemented `EnvironmentConfig` and wired `ApiConstants`
  - Implemented Errors/Failures and ErrorHandler mapping
  - Implemented security foundations: `SecureHttpClient` (pinning stub) and `EncryptionService` (AES-GCM placeholder)
  - Implemented observability scaffolding: `PerformanceMetrics`, `HealthCheckService`
  - Implemented shared widgets: `LoadingWidget`, `CommonErrorWidget`
  - Implemented Auth module skeleton: data sources, models, repositories, use cases, controller, binding, and functional login page
  - Added dependencies: `dartz`, `connectivity_plus`
  - Profile module scaffolding: entities, models, remote/local datasources, repository, use cases, controller, binding, basic page
  - Dashboard page scaffold with basic stat cards
  - Appointments module: entity, model, remote datasource, repository, usecase, controller, binding, route and page wiring
  - Doctors module: entity, model, remote datasource, repository, usecase, controller, binding, route
  - Patients module: entity, model, remote datasource, repository, usecase, controller, binding, route
  - Notifications module: entity, model, remote datasource, repository, usecase, controller, binding, route
  - Next: AI services (Symptom Checker first) and realtime/offline scaffolding

# Developer Experience & Governance - AI Doctor System Flutter Client

## Developer Experience Overview

The AI Doctor System implements a comprehensive developer experience framework that ensures consistent code quality, efficient development workflows, and adherence to healthcare-grade standards. This framework includes linting rules, commit hooks, documentation standards, and onboarding processes.

## Linting & Code Quality

### **Analysis Options Configuration**
```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
    - "build/**"
    - "lib/generated/**"
  
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  
  errors:
    invalid_annotation_target: ignore
    missing_required_param: error
    missing_return: error
    todo: ignore
    deprecated_member_use: warning
    deprecated_member_use_from_same_package: warning

linter:
  rules:
    # Error rules
    avoid_web_libraries_in_flutter: true
    cancel_subscriptions: true
    close_sinks: true
    comment_references: true
    control_flow_in_finally: true
    empty_statements: true
    hash_and_equals: true
    invariant_booleans: true
    iterable_contains_unrelated_type: true
    list_remove_unrelated_type: true
    literal_only_boolean_expressions: true
    no_adjacent_strings_in_list: true
    no_duplicate_case_values: true
    no_logic_in_create_state: true
    prefer_void_to_null: true
    test_types_in_equals: true
    throw_in_finally: true
    unnecessary_statements: true
    valid_regexps: true
    
    # Style rules
    always_declare_return_types: true
    always_put_control_body_on_new_line: true
    always_specify_types: false
    annotate_overrides: true
    avoid_annotating_with_dynamic: true
    avoid_bool_literals_in_conditional_expressions: true
    avoid_catches_without_on_clauses: true
    avoid_catching_errors: true
    avoid_classes_with_only_static_members: true
    avoid_double_and_int_checks: true
    avoid_escaping_inner_quotes: true
    avoid_field_initializers_in_const_classes: true
    avoid_function_literals_in_foreach_calls: true
    avoid_implementing_value_types: true
    avoid_init_to_null: true
    avoid_js_rounded_ints: true
    avoid_multiple_declarations_per_line: true
    avoid_null_checks_in_equality_operators: true
    avoid_positional_boolean_parameters: true
    avoid_private_typedef_functions: true
    avoid_redundant_argument_values: true
    avoid_renaming_method_parameters: true
    avoid_return_types_on_setters: true
    avoid_returning_null: true
    avoid_returning_null_for_future: true
    avoid_returning_null_for_void: true
    avoid_returning_this: true
    avoid_setters_without_getters: true
    avoid_shadowing_type_parameters: true
    avoid_single_cascade_in_expression_statements: true
    avoid_slow_async_io: true
    avoid_types_as_parameter_names: true
    avoid_types_on_closure_parameters: true
    avoid_unnecessary_containers: true
    avoid_unused_constructor_parameters: true
    avoid_void_async: true
    await_only_futures: true
    camel_case_extensions: true
    camel_case_types: true
    cascade_invocations: true
    cast_nullable_to_non_nullable: true
    constant_identifier_names: true
    curly_braces_in_flow_control_structures: true
    deprecated_consistency: true
    directives_ordering: true
    empty_catches: true
    empty_constructor_bodies: true
    empty_else: true
    eol_at_end_of_file: true
    exhaustive_cases: true
    file_names: true
    flutter_style_todos: true
    implementation_imports: true
    join_return_with_assignment: true
    leading_newlines_in_multiline_strings: true
    library_names: true
    library_prefixes: true
    lines_longer_than_80_chars: true
    missing_whitespace_between_adjacent_strings: true
    no_default_cases: true
    no_leading_underscores_for_library_prefixes: true
    no_leading_underscores_for_local_identifiers: true
    non_constant_identifier_names: true
    null_check_on_nullable_type_parameter: true
    null_closures: true
    omit_local_variable_types: true
    one_member_abstracts: true
    only_throw_errors: true
    overridden_fields: true
    package_api_docs: true
    package_names: true
    package_prefixed_library_names: true
    parameter_assignments: true
    prefer_adjacent_string_concatenation: true
    prefer_asserts_in_initializer_lists: true
    prefer_asserts_with_message: true
    prefer_collection_literals: true
    prefer_conditional_assignment: true
    prefer_const_constructors: true
    prefer_const_constructors_in_immutables: true
    prefer_const_declarations: true
    prefer_const_literals_to_create_immutables: true
    prefer_constructors_over_static_methods: true
    prefer_contains: true
    prefer_equal_for_default_values: true
    prefer_expression_function_bodies: true
    prefer_final_fields: true
    prefer_final_in_for_each: true
    prefer_final_locals: true
    prefer_for_elements_to_map_fromIterable: true
    prefer_function_declarations_over_variables: true
    prefer_generic_function_type_aliases: true
    prefer_if_elements_to_conditional_expressions: true
    prefer_if_null_operators: true
    prefer_initializing_formals: true
    prefer_inlined_adds: true
    prefer_int_literals: true
    prefer_interpolation_to_compose_strings: true
    prefer_is_empty: true
    prefer_is_not_empty: true
    prefer_is_not_operator: true
    prefer_iterable_whereType: true
    prefer_null_aware_operators: true
    prefer_relative_imports: true
    prefer_single_quotes: true
    prefer_spread_collections: true
    prefer_typing_uninitialized_variables: true
    provide_deprecation_message: true
    public_member_api_docs: true
    recursive_getters: true
    slash_for_doc_comments: true
    sort_child_properties_last: true
    sort_constructors_first: true
    sort_pub_dependencies: true
    sort_unnamed_constructors_first: true
    type_annotate_public_apis: true
    type_init_formals: true
    unawaited_futures: true
    unnecessary_await_in_return: true
    unnecessary_brace_in_string_interps: true
    unnecessary_const: true
    unnecessary_constructor_name: true
    unnecessary_getters_setters: true
    unnecessary_lambdas: true
    unnecessary_new: true
    unnecessary_null_aware_assignments: true
    unnecessary_null_checks: true
    unnecessary_null_in_if_null_operators: true
    unnecessary_nullable_for_final_variable_declarations: true
    unnecessary_overrides: true
    unnecessary_parenthesis: true
    unnecessary_raw_strings: true
    unnecessary_string_escapes: true
    unnecessary_string_interpolations: true
    unnecessary_this: true
    unrelated_type_equality_checks: true
    use_build_context_synchronously: true
    use_colored_box: true
    use_decorated_box: true
    use_enums: true
    use_full_hex_values_for_flutter_colors: true
    use_function_type_syntax_for_parameters: true
    use_if_null_to_convert_nulls_to_bools: true
    use_is_even_rather_than_modulo: true
    use_key_in_widget_constructors: true
    use_late_for_private_fields_and_variables: true
    use_named_constants: true
    use_raw_strings: true
    use_rethrow_when_possible: true
    use_setters_to_change_properties: true
    use_string_buffers: true
    use_super_parameters: true
    use_test_throws_matchers: true
    use_to_and_as_if_applicable: true
    void_checks: true
```

### **Custom Lint Rules**
```dart
// lib/lints/custom_rules.dart
class CustomLintRules {
  static const List<String> rules = [
    'prefer_const_constructors',
    'prefer_const_literals_to_create_immutables',
    'prefer_final_fields',
    'prefer_final_locals',
    'avoid_print',
    'avoid_web_libraries_in_flutter',
    'use_key_in_widget_constructors',
    'prefer_single_quotes',
    'sort_child_properties_last',
    'always_declare_return_types',
    'prefer_relative_imports',
    'avoid_unnecessary_containers',
    'use_build_context_synchronously',
    'prefer_const_constructors_in_immutables',
    'prefer_const_declarations',
    'prefer_const_literals_to_create_immutables',
    'prefer_final_fields',
    'prefer_final_in_for_each',
    'prefer_final_locals',
    'prefer_for_elements_to_map_fromIterable',
    'prefer_function_declarations_over_variables',
    'prefer_generic_function_type_aliases',
    'prefer_if_elements_to_conditional_expressions',
    'prefer_if_null_operators',
    'prefer_initializing_formals',
    'prefer_inlined_adds',
    'prefer_int_literals',
    'prefer_interpolation_to_compose_strings',
    'prefer_is_empty',
    'prefer_is_not_empty',
    'prefer_is_not_operator',
    'prefer_iterable_whereType',
    'prefer_null_aware_operators',
    'prefer_relative_imports',
    'prefer_single_quotes',
    'prefer_spread_collections',
    'prefer_typing_uninitialized_variables',
    'provide_deprecation_message',
    'public_member_api_docs',
    'recursive_getters',
    'slash_for_doc_comments',
    'sort_child_properties_last',
    'sort_constructors_first',
    'sort_pub_dependencies',
    'sort_unnamed_constructors_first',
    'type_annotate_public_apis',
    'type_init_formals',
    'unawaited_futures',
    'unnecessary_await_in_return',
    'unnecessary_brace_in_string_interps',
    'unnecessary_const',
    'unnecessary_constructor_name',
    'unnecessary_getters_setters',
    'unnecessary_lambdas',
    'unnecessary_new',
    'unnecessary_null_aware_assignments',
    'unnecessary_null_checks',
    'unnecessary_null_in_if_null_operators',
    'unnecessary_nullable_for_final_variable_declarations',
    'unnecessary_overrides',
    'unnecessary_parenthesis',
    'unnecessary_raw_strings',
    'unnecessary_string_escapes',
    'unnecessary_string_interpolations',
    'unnecessary_this',
    'unrelated_type_equality_checks',
    'use_build_context_synchronously',
    'use_colored_box',
    'use_decorated_box',
    'use_enums',
    'use_full_hex_values_for_flutter_colors',
    'use_function_type_syntax_for_parameters',
    'use_if_null_to_convert_nulls_to_bools',
    'use_is_even_rather_than_modulo',
    'use_key_in_widget_constructors',
    'use_late_for_private_fields_and_variables',
    'use_named_constants',
    'use_raw_strings',
    'use_rethrow_when_possible',
    'use_setters_to_change_properties',
    'use_string_buffers',
    'use_super_parameters',
    'use_test_throws_matchers',
    'use_to_and_as_if_applicable',
    'void_checks',
  ];
}
```

## Commit Hooks & Standards

### **Pre-commit Hook Configuration**
```bash
#!/bin/sh
# .git/hooks/pre-commit

echo "Running pre-commit checks..."

# Check for large files
if git diff --cached --name-only | xargs ls -la | awk '$5 > 10485760 {print $9 " is larger than 10MB"}'; then
    echo "Error: Files larger than 10MB are not allowed"
    exit 1
fi

# Check for TODO/FIXME comments
if git diff --cached --name-only | xargs grep -l "TODO\|FIXME" | grep -v "\.md$"; then
    echo "Error: TODO/FIXME comments are not allowed in committed code"
    exit 1
fi

# Run Flutter analyze
flutter analyze
if [ $? -ne 0 ]; then
    echo "Error: Flutter analyze failed"
    exit 1
fi

# Run tests
flutter test
if [ $? -ne 0 ]; then
    echo "Error: Tests failed"
    exit 1
fi

echo "Pre-commit checks passed!"
```

### **Commit Message Standards**
```bash
# .gitmessage template
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>

# Types:
# feat:     A new feature
# fix:      A bug fix
# docs:     Documentation only changes
# style:    Changes that do not affect the meaning of the code
# refactor: A code change that neither fixes a bug nor adds a feature
# perf:     A code change that improves performance
# test:     Adding missing tests or correcting existing tests
# chore:    Changes to the build process or auxiliary tools

# Scope:
# auth:     Authentication related changes
# ai:       AI services related changes
# ui:       UI/UX related changes
# api:      API related changes
# db:       Database related changes
# test:     Testing related changes
# docs:     Documentation related changes
# build:    Build system related changes
# ci:       CI/CD related changes

# Examples:
# feat(auth): add biometric authentication
# fix(ai): resolve symptom checker timeout issue
# docs(api): update authentication endpoints documentation
# refactor(ui): extract common button component
# perf(db): optimize appointment query performance
```

### **Commit Validation Script**
```dart
// scripts/validate_commit.dart
import 'dart:io';

void main(List<String> args) {
  final commitMessage = args.isNotEmpty ? args.first : '';
  
  if (!_isValidCommitMessage(commitMessage)) {
    print('Error: Invalid commit message format');
    print('Expected format: <type>(<scope>): <subject>');
    print('Example: feat(auth): add biometric authentication');
    exit(1);
  }
  
  print('Commit message is valid');
}

bool _isValidCommitMessage(String message) {
  final regex = RegExp(r'^(feat|fix|docs|style|refactor|perf|test|chore)\([^)]+\): .+');
  return regex.hasMatch(message);
}
```

## Documentation Standards

### **Code Documentation Template**
```dart
/// A comprehensive authentication service that handles user authentication,
/// token management, and session management for the AI Doctor System.
///
/// This service provides secure authentication mechanisms including:
/// - Email/password authentication
/// - Biometric authentication
/// - Token refresh and management
/// - Session persistence
///
/// Example usage:
/// ```dart
/// final authService = AuthService();
/// final result = await authService.login('user@example.com', 'password');
/// if (result.isSuccess) {
///   // Navigate to dashboard
/// }
/// ```
///
/// See also:
/// - [AuthController] for state management
/// - [AuthRepository] for data persistence
/// - [BiometricAuthService] for biometric authentication
class AuthService {
  /// Authenticates a user with email and password.
  ///
  /// Returns [AuthResult.success] if authentication is successful,
  /// [AuthResult.failure] if authentication fails.
  ///
  /// Throws [AuthenticationException] if there's a network error or
  /// the authentication service is unavailable.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final result = await authService.login('user@example.com', 'password');
  ///   if (result.isSuccess) {
  ///     // Handle successful login
  ///   }
  /// } catch (e) {
  ///   // Handle authentication error
  /// }
  /// ```
  Future<AuthResult> login(String email, String password) async {
    // Implementation
  }
  
  /// Refreshes the authentication token.
  ///
  /// This method should be called when the current token is about to expire
  /// or has already expired.
  ///
  /// Returns [AuthResult.success] with a new token if successful,
  /// [AuthResult.failure] if the refresh token is invalid.
  ///
  /// Throws [AuthenticationException] if there's a network error.
  Future<AuthResult> refreshToken() async {
    // Implementation
  }
}
```

### **API Documentation Standards**
```dart
/// REST API endpoint for user authentication.
///
/// **Endpoint**: `POST /api/v1/auth/login`
/// **Content-Type**: `application/x-www-form-urlencoded`
/// **Authentication**: None required
///
/// **Request Body**:
/// ```json
/// {
///   "username": "user@example.com",
///   "password": "password123"
/// }
/// ```
///
/// **Response** (200 OK):
/// ```json
/// {
///   "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
///   "token_type": "bearer",
///   "expires_in": 1800
/// }
/// ```
///
/// **Response** (401 Unauthorized):
/// ```json
/// {
///   "error": "INVALID_CREDENTIALS",
///   "message": "Invalid email or password"
/// }
/// ```
///
/// **Error Codes**:
/// - `INVALID_CREDENTIALS`: Email or password is incorrect
/// - `ACCOUNT_LOCKED`: Account is temporarily locked
/// - `ACCOUNT_DISABLED`: Account is disabled
///
/// **Rate Limiting**: 5 attempts per minute per IP address
/// **Security**: Passwords are hashed using bcrypt
class AuthEndpoint {
  // Implementation
}
```

## Developer Onboarding

### **Onboarding Checklist**
```markdown
# Developer Onboarding Checklist

## Pre-requisites
- [ ] Flutter SDK 3.16+ installed
- [ ] Dart SDK 3.2+ installed
- [ ] Android Studio / VS Code with Flutter extensions
- [ ] Git configured with SSH keys
- [ ] Access to project repositories
- [ ] Access to development environments

## Environment Setup
- [ ] Clone repository
- [ ] Install dependencies (`flutter pub get`)
- [ ] Configure environment variables
- [ ] Set up local database
- [ ] Configure API endpoints
- [ ] Run initial build
- [ ] Verify tests pass

## Development Tools
- [ ] Install Flutter extensions
- [ ] Configure linting rules
- [ ] Set up code formatting
- [ ] Install debugging tools
- [ ] Configure performance profiling
- [ ] Set up error reporting

## Project Knowledge
- [ ] Read project documentation
- [ ] Understand architecture
- [ ] Review code standards
- [ ] Learn testing practices
- [ ] Understand deployment process
- [ ] Review security guidelines

## First Tasks
- [ ] Fix a simple bug
- [ ] Add a small feature
- [ ] Write unit tests
- [ ] Submit a pull request
- [ ] Participate in code review
- [ ] Deploy to staging

## Completion
- [ ] Complete onboarding tasks
- [ ] Pass code review
- [ ] Deploy first feature
- [ ] Receive team feedback
- [ ] Update documentation
- [ ] Mentor next developer
```

### **Onboarding Scripts**
```bash
#!/bin/bash
# scripts/setup_dev_environment.sh

echo "Setting up development environment for AI Doctor System..."

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter is not installed"
    exit 1
fi

# Check Flutter version
flutter_version=$(flutter --version | head -n 1 | cut -d' ' -f2)
required_version="3.16.0"

if [ "$(printf '%s\n' "$required_version" "$flutter_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo "Error: Flutter version $flutter_version is not supported. Required: $required_version or higher"
    exit 1
fi

# Install dependencies
echo "Installing dependencies..."
flutter pub get

# Generate code
echo "Generating code..."
flutter packages pub run build_runner build

# Run tests
echo "Running tests..."
flutter test

# Check code quality
echo "Checking code quality..."
flutter analyze

echo "Development environment setup complete!"
```

## Code Review Standards

### **Code Review Checklist**
```markdown
# Code Review Checklist

## Functionality
- [ ] Code works as intended
- [ ] Edge cases are handled
- [ ] Error handling is appropriate
- [ ] Performance is acceptable
- [ ] Security considerations are addressed

## Code Quality
- [ ] Code follows project standards
- [ ] Functions are focused and single-purpose
- [ ] Variable and function names are descriptive
- [ ] Code is readable and maintainable
- [ ] No code duplication

## Testing
- [ ] Unit tests are included
- [ ] Tests cover edge cases
- [ ] Tests are meaningful and not trivial
- [ ] Integration tests are included if needed
- [ ] Test coverage is adequate

## Documentation
- [ ] Code is well-documented
- [ ] API documentation is updated
- [ ] README is updated if needed
- [ ] Changelog is updated
- [ ] Comments explain complex logic

## Security
- [ ] No sensitive data is exposed
- [ ] Input validation is implemented
- [ ] Authentication/authorization is correct
- [ ] No security vulnerabilities
- [ ] Data encryption is used where needed

## Performance
- [ ] No performance regressions
- [ ] Memory usage is optimized
- [ ] Network requests are efficient
- [ ] UI is responsive
- [ ] No unnecessary computations

## Accessibility
- [ ] UI is accessible
- [ ] Screen readers are supported
- [ ] Keyboard navigation works
- [ ] Color contrast is adequate
- [ ] Text scaling is supported
```

### **Code Review Process**
```dart
class CodeReviewProcess {
  static const List<String> requiredReviewers = [
    'tech-lead',
    'senior-developer',
  ];
  
  static const List<String> optionalReviewers = [
    'ui-ux-designer',
    'security-expert',
    'performance-expert',
  ];
  
  static Future<void> initiateReview(String pullRequestId) async {
    // Assign required reviewers
    await _assignReviewers(pullRequestId, requiredReviewers);
    
    // Request optional reviewers based on changes
    final changes = await _getChangedFiles(pullRequestId);
    final optionalReviewers = _getRelevantReviewers(changes);
    await _assignReviewers(pullRequestId, optionalReviewers);
    
    // Set up automated checks
    await _setupAutomatedChecks(pullRequestId);
  }
  
  static Future<List<String>> _getChangedFiles(String pullRequestId) async {
    // Implementation to get changed files
    return [];
  }
  
  static List<String> _getRelevantReviewers(List<String> changedFiles) {
    final reviewers = <String>[];
    
    for (final file in changedFiles) {
      if (file.contains('ui/') || file.contains('widgets/')) {
        reviewers.add('ui-ux-designer');
      }
      if (file.contains('auth/') || file.contains('security/')) {
        reviewers.add('security-expert');
      }
      if (file.contains('performance/') || file.contains('optimization/')) {
        reviewers.add('performance-expert');
      }
    }
    
    return reviewers.toSet().toList();
  }
  
  static Future<void> _setupAutomatedChecks(String pullRequestId) async {
    // Set up automated checks for the PR
    await _setupLintingChecks(pullRequestId);
    await _setupTestingChecks(pullRequestId);
    await _setupSecurityChecks(pullRequestId);
    await _setupPerformanceChecks(pullRequestId);
  }
}
```

## Governance Framework

### **Development Standards**
```dart
class DevelopmentStandards {
  static const Map<String, String> standards = {
    'code_style': 'Follow Dart/Flutter style guide',
    'naming_conventions': 'Use camelCase for variables and functions, PascalCase for classes',
    'documentation': 'Document all public APIs and complex logic',
    'testing': 'Maintain 80%+ test coverage',
    'performance': 'Follow performance budgets',
    'security': 'Follow security best practices',
    'accessibility': 'Follow WCAG 2.1 AA guidelines',
    'error_handling': 'Implement comprehensive error handling',
    'logging': 'Use structured logging',
    'monitoring': 'Implement observability',
  };
  
  static bool validateCompliance(Map<String, dynamic> code) {
    // Implementation to validate code compliance
    return true;
  }
}
```

### **Quality Gates**
```dart
class QualityGates {
  static const Map<String, dynamic> gates = {
    'test_coverage': 80.0,
    'performance_budget': {
      'app_startup': Duration(seconds: 3),
      'screen_load': Duration(milliseconds: 500),
      'api_response': Duration(seconds: 2),
    },
    'security_score': 95.0,
    'accessibility_score': 90.0,
    'code_quality_score': 85.0,
  };
  
  static bool validateQuality(Map<String, dynamic> metrics) {
    for (final entry in gates.entries) {
      final metric = metrics[entry.key];
      if (metric == null) return false;
      
      if (metric is double && entry.value is double) {
        if (metric < entry.value) return false;
      } else if (metric is Duration && entry.value is Duration) {
        if (metric > entry.value) return false;
      }
    }
    
    return true;
  }
}
```

This comprehensive developer experience and governance framework ensures consistent code quality, efficient development workflows, and adherence to healthcare-grade standards throughout the AI Doctor System development process.
