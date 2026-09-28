class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.34"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.34/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "1b54fd24ada167ba76a8506de3f0a69a006c44dc6e70590efa5df3c867776a09"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.34/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "7ee16701a8e5aac7bb4600b135e62ab6f1888ff501e50145efd66f09f4640c7e"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.34/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "f4805cdacdef2869cfc1f92dc5ce6da7ccd211017be0cd7ff711291d015917b3"
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
