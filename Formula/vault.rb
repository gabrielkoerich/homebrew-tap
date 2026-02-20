class Vault < Formula
  desc "Lock down sensitive files with age encryption"
  homepage "https://github.com/gabrielkoerich/vault"
  url "https://github.com/gabrielkoerich/vault/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "947fd7af76c69915eba94c6629e4f1c5c6c54169604bc022f100c8ba7f0a525e"
  head "https://github.com/gabrielkoerich/vault.git", branch: "main"
  license "MIT"

  depends_on "age"
  depends_on "fd"
  depends_on "ripgrep"

  def install
    bin.install "vault"
    pkgshare.install "scan.yml"
  end

  def caveats
    <<~EOS
      Run `vault scan` to auto-detect sensitive paths, then `vault lockdown` to encrypt them.

      Edit ~/.config/vault/scan.yml to customize what gets scanned.
    EOS
  end

  test do
    assert_match "vault", shell_output("#{bin}/vault version")
  end
end
