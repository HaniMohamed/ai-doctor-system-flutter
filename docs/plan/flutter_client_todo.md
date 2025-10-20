---
title: "Flutter Client Build TODOs - Infrastructure → Deployment"
updated: "2025-10-20"
tags: ["planning", "implementation", "flutter", "ai-doctor-system"]
summary: "Actionable end-to-end checklist for building the Flutter client following the project docs (architecture, modular structure, observability, testing, CI/CD)."
---

# Flutter Client Build TODOs (Infrastructure → Deployment)

> Single-source-of-truth implementation checklist aligned with: `docs/architecture/high_level_architecture.md`, `docs/architecture/modular_project_stracture.md`, `docs/architecture/observability_slos.md`, `docs/testing/testing_strategy.md`, `docs/deployment/cicd_release_plan.md`, `docs/security/auth_and_privacy.md`, and `docs/uiux/design_system.md`.

## 0. Repo & Project Bootstrap
- [ ] Initialize Flutter project `ai_doctor_flutter` (mobile + web)
- [ ] Configure `pubspec.yaml` with baseline deps (get, dio, websocket, sqflite, flutter_secure_storage)
- [ ] Add `analysis_options.yaml` with agreed lint rules
- [ ] Set up `.gitignore`, `README.md`, `CHANGELOG.md`, `LICENSE`
- [ ] Create `scripts/` (`build.sh`, `test.sh`, `deploy.sh`)
- [ ] Configure Dart format and code metrics in CI

## 1. Core Infrastructure (App Shell)
- [ ] Scaffold folder structure exactly as `modular_project_stracture.md`
- [ ] Create `lib/main.dart`, `lib/app.dart`, and `lib/routes/` with GetX navigation
- [ ] Implement `lib/core/di/service_locator.dart` and `injection_container.dart`
- [ ] Implement `lib/core/network/api_client.dart` with token injection and interceptors
- [ ] Implement `lib/core/network/interceptors/{auth,error,logging}_interceptor.dart`
- [ ] Implement `lib/core/network/websocket/{websocket_client,websocket_manager,message_handler}.dart`
- [ ] Implement `lib/core/storage/{local_storage,secure_storage,cache_manager}.dart`
- [ ] Implement `lib/core/errors/{exceptions,failures,error_handler}.dart`
- [ ] Implement `lib/core/constants/{api_constants,app_constants,storage_keys,theme_constants}.dart`
- [ ] Implement `lib/core/utils/{validators,formatters,extensions,logger,platform_utils}.dart`
- [ ] Implement `lib/core/theme/{app_theme,color_scheme,text_theme,component_theme}.dart`

## 2. Environment & Configuration
- [ ] Implement `EnvironmentConfig` (apiBaseUrl, websocketUrl, flags) with `--dart-define=ENV`
- [ ] Set up `assets/` with placeholders (images, fonts, animations)
- [ ] Configure flavors/profiles for development, testing, staging, production

## 3. Security Foundations
- [ ] Implement `SecureHttpClient` with certificate pinning
- [ ] Implement `EncryptionService` for data-at-rest (AES-256-GCM) per docs
- [ ] Enforce input validation utilities and secure form handling
- [ ] Add auth token lifecycle handling and secure storage
- [ ] Add role/tenant-aware guards in `routes/route_middleware.dart`

## 4. Observability & Monitoring (Client-side)
- [ ] Implement `PerformanceMetrics` and `BusinessMetrics` collection
- [ ] Implement `TracingService` and `PerformanceTracer`
- [ ] Implement `AlertManager` scaffolding to forward to backend/3rd party
- [ ] Implement `HealthCheckService` client probes (API, WS, storage, AI)
- [ ] Add `APMService` hooks in key flows (screen time, API calls)
- [ ] Add `SLOManager` data models/stream + `SLODashboard` UI (behind dev flag)

## 5. Shared Services & UI
- [ ] Implement shared services (`connectivity_service`, `permission_service`, `location_service`, `image_picker_service`, `notification_service`)
- [ ] Implement shared models (`api_response`, `paginated_response`, `error_response`, `base_entity`)
- [ ] Implement shared widgets (loading, error, empty state, inputs, dialogs, navigation, animations)

## 6. Authentication Module (`lib/features/auth`)
- [ ] Data sources: remote/local
- [ ] Models: user, auth_tokens, login_request
- [ ] Repository + interface
- [ ] Use cases: login, logout, refresh token, get current user
- [ ] Presentation: pages (login, register, forgot), controllers, widgets, binding
- [ ] Biometric auth integration (platform conditional)

## 7. Profile Module (`lib/features/profile`)
- [ ] Data sources, models (user_profile, organization)
- [ ] Repository + interface
- [ ] Use cases: get/update profile, upload profile image
- [ ] Presentation: pages (profile, edit, settings), controller, widgets, binding

## 8. Dashboard Module (`lib/features/dashboard`)
- [ ] Data sources, models (stats, recent_activity)
- [ ] Repository + interface
- [ ] Use cases: get_dashboard_stats, get_recent_activity
- [ ] Presentation: pages (dashboard, stats_overview), controller, widgets, binding

## 9. AI Services Modules (`lib/features/ai_services`)
- [ ] Symptom Checker: full data/domain/presentation per structure
- [ ] Doctor Recommendations: data/domain/presentation
- [ ] Booking Assistant: data/domain/presentation (+ NLP prompts integration via backend)
- [ ] Semantic Search: data/domain/presentation
- [ ] Time Slot Suggestions: data/domain/presentation
- [ ] FAQ Assistant: data/domain/presentation
- [ ] Consultation Summary: data/domain/presentation
- [ ] Patient History: data/domain/presentation
- [ ] Prescription OCR: data/domain/presentation
- [ ] Lab Report: data/domain/presentation
- [ ] Wire to backend REST/WS endpoints and message schemas

## 10. Healthcare Core Modules
- [ ] Appointments: data/domain/presentation (list, details, create, calendar)
- [ ] Doctors: data/domain/presentation (list, search, details)
- [ ] Patients: data/domain/presentation (profile, history, prescriptions)
- [ ] Notifications: data/domain/presentation (list, settings)

## 11. Real-time & Offline
- [ ] WebSocket client with auth query param and reconnect/backoff
- [ ] Message routing and handlers for AI chat/streams
- [ ] Offline-first caching for key flows (appointments, doctors, messages)
- [ ] Conflict resolution and sync strategy hooks

## 12. Multi-Tenancy & Access Control
- [ ] `BaseEntity` with `organizationId` propagation
- [ ] Repositories accept/derive tenant context via `AuthService`
- [ ] Route guards for role + tenant scopes
- [ ] Multi-tenant local cache segmentation

## 13. UI/UX & Design System
- [ ] Implement design tokens and themes per `design_system.md`
- [ ] Page templates (lists, details, forms, dashboards) with accessibility
- [ ] Animations (fade, slide, scale) applied to transitions and key widgets
- [ ] Responsive layouts for mobile/web

## 14. Testing Strategy (per `testing_strategy.md`)
- [ ] Unit tests (~70%): core utils, repositories, use cases
- [ ] Widget tests (~20%): key pages/forms/widgets
- [ ] Integration tests (~10%): auth flow, appointment flow, ai services flow
- [ ] Contract tests: REST/WS payloads (schemas, happy/error paths)
- [ ] Mocks/fixtures utilities; golden tests for critical UI
- [ ] Coverage reporting and quality gates wired to CI

## 15. Performance & Accessibility
- [ ] Image optimization service and usage
- [ ] Caching strategy for data and images
- [ ] Performance tracing on startup and heavy screens
- [ ] 60fps animation targets; memory usage thresholds
- [ ] Accessibility: screen readers, keyboard nav (web), high contrast, text scaling

## 16. CI/CD (per `cicd_release_plan.md`)
- [ ] Git flow branches and protection rules
- [ ] Workflows: quality-security, test-suite, build-package, build-environments, deploy
- [ ] CodeQL/SAST and dependency audit
- [ ] Coverage upload to Codecov
- [ ] Build Android (APK/AAB), iOS (IPA no-codesign), Web bundle
- [ ] Environment builds via `--dart-define=ENV`
- [ ] Artifacts upload and notifications

## 17. Deployment & Release
- [ ] Staging deploy job + smoke tests
- [ ] Production deploy job + health checks
- [ ] ReleaseManager utilities (version bump, changelog, notes, tags)
- [ ] RollbackManager utilities and smoke/health verification
- [ ] Post-deploy monitoring hooks

## 18. Documentation
- [ ] Update `README.md` with setup, run, build, test, deploy
- [ ] API/contract notes under `docs/api/` (if needed)
- [ ] User guides for key flows under `docs/user_guides/`

---

### Milestones
- M1: Core infrastructure, security, environment config
- M2: Auth, Profile, Dashboard
- M3: Healthcare core (Appointments, Doctors, Patients)
- M4: AI services (Symptom Checker + 2 more), real-time & offline
- M5: Testing, performance, accessibility, observability
- M6: CI/CD pipelines, build matrix, staging deploy
- M7: Production readiness, release/rollback playbooks, docs


