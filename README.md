# <img align="left" width="45" height="45" src="https://github.com/user-attachments/assets/7a8da619-5b2c-4ad0-a8be-e1eded7e7061"> OpenTofu Core - Helpers OpenTofu Module

[![OpenTofu Tests](https://img.shields.io/github/actions/workflow/status/osinfra-io/pt-arche-core-helpers/test.yml?style=for-the-badge&logo=opentofu&color=FEDA15&label=OpenTofu%20Tests)](https://github.com/osinfra-io/pt-arche-core-helpers/actions/workflows/test.yml) [![Dependabot](https://img.shields.io/github/actions/workflow/status/osinfra-io/pt-arche-core-helpers/dependabot.yml?style=for-the-badge&logo=github&color=2088FF&label=Dependabot)](https://github.com/osinfra-io/pt-arche-core-helpers/actions/workflows/dependabot.yml)

## Repository Description

OpenTofu **example** module for helpers that provides core platform functionality including workspace parsing, resource labeling, and logos integration for team and project management.

**Core Features:**

- **Workspace Parsing**: Extracts environment, region, and zone from structured workspace names
- **Resource Labels**: Generates consistent labels for resource tagging and organization
- **Logos Integration**: Connects to logos remote state for team data, project naming, and folder IDs
- **Multi-Workspace Support**: Aggregates team data across multiple logos workspaces

> [!NOTE]
> We do not recommend consuming this module like you might a [public module](https://search.opentofu.org). It is a baseline, something you can fork, potentially maintain, and modify to fit your organization's needs. Using public modules vs. writing your own has various [drivers and trade-offs](https://docs.osinfra.io/fundamentals/architecture-decision-records/adr-0003) that your organization should evaluate.

## 🔩 Usage

### Basic Usage (Workspace Parsing Only)

```hcl
module "helpers" {
  source = "github.com/osinfra-io/pt-arche-core-helpers//root"

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

### With Logos Integration

```hcl
module "helpers" {
  source = "github.com/osinfra-io/pt-arche-core-helpers//root"

  cost_center         = "x001"
  data_classification = "public"
  repository          = "my-repository"
  team                = "my-team"

  # Enable logos integration
  logos_workspaces = ["my-team-main-production", "logos-main-production"]
}

# Access logos-integrated outputs
output "project_naming" {
  value = module.helpers.project_naming
}

output "environment_folder_id" {
  value = module.helpers.environment_folder_id
}

output "teams" {
  value = module.helpers.teams
}
```

> [!TIP]
> You can check the [tests/fixtures](tests/fixtures) directory for example configurations. These fixtures set up the system for testing by providing all the necessary initial code, thus creating good examples on which to base your configurations.

## <img align="left" width="35" height="35" src="https://github.com/osinfra-io/github-organization-management/assets/1610100/39d6ae3b-ccc2-42db-92f1-276a5bc54e65"> Development

Our focus is on the core fundamental practice of platform engineering, Infrastructure as Code.

>Open Source Infrastructure (as Code) is a development model for infrastructure that focuses on open collaboration and applying relative lessons learned from software development practices that organizations can use internally at scale. - [Open Source Infrastructure (as Code)](https://www.osinfra.io)

To avoid slowing down stream-aligned teams, we want to open up the possibility for contributions. The Open Source Infrastructure (as Code) model allows team members external to the platform team to contribute with only a slight increase in cognitive load. This section is for developers who want to contribute to this repository, describing the tools used, the skills, and the knowledge required, along with OpenTofu documentation.

See the [documentation](https://docs.osinfra.io/fundamentals/development-setup) for setting up a local development environment.

### 🛠️ Tools

- [osinfra-pre-commit-hooks](https://github.com/osinfra-io/pt-techne-pre-commit-hooks)
- [pre-commit](https://github.com/pre-commit/pre-commit)

### 📋 Skills and Knowledge

Links to documentation and other resources required to develop and iterate in this repository successfully.

- [opentofu](https://opentofu.org/docs)
  - [workspace-interpolation](https://opentofu.org/docs/language/state/workspaces#current-workspace-interpolation)

### 🔍 Tests

All tests are [mocked](https://opentofu.org/docs/cli/commands/test/#the-mock_provider-blocks) allowing us to test the module without creating infrastructure or requiring credentials. The trade-offs are acceptable in favor of speed and simplicity. In an OpenTofu test, a mocked provider or resource will generate fake data for all computed attributes that would normally be provided by the underlying provider APIs.

```none
tofu init
```

```none
tofu test
```

### 📦 Release

To release a new version, simply push a new tag to the repository. The tag should be in the format `vX.Y.Z` where `X`, `Y`, and `Z` are integers.

```none
git tag vX.Y.Z
git push origin vX.Y.Z
```
