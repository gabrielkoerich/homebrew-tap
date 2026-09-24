class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.5/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "1d3a33049f6d31cc1511cb8e7299889814a4ea7d17a828a61f05b3b753c84227"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.5/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "b493d6a684c57ea3187470435496911828a47167c598feee01b4013a99b69457"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.5/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "0f941c9a978a7bae536383b6c0127600137105db908f17fc574d9eace795908e"
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
