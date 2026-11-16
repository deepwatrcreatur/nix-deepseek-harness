# Notes for coding agents and contributors

Packages DeepSeek Harness (`@deepseek-ai/dsh`, the `dsh` CLI) from npm.

- Package is defined inline in `flake.nix` with `package.json` and
  `package-lock.json` pinning the npm dependency.
- Build and try it: `nix build`, then run `result/bin/dsh`.
- Update: change the `@deepseek-ai/dsh` dependency in `package.json`, run
  `npm install --package-lock-only` to refresh `package-lock.json`, bump
  `version` in `flake.nix` to match, then refresh `npmDepsHash` (set it to
  `lib.fakeHash`, build, copy the reported hash). The `version` in
  `package.json` belongs to the wrapper package and does not change.

<!-- nix-agent-guides:core BEGIN (v2). Synced from deepwatrcreatur/nix-agent-guides templates/agents-core.md by scripts/sync-agents-core.sh. Edit it there, not here. -->
## Shared conventions

Canonical, newest version:
https://raw.githubusercontent.com/deepwatrcreatur/nix-agent-guides/main/CONVENTIONS.md
If you can fetch it, read it before larger changes; where it differs from the
summary below, it is newer. This repo's own instructions above take
precedence over both.

Summary (offline fallback):

- **Comments explain why, not what.** Mark them `# WHY:`, `# GOTCHA:`,
  `# INVARIANT:`, `# SECURITY:`, `# UPSTREAM:` or `# TODO(#issue):`. One to
  three lines above the code they protect; longer reasoning goes in `docs/`
  with a pointer (`# WHY: docs/x.md#heading`). Never narrate the next line.
- **Before editing a file**, read its tags:
  `rg -n '# (WHY|GOTCHA|INVARIANT|SECURITY|UPSTREAM|TODO)' <file>`.
  Fix or delete any tag your change makes untrue.
- **Exported Nix functions** get RFC 145 doc comments (`/** ... */`).
- **Validate before committing:** the narrowest `nix build` first, then
  `nix flake check`; read all output. Run `bash -n`/`shellcheck` on shell
  generated from Nix. Exit code 0 is not proof the change worked.
- **Same change, same PR:** behaviour changes come with docs and a check.
- **Never commit secrets**, and do not deploy to or change live hosts unless
  asked.
<!-- nix-agent-guides:core END -->
