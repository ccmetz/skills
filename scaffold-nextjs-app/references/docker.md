# Docker starter setup

Use the files in [assets/docker](../assets/docker/) as the preferred baseline. These capture the user's Docker setup from the source project; keep the stage names, Compose profiles, and helper workflow. Follow explicit project instructions when they differ.

## Copy and adapt

Copy `Dockerfile`, `.dockerignore`, `docker-compose.yml`, `env.example`, and the files under `scripts/` to the same paths in the project. Replace `__PROJECT_SLUG__` with the target project's lowercase Docker-safe slug in container names, image names, volumes, networks, the development group, and the example database user, password, and database name. Do not copy FPC branding or the source project's `.env` or credentials. Mark the scripts executable.

Keep an existing `.env` intact. For a new local setup, copy `env.example` to `.env` and ensure `.env` is Git-ignored while `env.example` remains tracked. Preserve its comments, local development database defaults, `DATABASE_URL`, and port overrides. Keep the `$POSTGRES_USER`, `$POSTGRES_PASSWORD`, and `$POSTGRES_DB` references in the connection string so Compose can expand them; `postgres` is the database service hostname inside the Docker network. Configure production credentials separately from these local example values. Do not copy a real `.env` into the skill or generated templates.

Match both Node image tags to the selected compatible runtime major and keep the Alpine variant. The bundled Node 24 and PostgreSQL 18 tags reflect the source setup; verify current compatibility when scaffolding instead of treating those versions as permanent. The PostgreSQL 18 volume mount is `/var/lib/postgresql`; check the [official image's data layout](https://hub.docker.com/_/postgres) before changing its major. Preserve a project's existing database version and volume rather than silently upgrading persisted data.

This template uses npm and `package-lock.json`: `HUSKY=0 npm ci` installs build dependencies without setting up Git hooks in the image. Adapt the lockfile and all install/build/start commands together only when the project explicitly uses another package manager.

## Preserve the layout

- `base`, `deps`, `development`, `builder`, and `production` stages. Keep Git in the development/build base and use a fresh Node image for production.
- Host `LOCAL_UID` and `LOCAL_GID` build arguments for development file ownership. Reuse an existing UID/GID when it matches a user/group in the image; the default UID 1000 already belongs to Node's user. Production runs as `node`.
- `postgres`, `dev`, and `prod` services, with `dev` and `prod` profiles. Both app services wait for PostgreSQL's health check. Preserve the `$$` escaping in that check so database credentials are expanded inside the container.
- A project network, a named PostgreSQL volume, and a named development `node_modules` volume. Development bind-mounts the repository into `/app`. Rebuilds do not automatically refresh a populated dependency volume; document a targeted refresh when dependencies change, without deleting database data.
- Bind application and database ports to `127.0.0.1`, with `LOCAL_APP_PORT`, `LOCAL_DB_PORT`, and image `TAG` overrides. These defaults are for local use; put a reverse proxy in front of a production app when deploying it.
- Service `env_file: .env` entries and `NODE_ENV` values. Run helper scripts from the project root internally so Compose automatically reads the root `.env` for interpolation; do not add a redundant CLI `--env-file` flag.
- Keep `WATCHPACK_POLLING=true` in the development template as the user's preference for mounted volumes. It affects Watchpack consumers, not all Turbopack source watching. Do not reintroduce the obsolete pnpm-related `CI=true` setting.
- Keep the migration/seed TODO as a comment. Do not implement migrations, seeds, or application database access during scaffolding.

## Standalone production and build context

Merge `output: 'standalone'` into the existing Next.js config, preserving Tailwind/Turbopack settings and other options. Do not replace the entire config with a copied source-project config. See [Next.js output documentation](https://nextjs.org/docs/app/api-reference/config/next-config-js/output).

The production image runs `node server.js`, sets `NODE_ENV=production`, `PORT=3000`, and `HOSTNAME=0.0.0.0`, and copies `.next/standalone`, `.next/static`, and `public`. The builder creates an empty `public` directory so that copy also works before the project has public assets. Preserve explanatory comments from the source template.

Keep `.env*`, dependencies, generated output, Git metadata, and other listed files out of the image build context. Match the test/config exclusions to the Vitest files actually generated, including `vitest.setup.ts`. Keep runtime configuration separate from the build; public `NEXT_PUBLIC_*` values are fixed during the build and must be supplied then if the app uses them.

## Helper commands and README

Preserve these commands, using portable `#!/bin/bash` scripts, `set -e`, quoted paths, and project-root resolution:

- `./scripts/build-dev.sh [--no-cache] [--pull]`: build the development profile with the host UID/GID.
- `./scripts/start-dev.sh`: build, then start the development profile in the foreground.
- `./scripts/start-prod.sh`: build and start the production profile in the foreground.
- `./scripts/destroy-dev.sh`: run `docker compose --profile dev down -v`. This deletes the project's named volumes, including PostgreSQL data; explain that clearly in the README. Use `docker compose --profile dev down` when retaining data is desired.
- `./scripts/destroy-prod.sh`: run `docker compose --profile prod down -v`. This deletes the project's named volumes, including PostgreSQL data; explain that clearly in the README. Use `docker compose --profile prod down` when retaining data is desired.

Document copying/configuring `.env`, default URLs and port overrides, Docker and non-Docker development, and Docker and non-Docker production commands. Keep the non-Docker `npm start` behavior supplied by Next.js.

## Verify

Run `bash -n` on all copied scripts. Validate Compose with a disposable example environment and build the development and production targets. Check host UID/GID reuse if the host or template defaults use UID 1000. Smoke-test the standalone app and its referenced static assets; confirm it runs as a non-root user. Check PostgreSQL becomes healthy using a disposable Compose project and volume. Never run the destructive helper against the user's real database merely to validate the scaffold. Report a missing Docker daemon or any unrun checks accurately.

When checking the template itself, stub Docker in a temporary directory to verify script command construction, project-root resolution, failure handling, and flag forwarding without starting services or deleting volumes.
