class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.26"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.26/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "79c6d3379fbbf8acb63e4bca0abe821d4326378a52f0a0315011dd9fdc5a4f60"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.26/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "7297a291142406f82e0452e8ec00c1d9f5f5d9f81cada2485aa637f5ddffc977"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.26/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "0c283f69b3f3b43770948ab1efcbc5b31dc05f1ee165cc69d2bf231f7f900aac"
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
