# pt-arche-core-helpers

Foundational helper module invoked by all other platform modules. Has two entry points:

- `//child` — used by Arche child modules; provides `env`, `environment`, `region`, `zone`, `labels`
- `//` (root) — used by root modules (Logos, Corpus, Pneuma); provides the full set including `project_naming`, `team`, `teams`, `environment_folder_id`
