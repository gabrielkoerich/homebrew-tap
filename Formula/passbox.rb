class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.23"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.23/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "832dbd1ee338ed85750e29beec25dc90e572cf1d661eba32db3a291ca72a59d3"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.23/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "1f794071f03eb0a687e8a336b94c86a16c0ab526e1099771a85af8d9053928c0"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.23/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "8ffe1990a96e5006ece543389eaa609165bd298a0b93584784f86e23c1e73f36"
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
