#!/bin/bash
# Dart2Cpp Sample Conversion Script
# This script demonstrates the full conversion pipeline:
#   Dart source -> Kernel (.dill) -> Lowered Dart -> Run

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$SCRIPT_DIR/src"
DART_OUT_DIR="$SCRIPT_DIR/dart"
CPP_OUT_DIR="$SCRIPT_DIR/cpp"

# Use in-repo dart SDK if available
DART_EXE="${DART_EXE:-dart}"
if [ -x "$PROJECT_DIR/../../../xcodebuild/DebugX64/dart-sdk/bin/dart" ]; then
  DART_EXE="$PROJECT_DIR/../../../xcodebuild/DebugX64/dart-sdk/bin/dart"
fi

echo "Dart2Cpp Conversion Pipeline"
echo "============================"
echo "Using Dart: $DART_EXE"
echo ""

# Check if source files exist
if [ ! -d "$SRC_DIR" ] || [ -z "$(ls -A "$SRC_DIR"/*.dart 2>/dev/null)" ]; then
  echo "Error: No .dart files found in $SRC_DIR"
  exit 1
fi

# Create output directories
mkdir -p "$DART_OUT_DIR"
mkdir -p "$CPP_OUT_DIR"

# Process each Dart source file
for dart_file in "$SRC_DIR"/*.dart; do
  basename=$(basename "$dart_file" .dart)
  echo "Processing: $basename.dart"
  echo "---"

  # Convert using the conversion tool
  lowered_file="$DART_OUT_DIR/${basename}_restored.dart"

  echo "  [1/2] Converting to lowered Dart..."
  if ! "$DART_EXE" run "$PROJECT_DIR/tool/convert_sample.dart" "$dart_file" "$lowered_file" 2>&1; then
    echo "  ✗ Conversion failed"
    continue
  fi

  if [ ! -f "$lowered_file" ] || [ ! -s "$lowered_file" ]; then
    echo "  ✗ Generated file is empty or missing"
    continue
  fi

  echo "  ✓ Generated: $lowered_file"

  # Run the converted code
  echo "  [2/2] Running converted code..."
  echo "  Output:"
  if "$DART_EXE" run "$lowered_file" 2>&1 | sed 's/^/    /'; then
    echo "  ✓ Execution successful"
  else
    echo "  ✗ Execution failed"
  fi

  echo ""
done

echo "Conversion complete!"
echo ""
echo "Output directories:"
echo "  Dart: $DART_OUT_DIR"
echo "  C++:  $CPP_OUT_DIR (manual conversion required)"
