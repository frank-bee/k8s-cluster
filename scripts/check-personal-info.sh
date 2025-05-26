#!/bin/bash
# Script to check for personal information in git commits
# This script will fail if it finds email addresses or specific domain names

echo "Checking for personal information..."

# Flag to track if personal info was found
PERSONAL_INFO_FOUND=0

# Personal domains to check for - edit this list as needed
PERSONAL_DOMAINS="dreambeez\.com|myfritz\.net"

# Check each staged file for personal information
for FILE in $(git diff --cached --name-only); do
  # Skip binary files
  if file "$FILE" | grep -q "binary"; then
    continue
  fi

  # Check for email addresses
  if grep -q -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "$FILE"; then
    echo "Email address found in $FILE:"
    grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "$FILE"
    PERSONAL_INFO_FOUND=1
  fi

  # Check for personal domains
  if grep -q -E "$PERSONAL_DOMAINS" "$FILE"; then
    echo "Personal domain found in $FILE:"
    grep -E "$PERSONAL_DOMAINS" "$FILE"
    PERSONAL_INFO_FOUND=1
  fi
done

if [ $PERSONAL_INFO_FOUND -eq 1 ]; then
  echo "❌ Commit ABORTED! Personal information detected in your changes!"
  echo "Please redact email addresses and personal domains before committing."
  echo "Tip: Consider using placeholders like '<email-redacted>' or '*domain-redacted*'"
  exit 1
else
  echo "✅ No personal information detected."
  exit 0
fi
