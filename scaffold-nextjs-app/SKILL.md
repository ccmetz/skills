---
name: scaffold-nextjs-app
description: Scaffolds a minimal Next.js app with current compatible dependencies, Tailwind CSS, preserved Oxlint and Oxfmt settings, Vitest, Husky checks, and a Docker development and production setup. Use when starting a greenfield Next.js project with this toolchain or explicitly applying this starter workflow.
---

# Scaffold a Next.js app

Create a small, working starter app. Keep the work limited to the requested setup; include the Docker baseline described below, but do not add authentication, application database access, component libraries, CI pipelines, deployment to a hosting service, or other product features.

## Choose versions and scaffold

- Read the project's instructions, README, package files, and Git status first. Preserve existing comments, README context, and user changes.
- Use the existing package manager; default to npm for a new project with no preference.
- Check the official docs and registry when running this skill. Use current stable releases rather than prereleases or the versions from a previous project. Honor an explicitly requested Next.js version.
- Check Node.js requirements and peer dependencies. Match `@types/node` to the intended Node runtime major, using the installed runtime if none is specified. Do not install types for a newer runtime solely because they have the highest version number.
- Use the official [create-next-app CLI](https://nextjs.org/docs/app/api-reference/cli/create-next-app), with TypeScript, App Router, Tailwind, and no scaffolded linter. Check its current `--help` before choosing flags. Prefer an empty template that renders hello world.
- Make choices explicit so saved CLI preferences do not change the result. Skip optional agent feedback and agent instruction files unless requested.
- If an existing README prevents scaffolding in place, generate in a temporary directory and copy only the needed app files into the repository. Preserve the README and Git repository; do not initialize another Git repository or create a commit.
- Check the scaffold's actual versions. Upgrade TypeScript and the other dependencies to the latest compatible stable releases, even if the template uses an older major. Update the lockfile with the package manager.

## Configure the toolchain

### Tailwind

Keep the integration supplied by the selected Next.js scaffold if it works. Otherwise follow the current [Tailwind Next.js guide](https://tailwindcss.com/docs/installation/framework-guides/nextjs). Do not add a second CSS integration alongside the first. Import Tailwind in the global CSS, load that CSS from the root layout, and use utility classes on the home page.

### Oxlint

Install `oxlint` as a development dependency. For a new project, copy [assets/.oxlintrc.json](assets/.oxlintrc.json) to the project root. This preserves the `eslint`, `typescript`, `unicorn`, `oxc`, `react`, and `nextjs` plugins, default rule categories, local schema, and generated-file exclusions from the source project.

If the target already has an Oxlint config, preserve its rules, plugins, settings, overrides, and ignores. Merge only missing starter settings instead of replacing the file. Explicit plugin lists replace the default plugins; do not remove the bundled plugins or silently enable extra plugins or categories during an upgrade. Check the [plugin documentation](https://oxc.rs/docs/guide/usage/linter/plugins) for compatibility and report any necessary migration.

### Oxfmt

Install `oxfmt` as a development dependency. For a new project, copy [assets/.oxfmtrc.json](assets/.oxfmtrc.json) to the project root. Preserve these chosen settings: single quotes, LF line endings, spaces instead of tabs, and a print width of 100, plus the local schema and generated-file exclusions. Leave unspecified format options at their defaults.

If the target already has an Oxfmt config, keep its chosen values and other options; add only missing starter settings. Do not reset to an empty or generated default config. Do not enable import or Tailwind sorting unless requested. See [Oxfmt configuration](https://oxc.rs/docs/guide/usage/formatter/config) for compatibility. Explicit user instructions take precedence over the bundled templates.

### Vitest

Set up Vitest for unit and React component tests using [references/vitest.md](references/vitest.md). Read that reference during scaffolding; it covers dependencies, config, DOM matchers and cleanup, test scripts, and a meaningful starter test. Preserve the Oxlint and Oxfmt configs while adding test tooling.

### Husky and scripts

Install `husky` as a development dependency and follow its current [initialization guide](https://typicode.github.io/husky/get-started.html). Preserve existing hooks and lifecycle scripts when adapting an existing project.

Add these scripts alongside the scaffold's `dev`, `build`, and `start` scripts:

```json
{
  "lint": "oxlint",
  "format": "oxfmt",
  "format:check": "oxfmt --check",
  "typecheck": "next typegen && tsc --noEmit",
  "prepare": "husky"
}
```

Set `.husky/pre-commit` to run:

```sh
npm run lint && npm run format:check && npm run typecheck
```

Adapt commands for another package manager. The hook must stop on failure. Check formatting without rewriting or restaging files during a commit; keep the separate `format` command for fixes. Generate Next.js route types before checking TypeScript so the check also works on a fresh clone.

## Docker development and production

Use [references/docker.md](references/docker.md) and the bundled [Docker templates](assets/docker/) when scaffolding this starter. They preserve the user's preferred npm multistage build, standalone production runtime, PostgreSQL service, development and production Compose profiles, localhost ports, named volumes, helper scripts, and [env.example](assets/docker/env.example). Adapt project names and runtime versions, preserve existing project customizations, and validate the setup. Do not add database clients, migrations, or seeds just because PostgreSQL is available.

## Home page and documentation

- Render a minimal hello world page, or the project title/acronym and subtitle if provided, with the subtitle underneath the title. Do not invent branding or copy a previous project's name.
- Show the version beneath the subtitle by importing only `version` from the root `package.json` in the server-rendered page. For `src/app/page.tsx`, use `import { version } from '../../package.json';` and render `Version {version}`. Do not hardcode the version or add a client component just for this.
- Preserve the existing package version, including any prerelease suffix.
- Complete the README's development instructions and list build, lint, formatting, typechecking, and test commands. Explain that dependency installation activates Husky and failed pre-commit checks block commits. Include Docker setup, the helper commands, port variables, and the destructive effect of the development teardown script as described in the Docker reference.

## Verify and report

Run formatting, linting, typechecking, the Vitest suite in run mode, and the production build. Exercise the installed Husky hook directly without creating a commit. Confirm the production home page responds and displays the expected title and package version.

If the sandbox prevents a Turbopack worker from binding a local port, use the available approval mechanism to rerun the build with appropriate permissions. Clear only generated build output if that failure was cached. Do not change bundlers merely to work around sandbox restrictions.

Keep tests focused on important behavior rather than styling or incidental attributes. Report the installed versions, checks that passed, and any actual limitations. Do not claim success for checks that could not run.
