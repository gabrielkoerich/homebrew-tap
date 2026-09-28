class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.22"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.22/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "152d247dc293ca839492f46ba2541a4895b213b8a4fc081b2c8b45a05afe046d"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.22/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "901ddee710ce8a457db0f5bad4fb945d6b241446e18fa35e81ca4f2a2f89364e"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.22/passbox-x86_64-unknown-linux-musl.tar.gz"
    sha256 "ed5597c5af63445e6da1b01974acf07ef4852ff45c63da7fd51799f10558031b"
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
