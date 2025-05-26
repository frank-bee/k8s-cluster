#!/bin/bash
# Script to check for secrets and credentials in git commits
# This script will fail if it finds potential secrets in staged files

echo "Checking for secrets and credentials..."

# Flag to track if sensitive data was found
SENSITIVE_DATA_FOUND=0

# Files to exclude from checks (relative to repo root)
EXCLUDE_FILES=(
  ".pre-commit-config.yaml"
  "README.md"
  "scripts/check-secrets.sh"
  "scripts/check-personal-info.sh"
  "scripts/install-hooks.sh"
)

# Check if a file should be excluded
function is_excluded() {
  local file="$1"
  for excluded in "${EXCLUDE_FILES[@]}"; do
    if [[ "$file" == *"$excluded"* ]]; then
      return 0
    fi
  done
  return 1
}

# Check each staged file for sensitive information
for FILE in $(git diff --cached --name-only); do
  # Skip binary files
  if file "$FILE" | grep -q "binary"; then
    continue
  fi

  # Skip excluded files
  if is_excluded "$FILE"; then
    continue
  fi

  # Look for actual credential values (not just variable names)
  # Check for high-confidence patterns that indicate real secrets/credentials

  # Check for long alphanumeric strings that look like access tokens (at least 20 chars)
  if grep -q -E "['\"][0-9a-zA-Z_\-]{20,}['\"]" "$FILE"; then
    echo "Potential access token or API key found in $FILE"
    SENSITIVE_DATA_FOUND=1
  fi

  # Check for AWS keys - specific format
  if grep -q -E "AKIA[0-9A-Z]{16}" "$FILE"; then
    echo "AWS access key found in $FILE"
    SENSITIVE_DATA_FOUND=1
  fi

  # Check for private keys
  if grep -q "BEGIN.*PRIVATE KEY" "$FILE"; then
    echo "Private key found in $FILE"
    SENSITIVE_DATA_FOUND=1
  fi

  # More specific check for password/token assignments with actual values
  if grep -q -E "(password|passwd|pwd|secret|token|apikey|api_key|access_key|accesskey)['\"]?\s*[=:]\s*['\"][^'\"><]+['\"]" "$FILE"; then
    echo "Credential value found in $FILE"
    SENSITIVE_DATA_FOUND=1
  fi

  # Check for base64 encoded secrets in Kubernetes Secret objects
  if [[ "$FILE" == *.y*ml ]] && grep -q "kind: Secret" "$FILE"; then
    # Only flag if the Secret has actual data values, not just the resource definition
    if grep -q -A5 "data:" "$FILE" | grep -q -E "[a-zA-Z0-9+/]{20,}=="; then
      echo "Kubernetes Secret with data found in $FILE"
      SENSITIVE_DATA_FOUND=1
    fi
  fi
done

if [ $SENSITIVE_DATA_FOUND -eq 1 ]; then
  echo "❌ Commit ABORTED! Sensitive information detected in your changes!"
  echo "Please remove or redact the sensitive information before committing."
  echo "If this is a false positive, you can bypass this check with: git commit --no-verify"
  exit 1
else
  echo "✅ No secrets or credentials detected."
  exit 0
fi
