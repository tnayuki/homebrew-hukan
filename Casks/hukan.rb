# typed: false
# frozen_string_literal: true

# Homebrew Cask for hukan.
#
# Each release is a `vX.Y.Z` tag in the hukan repository, built and published as
# that tag's GitHub Release; this file names the version and the zip's sha256,
# and is updated by hand once the Release exists.
#
#   brew tap tnayuki/hukan
#   brew install --cask hukan
cask "hukan" do
  version "0.1.0"
  sha256 "cb85ef18626c4eb8c1a94d226b3b7f6e43927da02232fb064d4e9a495f861ad3"

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
