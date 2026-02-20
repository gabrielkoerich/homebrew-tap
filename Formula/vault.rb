class Vault < Formula
  desc "Lock down sensitive files with age encryption"
  homepage "https://github.com/gabrielkoerich/vault"
  url "https://github.com/gabrielkoerich/vault/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "6de207ea2ebdb885f1e5e13e5e1d27f78a377f166f112bb62a9cf922b001e396"
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
