class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.30"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.30/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "784aae47d218e671d15a59b78b5bcda5bc755187fa9e13f5ec5864411f47e761"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.30/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "c68a88698a2cc3d6b61925bd48984496485fed27579bb4440df2c508312d940c"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.30/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "4e8749ca6c43e3bc4f1da06d5b1dc3b9be86d7a181e28b1f5088517d83f73cd9"
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
