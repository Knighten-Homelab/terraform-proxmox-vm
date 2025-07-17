# Terraform Proxmox VM Module - Remaining Tasks

## Current Status

**Completed Tasks:**
- ✅ Documentation fixes and validation
- ✅ Input validation implementation
- ✅ Static IP configuration logic
- ✅ Provider version upgrade (v3.0.2)
- ✅ Optional DNS record creation
- ✅ Configurable DNS TTL

**Remaining Tasks:**

## 1. Streamline Pre-commit Hook

**Priority: High**
**Branch: `feat/streamline-pre-commit`**

**Files to modify:**
- `.husky/pre-commit` - Replace slow Trivy scan with fast terraform checks

**Current Issues:**
- Pre-commit hook is too slow (runs Trivy security scan on every commit)
- Missing `tflint` binary check causes failures if not installed

**Proposed Solution:**
```bash
set -e

# Only run fast, essential checks
terraform fmt -check -recursive
terraform validate -no-color
```

**Benefits:**
- Faster local development (from ~30s to ~3s)
- No external tool dependencies
- Security scans moved to CI where they belong

## 2. Replace Release Workflow with Reusable Version

**Priority: Medium**
**Branch: `feat/reusable-release-workflow`**

**Files to modify:**
- `.github/workflows/push-main-release.yml` - Replace with reusable workflow

**Current Issue:**
- Semantic-release dependencies duplicated in package.json and GitHub Actions
- Workflow maintenance scattered across multiple repos

**Proposed Solution:**
```yaml
---
name: Push On Main - Release
run-name: Release for Push on ${{ github.ref_name }} ${{ github.run_number }}

on:
  push:
    branches:
      - main
    paths-ignore:
      - 'CHANGELOG.md'

jobs:
  github-release:
    uses: Knighten-Homelab/gha-reusable-workflows/.github/workflows/semantic-release-to-gh.yaml@main
    with:
      runs-on: ubuntu-latest
    secrets:
      GITHUB_TOKEN: ${{ secrets.RELEASE_PAT }}
```

**Benefits:**
- Centralized workflow maintenance
- Consistent release process across homelab projects
- Eliminates duplicate semantic-release configuration

## 3. Replace PR Workflow with Reusable Version

**Priority: Medium**
**Branch: `feat/reusable-pr-workflow`**

**Files to modify:**
- `.github/workflows/pr-open-tf-lint-and-scan.yml` - Replace with reusable workflow

**Current Issue:**
- PR validation duplicates pre-commit checks
- Workflow maintenance scattered across multiple repos

**Proposed Solution:**
```yaml
---
name: PR Opened - Lint and Test Terraform Changes
run-name: Terraform Change Detected In PR ${{ github.event.number }} on ${{ github.head_ref }} - Lint and Test

on:
  pull_request:
    types:
      - opened
      - reopened
      - synchronize

jobs:
  terraform-validation:
    uses: Knighten-Homelab/gha-reusable-workflows/.github/workflows/terraform-lint-and-security-scan.yaml@main
    with:
      runs-on: ubuntu-latest
      infra-directory: ./
```

**Benefits:**
- Centralized workflow maintenance
- Comprehensive security scanning in CI
- Consistent validation across homelab projects

## 4. Clean up Package.json Dependencies

**Priority: Low**
**Branch: `feat/cleanup-package-json`**

**Files to modify:**
- `package.json` - Remove semantic-release dependencies

**Current Issue:**
- Semantic-release dependencies duplicated in package.json and GitHub Actions
- Unnecessary package.json complexity

**Dependencies to Remove:**
- `@semantic-release/changelog`
- `@semantic-release/commit-analyzer`
- `@semantic-release/git`
- `@semantic-release/github`
- `conventional-changelog-conventionalcommits`
- `semantic-release`
- `pre-commit-gha` script

**Dependencies to Keep:**
- `@commitlint/cli`
- `@commitlint/config-conventional`
- `husky`

**Benefits:**
- Reduced package.json complexity
- Faster npm install
- Eliminate duplicate configuration

## 5. Update CLAUDE.md Development Commands

**Priority: Low**
**Branch: `feat/update-claude-md-commands`**

**Files to modify:**
- `CLAUDE.md` - Update development commands section

**Current Issue:**
- Documentation doesn't match new streamlined workflow

**Proposed Update:**
```bash
# Local development
npm run prepare  # Sets up husky hooks
terraform fmt
terraform validate

# CI/CD handles comprehensive linting and security scanning
```

**Benefits:**
- Accurate documentation
- Clear guidance for contributors

## 6. Add PR Workflow Path Filters

**Priority: Low**
**Branch: `feat/pr-workflow-path-filters`**

**Files to modify:**
- `.github/workflows/pr-open-tf-lint-and-scan.yml` - Add path filters

**Current Issue:**
- Workflow runs on all PR changes, even for non-Terraform files
- Wastes CI resources on documentation-only changes

**Proposed Solution:**
```yaml
on:
  pull_request:
    types:
      - opened
      - reopened
      - synchronize
    paths:
      - '**.tf'
      - '**.hcl'
      - '.terraform.lock.hcl'
      - '.github/workflows/pr-open-tf-lint-and-scan.yml'
```

**Benefits:**
- Only runs Terraform validation when Terraform files are changed
- Reduces unnecessary CI runs for documentation changes
- Saves compute resources and faster feedback for relevant changes

## Implementation Notes

**Task Independence:**
- Each task can be implemented in any order
- No dependencies between tasks
- Each task touches different files (except Task 3 & 6 both modify PR workflow)

**Testing Strategy:**
- **Task 1**: Test pre-commit hook with valid/invalid Terraform code
- **Task 2**: Verify release workflow still functions after merge to main
- **Task 3**: Verify PR workflow triggers correctly on test PRs
- **Task 4**: Ensure npm install works and commit-msg hook still functions
- **Task 5**: Documentation review only
- **Task 6**: Test that workflow only runs on Terraform file changes

**Recommended Implementation Order:**
1. Task 1 (High impact on developer experience)
2. Task 4 (Enables Task 2 cleanup)
3. Task 2 (Release workflow)
4. Task 3 (PR workflow)
5. Task 6 (Can be combined with Task 3)
6. Task 5 (Documentation update)