class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.33"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.33/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "1469ba35228495d94ac7299e92e4f67803cac37e809610022b3cc21d47ac4000"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.33/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "06f0c6969814cee490b6cf54379554ed226063959cccc5a732051fbb9912cb5d"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.33/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "17b212eb5f595bb82c7e8f68c5a1d12e05060d465f8e7cee021316a0ac5d81c3"
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
