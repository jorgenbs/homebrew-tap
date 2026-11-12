cask "clipboard-history" do
  version "0.1.0"
  sha256 "86765c222d6d82377374859d556e7e538007afcbf0b63d904b00659bc499f54b"

  url "https://api.github.com/repos/jorgenbs/clipboard-history/releases/assets/739335758",
      header: [
        "Accept: application/octet-stream",
        "Authorization: Bearer #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")}",
      ]
  name "Clipboard History"
  desc "Menu bar clipboard history with search, preview and auto-paste"
  homepage "https://github.com/jorgenbs/clipboard-history"

  depends_on macos: :sonoma

  app "Clipboard History.app"

  # The app is self-signed, not notarized. Removing the quarantine flag lets it open without
  # a Gatekeeper prompt. Only do this for apps you trust (this one is built by your own CI).
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Clipboard History.app"],
        writable_paths: ["Clipboard History.app"],
        writable_base:  :appdir,
        must_succeed:   false
  end

  uninstall quit: "com.jorgenbs.ClipboardHistory"

  zap trash: [
    "~/Library/Application Support/ClipboardHistory",
    "~/Library/Preferences/com.jorgenbs.ClipboardHistory.plist",
  ]

  caveats <<~EOS
    Clipboard History lives in the menu bar. Open it with ⌥⌘C.

    Installing and upgrading need HOMEBREW_GITHUB_API_TOKEN set to a token that can read
    jorgenbs/clipboard-history, for example: HOMEBREW_GITHUB_API_TOKEN=$(gh auth token) brew upgrade

    Auto-paste needs Accessibility access:
      System Settings › Privacy & Security › Accessibility › enable "Clipboard History"

    If auto-paste stops working after an upgrade, remove the app from that list (–) and add it again.
    After upgrading, start the app again from /Applications (or enable "Launch at login" in its settings).
  EOS
end
