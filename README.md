# homebrew-hukan

Homebrew tap for [hukan](https://github.com/tnayuki/hukan) — a macOS app for supervising coding
agents running in parallel, from a single window.

```sh
brew tap tnayuki/hukan
brew install --cask hukan
```

The cask installs a prebuilt, ad-hoc-signed `Hukan.app` from the GitHub Release of hukan's
matching `vX.Y.Z` tag and strips the Gatekeeper quarantine so it launches. hukan spawns the
Claude Code CLI (`claude`) per session, so
[install that separately](https://docs.anthropic.com/en/docs/claude-code).

The `version` and `sha256` here are updated by hand once that Release exists — nothing commits
to this repository automatically.
