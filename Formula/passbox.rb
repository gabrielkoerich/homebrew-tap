class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.42"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.42/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "91252758836563656b3504676e8731403ab66212ed910c01170ee3f821bb2729"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.42/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "cb03f424fb0108a3042c8cf2c1170992119d6a024fa9325568a3003b947258a6"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.42/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "e6b9bec2ab6489ec57942dcff71ff6f9e8da4900b13f1ff0df2a086df388e4f4"
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
