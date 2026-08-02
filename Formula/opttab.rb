class Opttab < Formula
  desc "Option+Tab window switcher for macOS - reaches windows across Spaces"
  homepage "https://konaito.github.io/opttab/"
  url "https://github.com/konaito/opttab/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "930849165aba181606e738744ae4828884dce98141bd72b934bc34edd45191b1"
  license "MIT"

  depends_on :macos

  def install
    system "bash", "Scripts/bundle.sh", "--build-only"
    prefix.install "build/OptTab.app"
  end

  def caveats
    <<~EOS
      OptTab.app was built locally (no Gatekeeper quarantine). Install it with:
        cp -R "#{opt_prefix}/OptTab.app" ~/Applications/
        open ~/Applications/OptTab.app
      First launch asks for Accessibility (required) and Screen Recording (optional).
    EOS
  end

  test do
    assert_predicate prefix/"OptTab.app/Contents/MacOS/OptTab", :exist?
  end
end
