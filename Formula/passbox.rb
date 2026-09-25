class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.15/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "4965f258ace185ba541b95936962aac7df7bec8804ff68ca19a15f2b110968fd"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.15/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "9c397c8d443febc3592a8ae66fbea4f0391e781b3b12d096c41670ef64ca0795"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.15/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "a67bd904b82038d037afb1b68567f5147707b4c1a135af741c87650058187f3c"
  end

  # Source builds stay available for anyone who would rather compile what they can read
  head do
    url "https://github.com/gabrielkoerich/passbox.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "passbox"
    end
  end

  def caveats
    <<~EOS
      Run `passbox init` to create the store at ~/.passbox. On a Mac it binds to
      the Secure Enclave and asks for nothing else.

      The store opens on that Mac only. Lose it and the secrets are gone.
      `passbox sync --enable` asks how a copy should be opened, a passphrase or
      a YubiKey, then asks where it goes.

      Install rclone only if you choose an rclone remote. iCloud Drive, a plain
      directory and a git remote need no extra tools.
    EOS
  end

  test do
    assert_match "passbox", shell_output("#{bin}/passbox --version")
  end
end
