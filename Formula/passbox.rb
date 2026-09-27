class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.17/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "9a7a1d9986cd3769cc7fd61a3f94d5d4358dac433a37e0825a9192db6573b800"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.17/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "b579ab774794479e5a07af47deaaf988dd04a354b6cc73ec3d454f7998776383"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.17/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "4d8361de4da732516a8e5b9f249a04a437dcb99f835e5c75dac985b7391218a7"
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
