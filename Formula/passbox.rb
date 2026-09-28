class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.27"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.27/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "7c16fe453df467913d5bc9166e06e0b35202243d7c8ff7ba0dfdce9c3100a8d3"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.27/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "21b352364c80ed4175bae364b465e565f83a7734a645fe4ea0a30469c3a8731a"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.27/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "4a714b6adcc149d622612df08c532b7f53faf65a4bb21209bafbdc2c71dabfc8"
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
