#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT=${1:-development}
flutter pub get
flutter build apk --release --dart-define=ENV=${ENVIRONMENT}

