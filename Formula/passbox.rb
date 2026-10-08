class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.14.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.14.0/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "e22158bab90d9ed6b69632268c1101f1ab81b6824bf3d44a53e0aa19ed4572d9"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.14.0/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "6c9a9029a50a33086c954290ac2a513e470a01a6ec123c3335a1a8a7ebe943a8"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.14.0/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "1eb74169a8cf0eba41d268c0c3083211e530fe78bec2bcbb2f216e9b2f85d6c2"
  end

  # Source builds stay available for anyone who would rather compile what they can read
  head do
    url "https://github.com/gabrielkoerich/passbox.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
      system "codesign", "-s", "-", "--force", "--options", "runtime", bin/"passbox"
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
