cask "opttab" do
  version "0.1.0"
  sha256 "531527fe25991aace94ee2509be387573352a71469dbb3d7d8d08eabce04d61c"

  url "https://github.com/konaito/opttab/releases/download/v#{version}/OptTab-#{version}.zip"
  name "OptTab"
  desc "Option+Tab window switcher for macOS - reaches windows across Spaces"
  homepage "https://konaito.github.io/opttab/"

  depends_on macos: ">= :sonoma"

  app "OptTab.app"

  caveats <<~EOS
    First launch asks for Accessibility (required) and Screen Recording
    (optional - thumbnails). Enable "Launch at Login" from the menu bar icon.
  EOS
end
