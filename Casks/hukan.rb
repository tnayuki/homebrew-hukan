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
  version "0.8.0"
  sha256 "83cf9eda82269c3cc91ed8024b7827f478012a87c01a24a21654f814acd095ee"

  url "https://github.com/tnayuki/hukan/releases/download/v#{version}/Hukan.zip"
  name "hukan"
  desc "Single-window frontend for supervising coding agents running in parallel"
  homepage "https://github.com/tnayuki/hukan"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  # The binary is the CLI: `hukan <path>` opens a directory or a file in the window, and
  # `--wait` returns when its tab closes, which is what makes it usable as $EDITOR from any
  # shell. It ships inside the bundle — hukan's own terminals name it by absolute path and
  # need nothing installed — so the stanza is only for the shells outside.
  app "Hukan.app"
  binary "#{appdir}/Hukan.app/Contents/Resources/hukan"

  # The bundle is ad-hoc signed (no Developer ID); strip the quarantine xattr so
  # Gatekeeper doesn't block first launch.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-d", "-r", "com.apple.quarantine", "#{appdir}/Hukan.app"],
                   sudo: false
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
