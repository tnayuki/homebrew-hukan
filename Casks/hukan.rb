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
  version "0.2.2"
  sha256 "84257ed59e7a0e603d43d018419317e20e2c0e50c9c5b54945643fbf0595fedf"

  url "https://github.com/tnayuki/hukan/releases/download/v#{version}/Hukan.zip"
  name "hukan"
  desc "Single-window frontend for supervising coding agents running in parallel"
  homepage "https://github.com/tnayuki/hukan"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  app "Hukan.app"

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
