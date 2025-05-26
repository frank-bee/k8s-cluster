#!/bin/bash

# Script to install pre-commit hooks for the k8s-cluster repository
# This script installs and sets up pre-commit hooks to prevent sensitive information from being committed

set -e

echo "Installing pre-commit hooks for secure Git workflow..."

# Check if pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo "pre-commit not found, attempting to install..."
    if command -v pip3 &> /dev/null; then
        pip3 install pre-commit
    elif command -v pip &> /dev/null; then
        pip install pre-commit
    elif command -v brew &> /dev/null; then
        brew install pre-commit
    else
        echo "Error: Could not find pip, pip3, or brew to install pre-commit."
        echo "Please install pre-commit manually: https://pre-commit.com/#installation"
        exit 1
    fi
fi

# Check if gitleaks is installed (required by our hooks)
if ! command -v gitleaks &> /dev/null; then
    echo "gitleaks not found, attempting to install..."
    if command -v brew &> /dev/null; then
        brew install gitleaks
    else
        echo "Warning: Could not find brew to install gitleaks."
        echo "Please install gitleaks manually: https://github.com/gitleaks/gitleaks#installing"
        echo "Continuing installation without gitleaks..."
    fi
fi

# Install the pre-commit hooks
echo "Setting up pre-commit hooks..."
cd "$(git rev-parse --show-toplevel)" || exit 1
pre-commit install

# Initialize pre-commit
pre-commit install-hooks

echo "✅ Pre-commit hooks successfully installed!"
echo "Your Git commits will now be checked for sensitive information such as:"
echo "  - Passwords and secrets"
echo "  - API keys and tokens"
echo "  - Email addresses"
echo "  - Private keys"
echo "  - Kubernetes secrets"
echo "  - Personal identifiers and domains"
echo
echo "Run the hooks manually on all files: pre-commit run --all-files"
