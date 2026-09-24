class Passbox < Formula
  desc "Password store that asks for a fingerprint before an agent reads a secret"
  homepage "https://github.com/gabrielkoerich/passbox"
  version "0.13.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.7/passbox-aarch64-apple-darwin.tar.gz"
      sha256 "793a6b9baab4e0d38ca6ea497143398ffe4872541c7cd992c57cfa8e6853cab5"
    end
    on_intel do
      url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.7/passbox-x86_64-apple-darwin.tar.gz"
      sha256 "d8dafae647f17e298f248c4390ad6e1a2d794071ae94d58bfdf7a3ed6b5646a3"
    end
  end

  # Linux builds without the host feature, so it carries no Enclave and no broker server
  on_linux do
    url "https://github.com/gabrielkoerich/passbox/releases/download/v0.13.7/passbox-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "2b4d761df9af7c4425121dc0c5d465d0d33cdf9796a1fbcff27e64e5c2da948b"
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
