class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.43"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.43/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "5771416a039150e0a3ef5c349fd9d6315fbaddf85b3580e36eeaeabbf5bc1dd1"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.43/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "7755f1f50b31087d70a2c76dcc11c024d0f8747aefd179da456df3030d17e5cc"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.43/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "d5ae0ffe9f8ff4d3b0e8ea95c9b40315da7be83d5014e079d4e88215b8fb6bde"
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
