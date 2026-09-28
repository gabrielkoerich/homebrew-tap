class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.32"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.32/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "05fe59582c21ccba69e7eabd80b33215eda4983621b9b4629c9b77ce8e04ae9c"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.32/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "c1e96e953b9e58d491e81cd4ddbf747ec9ae581a812732cc48f026b09705fa15"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.32/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "9136c88b03247c513823ef477c4b760db587b1f74e42c5bd92c6bce47512bf78"
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
