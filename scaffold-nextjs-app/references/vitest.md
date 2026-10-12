# Set up Vitest

Follow the current [Next.js Vitest guide](https://nextjs.org/docs/app/guides/testing/vitest) and [Vitest configuration docs](https://vitest.dev/config/). Add this tooling to the chosen starter rather than replacing it with a different example app.

## Dependencies and config

Install compatible stable releases of `vitest`, `vite`, `@vitejs/plugin-react`, `jsdom`, `@testing-library/react`, `@testing-library/dom`, and `@testing-library/jest-dom` as development dependencies. Check Node requirements and Vite peer compatibility before choosing versions. Do not add coverage or browser-mode dependencies unless requested.

Create `vitest.config.mts` at the project root:

```ts
import react from '@vitejs/plugin-react';
import { defineConfig } from 'vitest/config';

export default defineConfig({
  plugins: [react()],
  resolve: {
    tsconfigPaths: true,
  },
  test: {
    environment: 'jsdom',
    setupFiles: ['./vitest.setup.ts'],
  },
});
```

Use Vite's built-in [tsconfig path resolution](https://vite.dev/config/shared-options#resolve-tsconfigpaths) to read the project's aliases instead of duplicating a fixed `@/` mapping. If a required older Vite version lacks this option, use `vite-tsconfig-paths` as in the Next.js guide. Do not configure both. Keep Vitest globals disabled and import test helpers explicitly.

Create `vitest.setup.ts` at the project root:

```ts
import '@testing-library/jest-dom/vitest';
import { cleanup } from '@testing-library/react';
import { afterEach } from 'vitest';

// Clear the rendered page between tests when Vitest globals are disabled.
afterEach(cleanup);
```

Use the [Vitest-specific jest-dom import](https://github.com/testing-library/jest-dom#with-vitest) for matchers and their types. Ensure the setup and config files are included in TypeScript checking; the scaffold's `**/*.ts` and `**/*.mts` patterns normally cover them.

## Scripts and first test

Add `test` for a single run and `test:watch` for development:

```json
{
  "test": "vitest run",
  "test:watch": "vitest"
}
```

Keep the Husky hook's lint, formatting, and typechecking commands. Add tests to the hook only if requested; use the non-watch `test` command if doing so.

Add one starter test that renders the synchronous home page and verifies its title, subtitle if present, and version from `package.json`. Adapt names and paths to the generated project. For example, a hello world page under `src/app` can use `src/app/page.test.tsx`:

```tsx
import { render, screen } from '@testing-library/react';
import { expect, test } from 'vitest';
import { version } from '../../package.json';
import Home from './page';

test('shows the home page and current app version', () => {
  render(<Home />);
  expect(screen.getByRole('heading', { level: 1, name: 'Hello world!' })).toBeInTheDocument();
  expect(screen.getByText(`Version ${version}`)).toBeInTheDocument();
});
```

Test user-visible content and important behavior. Do not test classes, colors, styling, or inconsequential attributes. Avoid snapshots for this starter. Do not add mocks unless the tested behavior needs them.

Check current framework support before testing async Server Components. If Vitest cannot render them, test their plain logic separately and use an E2E check for rendering when in scope; do not convert production components just to make a unit test pass.

Run `npm test`, then lint, format checks, and typechecking. Do not hide a missing starter test with `--passWithNoTests`.
