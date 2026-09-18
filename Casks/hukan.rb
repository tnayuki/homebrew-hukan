# typed: false
# frozen_string_literal: true

# Homebrew Cask for hukan.
#
# Each release is a `vX.Y.Z` tag in the hukan repository, built and published as
# that tag's GitHub Release; this file names the version and the zip's sha256,
# and the two lines holding them are written by that tag's own workflow — which
# is the one place the archive's hash is known without downloading it back.
#
#   brew tap tnayuki/hukan
#   brew install --cask hukan
cask "hukan" do
  version "1.1.3"
  sha256 "e49468753d00489cdc203c16217a39e6caee0a10711153198b7d6ce6d62b5e9c"

  url "https://github.com/tnayuki/hukan/releases/download/v#{version}/Hukan.zip"
  name "hukan"
  desc "Single-window frontend for supervising coding agents running in parallel"
  homepage "https://github.com/tnayuki/hukan"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app is arm64 only: Homebrew stopped building bottles for Intel macOS, so the machine a
  # universal build was for is one that can no longer install the CLI half of what hukan needs.
  # Declared rather than left to fail at launch — without it an Intel machine installs a bundle
  # it cannot execute, and the error it gets says nothing about why.
  depends_on arch: :arm64
  depends_on macos: :sequoia

  # The binary is the CLI: `hukan <path>` opens a directory or a file in the window, and
  # `--wait` returns when its tab closes, which is what makes it usable as $EDITOR from any
  # shell. It ships inside the bundle — hukan's own terminals name it by absolute path and
  # need nothing installed — so the stanza is only for the shells outside.
  app "Hukan.app"
  binary "#{appdir}/Hukan.app/Contents/Resources/hukan"

  # The bundle is ad-hoc signed (no Developer ID); strip the quarantine xattr so
  # Gatekeeper doesn't block first launch. Homebrew 7 retired the `postflight` Ruby block for
  # this declarative steps DSL, which is not the cask's own scope: the stanzas above interpolate
  # `appdir` as Ruby, while in here it is no method at all and the path is Homebrew's own
  # `{{appdir}}` template, expanded when the step runs rather than when the cask is read.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-d", "-r", "com.apple.quarantine", "{{appdir}}/Hukan.app"]
  end

  # Only the preferences: since macOS 15 — the floor above — AppKit's saved window state lives
  # under ~/Library/Daemon Containers in a UUID-named, TCC-protected directory, so the path a
  # cask could name is one nothing has written to on any system this runs on.
  zap trash: "~/Library/Preferences/dev.tnayuki.Hukan.plist"

  # hukan drives the `claude` CLI; it must be on PATH for sessions to start.
  caveats <<~EOS
    hukan spawns the Claude Code CLI (`claude`) per session. Install it separately:
      https://docs.anthropic.com/en/docs/claude-code
  EOS
end
