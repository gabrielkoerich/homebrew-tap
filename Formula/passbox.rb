class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.41"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.41/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "b6457c92895c1f127f18c028177dfdf4f26fb02317a6643748697a46148236cb"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.41/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "1f43af89cb72cc5eef12140cd259166140c920d9ca8534ce6d75baee1eb3c3ca"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.41/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "11e2ca818166b9e30f0ae1addd164f48ff41470784e3940dda838a72e23774ef"
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
