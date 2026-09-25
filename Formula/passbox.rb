class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.10/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "ea2d99107987cf5651287094582a42c9d8ba9b65ea1efcba2cb789cbc15b512a"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.10/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "699eb9873e0b69de0a285a1a644c992f1445d7bfa5cedda6f1c062898bd0ea22"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.10/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "a3525b5489fb97dd2fec026715e29711bb16e1b1ad67d07e67cb63c1a5a0847c"
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
