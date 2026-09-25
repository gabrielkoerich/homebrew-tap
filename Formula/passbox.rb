class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.14/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "8b9baf95b748065b69f8c46f7b14708a40c102975c67e5e702b0546676dfe680"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.14/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "085253b135b5addeeb6de122a695ef88b3106f48a690de08263becf2394a9db5"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.14/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "b4d89b72f61ce31ddf985121e8d2c5b4a25d50146f682650b8642c9d33a8fbf0"
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
