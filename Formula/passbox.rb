class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.11/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "e9892a428e7bae2bec152c1023944e16e960fe0ca18df999dc9cad60e6d1a482"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.11/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "998b49fe6e0fc8dcd32c6d3eb21f2d757a98e5fd1858c09bef9700ac506313fd"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.11/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "edfd2b6296818561c50f95b41c17887fdfffdbd0705c565d26e2d1c353a9632e"
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
