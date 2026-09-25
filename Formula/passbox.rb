class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.13/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "8f6c86040b6f57e7166a07fb655b49437044053a3cb903c8ee8d4d0b4e1855c8"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.13/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "47d44d94da8eee5525eb350af9e8a5e8b972dc6a1946c04fa311ec606f2f89f3"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.13/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "8257f612d02a9c2936d6826dd01faf7d412201435610706e4f371f39c898bfdf"
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
