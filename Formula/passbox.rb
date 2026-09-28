class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.35"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.35/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "b4a8903a4aba3116442af9bbc6b1730212d34f58f0eb08c7fc4415615e1db20d"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.35/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "109cf232ec8e9a8301605ee7a345a32345f27b2cea89665fbd594219af4d22a0"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.35/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "404816cefcf32c29e4a209be15107867cdee95eefd85c1b88fffd6083156f64a"
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
