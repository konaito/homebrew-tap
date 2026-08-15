class Opttab < Formula
  desc "Option+Tab window switcher for macOS - reaches windows across Spaces"
  homepage "https://konaito.github.io/opttab/"
  url "https://github.com/konaito/opttab/releases/download/v0.2.0/opttab-0.2.0-universal.tar.gz"
  sha256 "bca233afa3540d86a1a32956839246ed86062253c11e7334220b85639f63253a"
  license "MIT"

  # formula では `macos: :sonoma` が「Sonoma以上」の意味。
  # cask の `">= :sonoma"` 構文は formula では通らない。
  depends_on macos: :sonoma

  def install
    bin.install "opttab"
  end

  # launchd が起動する実体は var/opttab/opttab に固定する。
  # macOS は非バンドルバイナリの TCC 許可を「解決後の実パス」で識別するため、
  # Cellar のバージョン付きパスから起動すると brew upgrade のたびに
  # アクセシビリティと画面収録の許可が失われる。
  def post_install
    (var/"opttab").mkpath
    target = var/"opttab/opttab"
    # 実行中の Mach-O への上書きは ETXTBSY になる。
    # rm してから cp すれば inode は変わるがパスは同じなので許可は維持される。
    rm target if target.exist?
    cp bin/"opttab", target
    chmod 0755, target
  end

  service do
    run var/"opttab/opttab"
    keep_alive true
    log_path var/"log/opttab.log"
    error_log_path var/"log/opttab.log"
  end

  def caveats
    <<~EOS
      Start the service:
        brew services start opttab

      On first start, OptTab asks for Accessibility (required for the ⌥⇥ hotkey).
      Grant it in System Settings > Privacy & Security > Accessibility, for:
        #{var}/opttab/opttab

      Screen Recording is optional - without it the HUD shows icons
      instead of live thumbnails.

      Check the service and both permissions at once:
        opttab doctor

      After `brew upgrade opttab`, restart the service so the new binary runs:
        brew services restart opttab

      Migrating from the old menu bar app? Remove it FIRST:
        brew uninstall --cask opttab
        brew link opttab

      Two reasons it has to come first. The old .app and this service both
      install a CGEventTap and will fight over ⌥⇥; and while the cask is
      still installed it owns the name "opttab", so this formula installs
      without linking and `opttab doctor` never lands on your PATH.
      `brew link opttab` fixes an install that already happened.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opttab --version")
  end
end
