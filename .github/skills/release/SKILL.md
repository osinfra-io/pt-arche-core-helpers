---
name: release
description: >
  Orchestrates the full pt-arche-core-helpers release cascade. Use when asked to release a
  new version of core-helpers, or to cascade arche module updates across the platform.
---

You are orchestrating the `pt-arche-core-helpers` release cascade across three phases. Complete each phase fully before starting the next — each phase depends on the previous one.

## Before You Start

Ask the user for the new version tag if they haven't provided it (format: `vMAJOR.MINOR.PATCH`, e.g. `v0.3.0`). Use `list_tags` (owner: `osinfra-io`, repo: `pt-arche-core-helpers`) to show them the current latest tag for reference.

---

## Phase 1 — Tag pt-arche-core-helpers

**Goal:** Push a tag on the current `main` of `pt-arche-core-helpers` and record its SHA. The `release.yml` workflow creates the GitHub release automatically.

1. Use `list_commits` (owner: `osinfra-io`, repo: `pt-arche-core-helpers`, sha: `main`, perPage: `1`) to get the current HEAD SHA. Record this as `CORE_SHA`.
2. Show the user the SHA and version, and ask them to confirm before proceeding.
3. Push the tag from inside the `pt-arche-core-helpers` working directory:
   ```bash
   git tag {VERSION}
   git push origin {VERSION}
   ```
4. Verify using `get_tag` (owner: `osinfra-io`, repo: `pt-arche-core-helpers`, tag: `{VERSION}`).
5. Confirm: "✅ Phase 1 complete — `pt-arche-core-helpers` tagged at `{CORE_SHA}` as `{VERSION}`."

---

## Phase 2 — Update arche module consumers

**Goal:** For each arche module that uses core-helpers, update its canonical `helpers.tofu`, open a PR, merge it, record the post-merge SHA, and create a release.

Process each module in the table below **in order**. Complete all steps for one module before moving to the next. Record every post-merge SHA — you will need them in Phase 3.

### Module table

| Repo | Canonical `helpers.tofu` | Notes |
|---|---|---|
| `pt-arche-datadog-google-integration` | `helpers.tofu` | Root-level file |
| `pt-arche-google-cloud-sql` | `regional/helpers.tofu` | Only subdirectory |
| `pt-arche-google-kubernetes-engine` | `shared/helpers.tofu` | `regional/` and `regional/onboarding/` are symlinks |
| `pt-arche-google-network` | `shared/helpers.tofu` | `regional/` and `regional/nat/` are symlinks |
| `pt-arche-google-project` | `helpers.tofu` | Root-level file |
| `pt-arche-kubernetes-cert-manager` | `shared/helpers.tofu` | `regional/` and `regional/istio-csr/` are symlinks |
| `pt-arche-kubernetes-datadog-operator` | `shared/helpers.tofu` | `regional/` and `regional/manifests/` are symlinks |
| `pt-arche-kubernetes-istio` | `shared/helpers.tofu` | `regional/` and `regional/manifests/` are symlinks |
| `pt-arche-kubernetes-opa-gatekeeper` | `shared/helpers.tofu` | `regional/` is a symlink |

### Steps for each module

1. **Read** the current canonical `helpers.tofu` using `get_file_contents` (owner: `osinfra-io`, repo: `{REPO}`, path: `{FILE}`). Note the current SHA and version comment.
2. **Create a branch** named `chore/update-core-helpers-{VERSION}` using `create_branch` (from_branch: `main`).
3. **Update the file**: in the file content, replace `ref=<old-sha>` with `ref={CORE_SHA}` and the inline version comment with `# {VERSION}`. Use `push_files` to commit it to the branch. Commit message: `Update core-helpers to {VERSION}`.
4. **Open a PR** using `create_pull_request`:
   - title: `Update core-helpers to {VERSION}`
   - head: `chore/update-core-helpers-{VERSION}`
   - base: `main`
   - body: `Updates \`pt-arche-core-helpers\` to [{VERSION}](https://github.com/osinfra-io/pt-arche-core-helpers/releases/tag/{VERSION}) (\`{CORE_SHA}\`).`
5. **Check CI**: use `pull_request_read` with method `get_check_runs`. If checks are pending, wait and re-check. If any check has failed, stop and tell the user before continuing.
6. **Merge** using `merge_pull_request` (merge_method: `squash`, commit_title: `Update core-helpers to {VERSION}`).
7. **Record post-merge SHA**: use `list_commits` (sha: `main`, perPage: `1`) immediately after merge. Record this as the module's SHA.
8. **Determine the new version tag**: use `list_tags` (owner: `osinfra-io`, repo: `{REPO}`) to show the current latest tag, then ask the user for the new version (or suggest a patch bump).
9. **Push the tag** from inside the `{REPO}` working directory:
   ```bash
   git tag {MODULE_VERSION}
   git push origin {MODULE_VERSION}
   ```
10. Verify with `get_tag` (owner: `osinfra-io`, repo: `{REPO}`, tag: `{MODULE_VERSION}`). Confirm: "✅ `{REPO}` → `{MODULE_SHA}` (`{MODULE_VERSION}`)".

### Also update pt-arche-child-module-template (no tag)

After completing all 9 modules above:

1. Read `skeleton/helpers.tofu` from `osinfra-io/pt-arche-child-module-template`.
2. Create branch `chore/update-core-helpers-{VERSION}`, update `ref=` to `{CORE_SHA}  # {VERSION}`.
3. Use `push_files`. Commit message: `Update core-helpers to {VERSION}`.
4. Open PR, check CI, merge. No tag needed for this repo.

---

## Phase 3 — Update consumers

**Goal:** Update `pt-corpus` and `pt-pneuma` to reference the new core-helpers SHA and all new post-merge arche module SHAs from Phase 2. Use one PR per consumer, with all file changes in a single `push_files` call.

Read all files first using `get_file_contents` for each, make all substitutions, then push everything in one commit.

### pt-corpus

**Branch:** `chore/arche-release-{VERSION}`

**Files and substitutions:**

| File | Update |
|---|---|
| `helpers.tofu` | core-helpers `ref=` → `{CORE_SHA}  # {VERSION}` |
| `regional/helpers.tofu` | core-helpers `ref=` → `{CORE_SHA}  # {VERSION}` |
| `main.tofu` | `pt-arche-datadog-google-integration` `ref=` → new SHA + version comment |
| `main.tofu` | `pt-arche-google-network` `ref=` → new SHA + version comment |
| `main.tofu` | `pt-arche-google-project` `ref=` → new SHA + version comment |
| `regional/main.tofu` | `pt-arche-google-network` `ref=` → new SHA + version comment |

> **Note:** `pt-arche-google-storage-bucket` is referenced in `main.tofu` but was not updated in Phase 2 — leave its `ref=` unchanged.

**PR title:** `Update arche modules for core-helpers {VERSION}`

**PR body:**
```
Updates all arche module references following the `pt-arche-core-helpers` {VERSION} release cascade.

- `pt-arche-core-helpers` → `{CORE_SHA}` ({VERSION})
- `pt-arche-datadog-google-integration` → `{SHA}` ({MODULE_VERSION})
- `pt-arche-google-network` → `{SHA}` ({MODULE_VERSION})
- `pt-arche-google-project` → `{SHA}` ({MODULE_VERSION})
```

Check CI, then merge with squash. Commit title: `Update arche modules for core-helpers {VERSION}`. No tag needed for pt-corpus.
