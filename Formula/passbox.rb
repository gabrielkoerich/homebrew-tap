class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.6/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "ba5f52d12ac68d6042fd71d0ba55a7be745e80fb669fd876f38d7147724d3fb2"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.6/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "7f758dfcb4d627f1d5716f3b175b3c7d3577a736e72800276356dfa7c66b6753"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.6/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "fef28581a5140ab34efc48afb4a7b301137baf206c0ba78ca265cf7ca7c93959"
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
