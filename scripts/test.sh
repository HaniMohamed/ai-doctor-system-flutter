#!/usr/bin/env bash
set -euo pipefail

flutter pub get
flutter test --coverage

