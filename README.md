# OpenTofu Core - Helpers OpenTofu Module

[![OpenTofu Tests](https://img.shields.io/github/actions/workflow/status/osinfra-io/pt-arche-core-helpers/test.yml?style=for-the-badge&logo=opentofu&color=FEDA15&label=OpenTofu%20Tests)](https://github.com/osinfra-io/pt-arche-core-helpers/actions/workflows/test.yml) [![Dependabot](https://img.shields.io/github/actions/workflow/status/osinfra-io/pt-arche-core-helpers/dependabot.yml?style=for-the-badge&logo=github&color=2088FF&label=Dependabot)](https://github.com/osinfra-io/pt-arche-core-helpers/actions/workflows/dependabot.yml) [![Datadog Security Enabled](https://img.shields.io/badge/Datadog%20Security-Enabled-632CA6?style=for-the-badge&logo=datadog)](https://app.datadoghq.com/security/code-security/repositories?repository_id=pt-arche-core-helpers)

## Repository Description

Reusable OpenTofu child module for helpers that provides core platform functionality including workspace parsing, resource labeling, and logos integration for team and project management.

It parses platform workspace names, generates standard resource labels, and optionally reads Logos remote state for team, project-naming, and environment-folder data.

## 🔩 Usage

### Module interfaces

| Source path | Purpose | Interface |
| --- | --- | --- |
| `//child` | Workspace parsing for Arche child modules. | Optional test-only [`workspace`](shared/helpers.tofu) input; outputs `env`, `environment`, `region`, and `zone` are defined in the same file. |
| `//root` | Workspace parsing, standard labels, and optional Logos state aggregation for root modules. | [`variables.tofu`](root/variables.tofu) · [`outputs.tofu`](root/outputs.tofu) |

Both entry points recognize the platform `sandbox`, `non-production`, and `production` workspace suffixes and only the `us-east1` and `us-east4` regions. The `//root` entry point requires repository, team, cost-center, and data-classification metadata; Logos-derived outputs are populated when `logos_workspaces` is supplied. Remote state access therefore requires the consumer to have access to the configured Logos state backends.

### Root module example

```hcl
module "helpers" {
  source = "github.com/osinfra-io/pt-arche-core-helpers//root?ref=<commit_sha>" # vX.Y.Z

  cost_center         = "x001"
  data_classification = "public"
  repository          = "my-repository"
  team                = "my-team"
}

# Access workspace parsing outputs
output "environment" {
  value = module.helpers.environment
}

output "labels" {
  value = module.helpers.labels
}
```

> [!TIP]
> You can check the [tests/fixtures](tests/fixtures) directory for example configurations. These fixtures set up the system for testing by providing all the necessary initial code, thus creating good examples on which to base your configurations.

## 🛠️ Tools

- [osinfra-pre-commit-hooks](https://github.com/osinfra-io/pt-techne-pre-commit-hooks)
- [pre-commit](https://github.com/pre-commit/pre-commit)

## 📋 Skills and Knowledge

- [opentofu](https://opentofu.org/docs)
  - [workspace-interpolation](https://opentofu.org/docs/language/state/workspaces#current-workspace-interpolation)

## 🔍 Tests

Tests use [mocked providers](https://opentofu.org/docs/cli/commands/test/#the-mock_provider-blocks); no infrastructure or credentials are required.

```none
tofu init
```

```none
tofu test
```

## 📦 Release

To release a new version, simply push a new tag to the repository. The tag should be in the format `vX.Y.Z` where `X`, `Y`, and `Z` are integers.

```none
git tag vX.Y.Z
git push origin vX.Y.Z
```
