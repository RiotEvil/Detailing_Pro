# Project Guidelines

## Mission

Ship stable Flutter features with measurable user value, predictable behavior, and safe data handling.

## Multi-Agent Workflow

- For non-trivial changes, run App Council Orchestrator first to collect multiple viewpoints.
- Implement only after consensus recommendations are clear.
- For release-sensitive changes (auth, roles, Firestore rules, sync, payments, notifications), require Release Arbiter sign-off.

## Quality Gates

- Reliability: no unhandled failure path in changed code; edge cases are explicitly handled.
- Security/Privacy: access checks and sensitive data handling reviewed for least privilege.
- UX/Product: user flow has clear states (loading, empty, error, success).
- Performance: avoid unnecessary rebuilds and expensive operations in hot paths.

## Build and Test Expectations

- Prefer targeted checks first (affected tests/files), then broader checks as needed.
- If tests are skipped, explain why and list residual risks.

## Change Discipline

- Prefer minimal, focused diffs over broad rewrites.
- Do not add dependencies unless there is a clear need and impact explanation.
- Do not modify generated files unless explicitly requested.
