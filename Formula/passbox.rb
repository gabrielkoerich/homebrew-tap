class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.12/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "64fe65437c6f531c63a85bb4f459764da8da6af70c1c01a550bcf0fabe87524a"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.12/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "81e93ea07b817b55eae5cca6244439dbc185f08ff171bec2c3a46ba0681c2738"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.12/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "af49386c82b2e9f0610d4a287b779a1059020f0c4a45839d4218ea538cb30ff4"
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
