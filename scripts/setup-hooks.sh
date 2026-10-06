#!/usr/bin/env bash
# One-time setup: point git at the versioned hooks.
cd "$(git -C "$(dirname "$0")" rev-parse --show-toplevel)" && git config core.hooksPath .githooks && chmod +x .githooks/* scripts/*.sh && echo "hooks installed: pre-commit (structure), pre-push (smoke evals)"
